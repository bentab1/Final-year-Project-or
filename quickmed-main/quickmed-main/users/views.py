from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .serializers import (
    RegisterSerializer, 
    UserProfileSerializer,
    ForgotPasswordSerializer,
    VerifyOTPSerializer,
    ResetPasswordSerializer,
    DoctorMatchSerializer,
    DoctorListSerializer,
    CustomTokenObtainPairSerializer,
    DoctorDistanceSearchSerializer,
    DoctorDistanceListSerializer
)
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.views import TokenObtainPairView
from .models import PasswordResetOTP
from django.core.mail import send_mail
from django.conf import settings
import random
from datetime import timedelta
from django.utils import timezone
from django.db.models import Q, Case, When, IntegerField, Value
from rest_framework_simplejwt.tokens import RefreshToken
from django.db.models import F, FloatField
from django.db.models.functions import (
    ACos, Cos, Sin, Radians
)

from .utils import get_today_day,available_now_queryset
# from .utils import DEFAULT_WORKING_DAYS

User = get_user_model()

class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer

class LoginView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

class ProfileView(APIView):
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        user = request.user
        serializer = UserProfileSerializer(user)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    def put(self, request):
        user = request.user
        serializer = UserProfileSerializer(user, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ForgotPasswordView(APIView):
    def post(self, request):
        serializer = ForgotPasswordSerializer(data=request.data)
        
        if serializer.is_valid():
            email = serializer.validated_data['email']
            
            try:
                user = User.objects.get(email=email)
                
                # Generate 6-digit OTP
                otp = random.randint(100000, 999999)
                
                # Delete any existing OTPs for this user
                PasswordResetOTP.objects.filter(user=user).delete()
                
                # Create new OTP
                expires_at = timezone.now() + timedelta(minutes=10)
                PasswordResetOTP.objects.create(
                    user=user,
                    otp=otp,
                    expires_at=expires_at
                )
                
                # Send email
                try:
                    send_mail(
                        subject='Password Reset OTP',
                        message=f'Your OTP for password reset is: {otp}\n\nThis OTP will expire in 10 minutes.',
                        from_email=settings.DEFAULT_FROM_EMAIL,
                        recipient_list=[email],
                        fail_silently=False,
                    )
                    
                    return Response(
                        {"message": "OTP sent successfully to your email"},
                        status=status.HTTP_200_OK
                    )
                except Exception as e:
                    return Response(
                        {"error": "Failed to send email. Please try again."},
                        status=status.HTTP_500_INTERNAL_SERVER_ERROR
                    )
                    
            except User.DoesNotExist:
                # Don't reveal if email exists or not for security
                return Response(
                    {"message": "If the email exists, an OTP has been sent"},
                    status=status.HTTP_200_OK
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class VerifyOTPView(APIView):
    def post(self, request):
        serializer = VerifyOTPSerializer(data=request.data)
        
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp = serializer.validated_data['otp']
            
            try:
                user = User.objects.get(email=email)
                otp_record = PasswordResetOTP.objects.get(user=user, otp=otp)
                
                # Check if OTP is expired
                if timezone.now() > otp_record.expires_at:
                    otp_record.delete()
                    return Response(
                        {"error": "OTP has expired. Please request a new one."},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                
                # Mark OTP as verified
                otp_record.is_verified = True
                otp_record.save()
                
                return Response(
                    {"message": "OTP verified successfully"},
                    status=status.HTTP_200_OK
                )
                
            except (User.DoesNotExist, PasswordResetOTP.DoesNotExist):
                return Response(
                    {"error": "Invalid OTP or email"},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ResetPasswordView(APIView):
    def post(self, request):
        serializer = ResetPasswordSerializer(data=request.data)
        
        if serializer.is_valid():
            email = serializer.validated_data['email']
            otp = serializer.validated_data['otp']
            new_password = serializer.validated_data['new_password']
            
            try:
                user = User.objects.get(email=email)
                otp_record = PasswordResetOTP.objects.get(
                    user=user, 
                    otp=otp,
                    is_verified=True
                )
                
                # Check if OTP is expired
                if timezone.now() > otp_record.expires_at:
                    otp_record.delete()
                    return Response(
                        {"error": "OTP has expired. Please request a new one."},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                
                # Reset password
                user.set_password(new_password)
                user.save()
                
                # Delete OTP record
                otp_record.delete()
                
                return Response(
                    {"message": "Password reset successfully"},
                    status=status.HTTP_200_OK
                )
                
            except (User.DoesNotExist, PasswordResetOTP.DoesNotExist):
                return Response(
                    {"error": "Invalid OTP or email, or OTP not verified"},
                    status=status.HTTP_400_BAD_REQUEST
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class FindDoctorsView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        serializer = DoctorMatchSerializer(data=request.data)
        
        if serializer.is_valid():
            symptoms = serializer.validated_data['symptoms'].lower()
            medical_history = serializer.validated_data.get('medical_history', '').lower()
            
            # Split symptoms into individual keywords
            symptom_keywords = [s.strip() for s in symptoms.split(',') if s.strip()]
            
            # Build query to match doctors
            query = Q()
            for keyword in symptom_keywords:
                query |= Q(doctor_profile__specialization_illnes_symptoms__icontains=keyword)
                query |= Q(doctor_profile__specialization__icontains=keyword)
            
            # Get matching doctors
            doctors = User.objects.filter(
                user_type='doctor',
                doctor_profile__isnull=False
            ).filter(query).select_related('doctor_profile').distinct()
            
            # Calculate match score for each doctor
            doctors_with_scores = []
            for doctor in doctors:
                score = 0
                doctor_symptoms = doctor.doctor_profile.specialization_illnes_symptoms.lower()
                doctor_specialization = doctor.doctor_profile.specialization.lower()
                
                # Count matching keywords
                for keyword in symptom_keywords:
                    if keyword in doctor_symptoms:
                        score += 2  # Higher weight for symptoms match
                    if keyword in doctor_specialization:
                        score += 1  # Lower weight for specialization match
                
                doctor.match_score = score
                doctors_with_scores.append(doctor)
            
            # Sort by match score (highest first)
            doctors_with_scores.sort(key=lambda x: x.match_score, reverse=True)
            
            # Serialize and return
            response_serializer = DoctorListSerializer(doctors_with_scores, many=True)
            
            return Response({
                'count': len(doctors_with_scores),
                'symptoms_searched': symptoms,
                'doctors': response_serializer.data
            }, status=status.HTTP_200_OK)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]
    
    def post(self, request):
        try:
            refresh_token = request.data.get("refresh_token")
            
            if not refresh_token:
                return Response(
                    {"error": "Refresh token is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            token = RefreshToken(refresh_token)
            token.blacklist()
            
            return Response(
                {"message": "Logout successful"},
                status=status.HTTP_200_OK
            )
        except Exception as e:
            return Response(
                {"error": "Invalid token or token already blacklisted"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
class FindNearbyDoctorsView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = DoctorDistanceSearchSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        lat = serializer.validated_data["latitude"]
        lon = serializer.validated_data["longitude"]
        max_distance = serializer.validated_data.get("max_distance_km")

        doctors = (
            User.objects
            .filter(
                user_type="doctor",
                doctor_profile__latitude__isnull=False,
                doctor_profile__longitude__isnull=False
            )
            .annotate(
                distance_km=6371 * ACos(
                    Cos(Radians(lat)) *
                    Cos(Radians(F("doctor_profile__latitude"))) *
                    Cos(Radians(F("doctor_profile__longitude")) - Radians(lon)) +
                    Sin(Radians(lat)) *
                    Sin(Radians(F("doctor_profile__latitude")))
                )
            )
        )

        # Optional distance filter
        if max_distance:
            doctors = doctors.filter(distance_km__lte=max_distance)

        doctors = doctors.order_by("distance_km")

        response_serializer = DoctorDistanceListSerializer(doctors, many=True)

        return Response({
            "count": doctors.count(),
            "latitude": lat,
            "longitude": lon,
            "doctors": response_serializer.data
        }, status=status.HTTP_200_OK)

class AvailableDoctorsNowView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        doctors = User.objects.filter(
            user_type="doctor",
            doctor_profile__isnull=False
        )

        doctors = available_now_queryset(doctors)

        serializer = DoctorListSerializer(doctors, many=True)

        return Response({
            "count": doctors.count(),
            # "date": ,
            "time": timezone.localtime().strftime("%H:%M"),
            "doctors": serializer.data
        }, status=status.HTTP_200_OK)
