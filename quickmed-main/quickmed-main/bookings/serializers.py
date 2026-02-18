from rest_framework import serializers
from .models import Booking
from users.models import User,PatientProfile, DoctorProfile


class BookingSerializer(serializers.ModelSerializer):
    patientId = serializers.IntegerField(write_only=True, required=False)
    doctorId = serializers.IntegerField(write_only=True)
    
    # Read-only fields for displaying patient and doctor info
    patient_name = serializers.SerializerMethodField()
    doctor_name = serializers.SerializerMethodField()
    
    patient_latitude = serializers.SerializerMethodField()
    patient_longitude = serializers.SerializerMethodField()
    doctor_latitude = serializers.SerializerMethodField()
    doctor_longitude = serializers.SerializerMethodField()
    
    class Meta:
        model = Booking
        fields = [
            "id",
            "patientId",
            "doctorId",
            "patient_name",
            "doctor_name",
            "patient_latitude",
            "patient_longitude",
            "doctor_latitude",
            "doctor_longitude",
            "medical_history",
            "current_symptoms",
            "date",
            "time",
            "status",
            "created_at",
        ]
        read_only_fields = ["status", "created_at", "patient_name", "patient_latitude","patient_longitude","doctor_name","doctor_latitude","doctor_longitude"]

    def get_patient_name(self, obj):
        return obj.patient.user.get_full_name() or obj.patient.user.email

    def get_doctor_name(self, obj):
        return obj.doctor.user.get_full_name() or obj.doctor.user.email
    
       # 👇 ADD THESE METHODS
    def get_doctor_latitude(self, obj):
        return obj.doctor.latitude

    def get_doctor_longitude(self, obj):
        return obj.doctor.longitude

    def get_patient_latitude(self, obj):
        return obj.patient.latitude

    def get_patient_longitude(self, obj):
        return obj.patient.longitude

    def validate_doctorId(self, value):
        """Validate that the doctor exists"""
        try:
            User.objects.get(id=value, user_type="doctor")
        except User.DoesNotExist:
            raise serializers.ValidationError(
                f"Doctor with ID {value} does not exist."
            )
        return value

    def validate_patientId(self, value):
        """Validate that the patient exists (if provided)"""
        if value:
            try:
                PatientProfile.objects.get(id=value)
            except PatientProfile.DoesNotExist:
                raise serializers.ValidationError(
                    f"Patient with ID {value} does not exist."
                )
        return value

    def create(self, validated_data):
        patient_id = validated_data.pop("patientId", None)
        doctor_user_id = validated_data.pop("doctorId")
        
        doctor_user = User.objects.get(id=doctor_user_id,user_type="doctor")
        doctor_profile = doctor_user.doctor_profile

        validated_data["doctor"] = doctor_profile

        # If patientId is not provided, it should be set in perform_create
        if patient_id:
            validated_data["patient"] = PatientProfile.objects.get(id=patient_id)
        
        
        return Booking.objects.create(**validated_data)


class BookingStatusSerializer(serializers.ModelSerializer):
    """Serializer for updating booking status"""
    
    class Meta:
        model = Booking
        fields = ["id", "status", "date", "time"]
        read_only_fields = ["id", "date", "time"]
    
    def validate_status(self, value):
        """Validate that only approved/rejected/completed/no show statuses can be set by doctors"""
        valid_statuses = ['approved', 'rejected','completed','no show','cancelled']
        if value not in valid_statuses:
            raise serializers.ValidationError(
                f"Invalid status. Must be one of: {', '.join(valid_statuses)}"
            )
        return value