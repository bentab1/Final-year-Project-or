from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Booking
from .serializers import BookingSerializer, BookingStatusSerializer
from users.models import User, DoctorWorkingHour
from datetime import datetime, timedelta, time
from django.db.models import Q


class BookingViewSet(viewsets.ModelViewSet):
    serializer_class = BookingSerializer

    def get_queryset(self):
        user = self.request.user
        if user.user_type == "patient":
            return Booking.objects.filter(patient=user.patient_profile)
        if user.user_type == "doctor":
            return Booking.objects.filter(doctor=user.doctor_profile)
        return Booking.objects.none()

    def get_permissions(self):
        if self.action == "create":
            return [permissions.IsAuthenticated()]
        return [permissions.IsAuthenticated()]

    def perform_create(self, serializer):
        # Ensure only patient accounts can create booking
        if self.request.user.user_type != "patient":
            raise PermissionError("Only patients can create bookings")
        patient_profile = self.request.user.patient_profile
        serializer.save(patient=patient_profile)

    @action(detail=False, methods=['get'], url_path='patient-bookings')
    def patient_bookings(self, request):
        """
        Get all bookings for the authenticated patient
        GET /api/bookings/patient-bookings/
        """
        if request.user.user_type != "patient":
            return Response(
                {"error": "Only patients can access this endpoint"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        bookings = Booking.objects.filter(patient=request.user.patient_profile)
        serializer = self.get_serializer(bookings, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='doctor-bookings')
    def doctor_bookings(self, request):
        """
        Get all bookings for the authenticated doctor
        GET /api/bookings/doctor-bookings/
        """
        if request.user.user_type != "doctor":
            return Response(
                {"error": "Only doctors can access this endpoint"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        bookings = Booking.objects.filter(doctor=request.user.doctor_profile)
        serializer = self.get_serializer(bookings, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='available-slots')
    def available_slots(self, request):
        """
        Get available time slots for a doctor on a specific date
        GET /api/bookings/available-slots/?doctor_id=1&date=2026-02-15&duration=30
        
        Query Parameters:
        - doctor_id: ID of the doctor (User ID, not DoctorProfile ID)
        - date: Date in YYYY-MM-DD format (e.g., 2026-02-15)
        - duration: Appointment duration in minutes (default: 30)
        """
        doctor_user_id = request.query_params.get('doctor_id')
        date_param = request.query_params.get('date', '')
        duration = int(request.query_params.get('duration', 30))
        
        # Validate parameters
        if not doctor_user_id:
            return Response(
                {"error": "doctor_id is required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if not date_param:
            return Response(
                {"error": "date is required (format: YYYY-MM-DD)"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Parse and validate date
        try:
            booking_date = datetime.strptime(date_param, '%Y-%m-%d').date()
        except ValueError:
            return Response(
                {"error": "Invalid date format. Use YYYY-MM-DD (e.g., 2026-02-15)"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Validate doctor exists
        try:
            doctor_user = User.objects.get(id=doctor_user_id, user_type="doctor")
            doctor_profile = doctor_user.doctor_profile
        except User.DoesNotExist:
            return Response(
                {"error": "Doctor not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Get doctor's working hours for this specific date
        try:
            working_hour = DoctorWorkingHour.objects.get(
                doctor=doctor_profile,
                date=booking_date
            )
        except DoctorWorkingHour.DoesNotExist:
            return Response(
                {"error": f"Working hours not configured for {date_param}"},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Check if doctor is working on this date
        if not working_hour.is_working:
            return Response({
                "doctor_id": doctor_user_id,
                "doctor_name": doctor_user.get_full_name() or doctor_user.email,
                "date": date_param,
                "is_working": False,
                "message": f"Doctor is not available on {date_param}",
                "slots": [],
                "total_slots": 0,
                "available_count": 0
            })
        
        # Check if working hours are set
        if not working_hour.start_time or not working_hour.end_time:
            return Response(
                {"error": f"Working hours not properly configured for {date_param}"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Get existing bookings for this doctor on this date
        existing_bookings = Booking.objects.filter(
            doctor=doctor_profile,
            date=booking_date,
            status__in=['pending', 'approved']
        ).values_list('time', flat=True)
        
        # Generate all possible slots based on working hours
        available_slots = []
        start_time = working_hour.start_time
        end_time = working_hour.end_time
        
        # Create datetime objects for iteration
        current_time = datetime.combine(booking_date, start_time)
        end_datetime = datetime.combine(booking_date, end_time)
        
        while current_time < end_datetime:
            slot_time = current_time.time()
            
            # Check if this slot is available (not booked)
            is_available = slot_time not in existing_bookings
            
            slot_data = {
                "time": slot_time.strftime('%H:%M:%S'),
                "display_time": slot_time.strftime('%I:%M %p'),
                "is_available": is_available
            }
            
            available_slots.append(slot_data)
            current_time += timedelta(minutes=duration)
        
        return Response({
            "doctor_id": doctor_user_id,
            "doctor_name": doctor_user.get_full_name() or doctor_user.email,
            "date": date_param,
            "is_working": True,
            "working_hours": {
                "start_time": start_time.strftime('%H:%M:%S'),
                "end_time": end_time.strftime('%H:%M:%S'),
                "start_display": start_time.strftime('%I:%M %p'),
                "end_display": end_time.strftime('%I:%M %p')
            },
            "duration_minutes": duration,
            "slots": available_slots,
            "total_slots": len(available_slots),
            "available_count": sum(1 for slot in available_slots if slot['is_available'])
        })

    @action(detail=True, methods=['patch'], url_path='update-status')
    def update_status(self, request, pk=None):
        """
        Update booking status (doctors only)
        PATCH /api/bookings/{id}/update-status/
        Body: {"status": "approved"} or {"status": "rejected"}
        """
        booking = self.get_object()
        
        # Only doctors can update booking status
        if request.user.user_type != "doctor":
            return Response(
                {"error": "Only doctors can update booking status"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Ensure the doctor is updating their own booking
        if booking.doctor != request.user.doctor_profile:
            return Response(
                {"error": "You can only update your own appointments"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        serializer = BookingStatusSerializer(booking, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['patch'], url_path='cancel')
    def cancel_booking(self, request, pk=None):
        """
        Cancel a booking (patients only)
        PATCH /api/bookings/{id}/cancel/
        """
        booking = self.get_object()
        
        # Only patients can cancel their own bookings
        if request.user.user_type != "patient":
            return Response(
                {"error": "Only patients can cancel bookings"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Ensure the patient is cancelling their own booking
        if booking.patient != request.user.patient_profile:
            return Response(
                {"error": "You can only cancel your own bookings"},
                status=status.HTTP_403_FORBIDDEN
            )
        
        # Prevent cancelling already cancelled or rejected bookings
        if booking.status in ['cancelled', 'rejected']:
            return Response(
                {"error": f"Cannot cancel a {booking.status} booking"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        booking.status = 'cancelled'
        booking.save()
        serializer = self.get_serializer(booking)
        return Response(serializer.data)