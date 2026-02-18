# from rest_framework import serializers
# from django.contrib.auth import get_user_model
# from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
# from django.contrib.auth.password_validation import validate_password
# from .models import PatientProfile, DoctorProfile, DoctorWorkingHour
# # from .utils import WEEK_DAYS, DEFAULT_WORKING_DAYS

# User = get_user_model()

# class RegisterSerializer(serializers.ModelSerializer):
#     # Profile-specific fields
#     healthIssues = serializers.CharField(write_only=True, required=False, allow_blank=True)
#     specialization = serializers.CharField(write_only=True, required=False, allow_blank=True)
#     specialization_illnes_symptoms = serializers.CharField(write_only=True, required=False, allow_blank=True)
    
#     # Location fields for both patient and doctor
#     latitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
#     longitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
    
#     class Meta:
#         model = User
#         fields = [
#             "email", "username", "password",
#             "first_name", "last_name", "user_type",
#             "dob", "gender", "address", "city", "state", "zipCode", "country",
#             "healthIssues", "specialization", "specialization_illnes_symptoms",
#             "latitude", "longitude",
#         ]
#         extra_kwargs = {"password": {"write_only": True}}
    
#     def validate(self, data):
#         user_type = data.get('user_type')
        
#         # Validate that doctor provides specialization
#         if user_type == 'doctor':
#             if not data.get('specialization'):
#                 raise serializers.ValidationError({
#                     "specialization": "This field is required for doctors"
#                 })
#             if not data.get('specialization_illnes_symptoms'):
#                 raise serializers.ValidationError({
#                     "specialization_illnes_symptoms": "This field is required for doctors"
#                 })
        
#         return data
    
#     def create(self, validated_data):
#         # Extract profile-specific fields
#         health_issues = validated_data.pop('healthIssues', None)
#         specialization = validated_data.pop('specialization', None)
#         specialization_illnes_symptoms = validated_data.pop('specialization_illnes_symptoms', None)
#         latitude = validated_data.pop('latitude', None)
#         longitude = validated_data.pop('longitude', None)

#         password = validated_data.pop("password")

#         # Create user
#         user = User(**validated_data)
#         user.set_password(password)
#         user.save()

#         # Create profiles
#         if user.user_type == 'patient':
#             PatientProfile.objects.create(
#                 user=user,
#                 healthIssues=health_issues or '',
#                 latitude=latitude,
#                 longitude=longitude
#             )

#         elif user.user_type == 'doctor':
#             DoctorProfile.objects.create(
#                 user=user,
#                 specialization=specialization or '',
#                 specialization_illnes_symptoms=specialization_illnes_symptoms or '',
#                 latitude=latitude,
#                 longitude=longitude
#             )

#             # AUTO-CREATE 7 WORKING DAYS
#             # working_hours = [
#             #     DoctorWorkingHour(
#             #         doctor=doctor_profile,
#             #         day=day,
#             #         is_working=False
#             #     )
#             #     for day in WEEK_DAYS
#             # ]

#             # DoctorWorkingHour.objects.bulk_create(working_hours)

#         return user

# class PatientProfileSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = PatientProfile
#         fields = ["healthIssues", "latitude", "longitude"]

# class DoctorWorkingHourSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = DoctorWorkingHour
#         fields = ["date", "start_time", "end_time", "is_working"]

# class DoctorProfileSerializer(serializers.ModelSerializer):
#     working_hours = DoctorWorkingHourSerializer(many=True, required=False)

#     class Meta:
#         model = DoctorProfile
#         fields = [
#             "specialization",
#             "specialization_illnes_symptoms",
#             "latitude",
#             "longitude",
#             "working_hours"
#         ]

# class UserProfileSerializer(serializers.ModelSerializer):
#     patient_profile = PatientProfileSerializer(read_only=True)
#     doctor_profile = DoctorProfileSerializer(read_only=True)
    
#     # Write-only fields for updates
#     healthIssues = serializers.CharField(write_only=True, required=False, allow_blank=True)
#     specialization = serializers.CharField(write_only=True, required=False, allow_blank=True)
#     specialization_illnes_symptoms = serializers.CharField(write_only=True, required=False, allow_blank=True)
#     latitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
#     longitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
#     working_hours = DoctorWorkingHourSerializer(many=True, write_only=True, required=False)
    
#     class Meta:
#         model = User
#         fields = [
#             "id", "email", "username", "first_name", "last_name", "user_type",
#             "dob", "gender", "address", "city", "state", "zipCode", "country",
#             "patient_profile", "doctor_profile",
#             "healthIssues", "specialization", "specialization_illnes_symptoms",
#             "latitude", "longitude", "working_hours"
#         ]
#         read_only_fields = ["id", "email", "user_type"]
    
#     def update(self, instance, validated_data):
#         # Extract profile-specific fields
#         health_issues = validated_data.pop('healthIssues', None)
#         specialization = validated_data.pop('specialization', None)
#         specialization_illnes_symptoms = validated_data.pop('specialization_illnes_symptoms', None)
#         latitude = validated_data.pop('latitude', None)
#         longitude = validated_data.pop('longitude', None)
#         working_hours = validated_data.pop("working_hours", None)
        
#         # Update user fields
#         for attr, value in validated_data.items():
#             setattr(instance, attr, value)
#         instance.save()
        
#         # Update patient profile
#         if instance.user_type == 'patient':
#             if hasattr(instance, 'patient_profile'):
#                 if health_issues is not None:
#                     instance.patient_profile.healthIssues = health_issues
#                 if latitude is not None:
#                     instance.patient_profile.latitude = latitude
#                 if longitude is not None:
#                     instance.patient_profile.longitude = longitude
#                 instance.patient_profile.save()
        
#         # Update doctor profile
#         if instance.user_type == 'doctor':
#             if hasattr(instance, 'doctor_profile'):
#                 if specialization is not None:
#                     instance.doctor_profile.specialization = specialization
#                 if specialization_illnes_symptoms is not None:
#                     instance.doctor_profile.specialization_illnes_symptoms = specialization_illnes_symptoms
#                 if latitude is not None:
#                     instance.doctor_profile.latitude = latitude
#                 if longitude is not None:
#                     instance.doctor_profile.longitude = longitude
#                 instance.doctor_profile.save()
                
#                 # Update working hours - FIXED: Changed 'day' to 'date'
#                 if working_hours:
#                     for working_hour in working_hours:
#                         DoctorWorkingHour.objects.update_or_create(
#                             doctor=instance.doctor_profile,
#                             date=working_hour["date"],
#                             defaults={
#                                 "start_time": working_hour.get("start_time"),
#                                 "end_time": working_hour.get("end_time"),
#                                 "is_working": working_hour.get("is_working", False),
#                             }
#                         )
        
#         return instance

# class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
#     def validate(self, attrs):
#         # Replace username with email
#         attrs['username'] = attrs.get('email', '')
#         return super().validate(attrs)
    
#     @classmethod
#     def get_token(cls, user):
#         token = super().get_token(user)
#         # Add custom data inside token payload
#         token['user_type'] = user.user_type
#         token['email'] = user.email
#         token['first_name'] = user.first_name
#         token['last_name'] = user.last_name
#         return token

# class ForgotPasswordSerializer(serializers.Serializer):
#     email = serializers.EmailField()

# class VerifyOTPSerializer(serializers.Serializer):
#     email = serializers.EmailField()
#     otp = serializers.CharField(max_length=6, min_length=6)

# class ResetPasswordSerializer(serializers.Serializer):
#     email = serializers.EmailField()
#     otp = serializers.CharField(max_length=6, min_length=6)
#     new_password = serializers.CharField(write_only=True, validators=[validate_password])
#     confirm_password = serializers.CharField(write_only=True)
    
#     def validate(self, data):
#         if data['new_password'] != data['confirm_password']:
#             raise serializers.ValidationError("Passwords do not match")
#         return data

# class DoctorMatchSerializer(serializers.Serializer):
#     symptoms = serializers.CharField(required=True, help_text="Patient's symptoms")
#     medical_history = serializers.CharField(required=False, allow_blank=True, help_text="Patient's medical history")

# class DoctorListSerializer(serializers.ModelSerializer):
#     specialization = serializers.CharField(source='doctor_profile.specialization')
#     specialization_illnes_symptoms = serializers.CharField(source='doctor_profile.specialization_illnes_symptoms')
#     match_score = serializers.IntegerField(read_only=True)
    
#     class Meta:
#         model = User
#         fields = [
#             'id', 'first_name', 'last_name', 'email',
#             'city', 'state', 'country',
#             'specialization', 'specialization_illnes_symptoms',
#             'match_score'
#         ]

# class DoctorDistanceSearchSerializer(serializers.Serializer):
#     latitude = serializers.FloatField()
#     longitude = serializers.FloatField()
#     max_distance_km = serializers.FloatField(required=False)

# class DoctorDistanceListSerializer(DoctorListSerializer):
#     distance_km = serializers.FloatField(read_only=True)

#     class Meta(DoctorListSerializer.Meta):
#         fields = DoctorListSerializer.Meta.fields + ["distance_km"]



from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth.password_validation import validate_password
from .models import PatientProfile, DoctorProfile, DoctorWorkingHour

User = get_user_model()

class RegisterSerializer(serializers.ModelSerializer):
    # Profile-specific fields
    healthIssues = serializers.CharField(write_only=True, required=False, allow_blank=True)
    specialization = serializers.CharField(write_only=True, required=False, allow_blank=True)
    specialization_illnes_symptoms = serializers.CharField(write_only=True, required=False, allow_blank=True)
    
    # Location fields for both patient and doctor
    latitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
    longitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
    
    class Meta:
        model = User
        fields = [
            "email", "username", "password",
            "first_name", "last_name", "user_type",
            "dob", "gender", "address", "city", "state", "zipCode", "country",
            "healthIssues", "specialization", "specialization_illnes_symptoms",
            "latitude", "longitude",
        ]
        extra_kwargs = {"password": {"write_only": True}}
    
    def validate(self, data):
        user_type = data.get('user_type')
        
        # Validate that doctor provides specialization
        if user_type == 'doctor':
            if not data.get('specialization'):
                raise serializers.ValidationError({
                    "specialization": "This field is required for doctors"
                })
            if not data.get('specialization_illnes_symptoms'):
                raise serializers.ValidationError({
                    "specialization_illnes_symptoms": "This field is required for doctors"
                })
        
        return data
    
    def create(self, validated_data):
        # Extract profile-specific fields
        health_issues = validated_data.pop('healthIssues', None)
        specialization = validated_data.pop('specialization', None)
        specialization_illnes_symptoms = validated_data.pop('specialization_illnes_symptoms', None)
        latitude = validated_data.pop('latitude', None)
        longitude = validated_data.pop('longitude', None)

        password = validated_data.pop("password")

        # Create user
        user = User(**validated_data)
        user.set_password(password)
        user.save()

        # Create profiles
        if user.user_type == 'patient':
            PatientProfile.objects.create(
                user=user,
                healthIssues=health_issues or '',
                latitude=latitude,
                longitude=longitude
            )

        elif user.user_type == 'doctor':
            DoctorProfile.objects.create(
                user=user,
                specialization=specialization or '',
                specialization_illnes_symptoms=specialization_illnes_symptoms or '',
                latitude=latitude,
                longitude=longitude
            )

        return user

class PatientProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = PatientProfile
        fields = ["healthIssues", "latitude", "longitude"]

class DoctorWorkingHourSerializer(serializers.ModelSerializer):
    class Meta:
        model = DoctorWorkingHour
        fields = ["date", "start_time", "end_time", "is_working"]

class DoctorProfileSerializer(serializers.ModelSerializer):
    working_hours = DoctorWorkingHourSerializer(many=True, required=False)

    class Meta:
        model = DoctorProfile
        fields = [
            "specialization",
            "specialization_illnes_symptoms",
            "latitude",
            "longitude",
            "working_hours"
        ]

class UserProfileSerializer(serializers.ModelSerializer):
    patient_profile = PatientProfileSerializer(read_only=True)
    doctor_profile = DoctorProfileSerializer(read_only=True)
    
    # Write-only fields for updates
    healthIssues = serializers.CharField(write_only=True, required=False, allow_blank=True)
    specialization = serializers.CharField(write_only=True, required=False, allow_blank=True)
    specialization_illnes_symptoms = serializers.CharField(write_only=True, required=False, allow_blank=True)
    latitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
    longitude = serializers.DecimalField(max_digits=9, decimal_places=6, write_only=True, required=False, allow_null=True)
    working_hours = DoctorWorkingHourSerializer(many=True, write_only=True, required=False)
    
    class Meta:
        model = User
        fields = [
            "id", "email", "username", "first_name", "last_name", "user_type",
            "dob", "gender", "address", "city", "state", "zipCode", "country",
            "patient_profile", "doctor_profile",
            "healthIssues", "specialization", "specialization_illnes_symptoms",
            "latitude", "longitude", "working_hours"
        ]
        read_only_fields = ["id", "email", "user_type"]
    
    def update(self, instance, validated_data):
        # Extract profile-specific fields
        health_issues = validated_data.pop('healthIssues', None)
        specialization = validated_data.pop('specialization', None)
        specialization_illnes_symptoms = validated_data.pop('specialization_illnes_symptoms', None)
        latitude = validated_data.pop('latitude', None)
        longitude = validated_data.pop('longitude', None)
        working_hours = validated_data.pop("working_hours", None)
        
        # Update user fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        
        # Update patient profile
        if instance.user_type == 'patient':
            if hasattr(instance, 'patient_profile'):
                if health_issues is not None:
                    instance.patient_profile.healthIssues = health_issues
                if latitude is not None:
                    instance.patient_profile.latitude = latitude
                if longitude is not None:
                    instance.patient_profile.longitude = longitude
                instance.patient_profile.save()
        
        # Update doctor profile
        if instance.user_type == 'doctor':
            if hasattr(instance, 'doctor_profile'):
                if specialization is not None:
                    instance.doctor_profile.specialization = specialization
                if specialization_illnes_symptoms is not None:
                    instance.doctor_profile.specialization_illnes_symptoms = specialization_illnes_symptoms
                if latitude is not None:
                    instance.doctor_profile.latitude = latitude
                if longitude is not None:
                    instance.doctor_profile.longitude = longitude
                instance.doctor_profile.save()
                
                # Update working hours
                if working_hours:
                    for working_hour in working_hours:
                        DoctorWorkingHour.objects.update_or_create(
                            doctor=instance.doctor_profile,
                            date=working_hour["date"],
                            defaults={
                                "start_time": working_hour.get("start_time"),
                                "end_time": working_hour.get("end_time"),
                                "is_working": working_hour.get("is_working", False),
                            }
                        )
        
        return instance

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        # Replace username with email
        attrs['username'] = attrs.get('email', '')
        return super().validate(attrs)
    
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        # Add custom data inside token payload
        token['user_type'] = user.user_type
        token['email'] = user.email
        token['first_name'] = user.first_name
        token['last_name'] = user.last_name
        return token

class ForgotPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()

class VerifyOTPSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6, min_length=6)

class ResetPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()
    otp = serializers.CharField(max_length=6, min_length=6)
    new_password = serializers.CharField(write_only=True, validators=[validate_password])
    confirm_password = serializers.CharField(write_only=True)
    
    def validate(self, data):
        if data['new_password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords do not match")
        return data

class DoctorMatchSerializer(serializers.Serializer):
    symptoms = serializers.CharField(required=True, help_text="Patient's symptoms")
    medical_history = serializers.CharField(required=False, allow_blank=True, help_text="Patient's medical history")

class DoctorListSerializer(serializers.ModelSerializer):
    specialization = serializers.CharField(source='doctor_profile.specialization', read_only=True)
    specialization_illnes_symptoms = serializers.CharField(source='doctor_profile.specialization_illnes_symptoms', read_only=True)
    latitude = serializers.DecimalField(source='doctor_profile.latitude', max_digits=9, decimal_places=6, read_only=True)
    longitude = serializers.DecimalField(source='doctor_profile.longitude', max_digits=9, decimal_places=6, read_only=True)
    match_score = serializers.IntegerField(read_only=True)
    
    class Meta:
        model = User
        fields = [
            'id', 'first_name', 'last_name', 'email',
            'city', 'state', 'country',
            'specialization', 'specialization_illnes_symptoms',
            'latitude', 'longitude',
            'match_score'
        ]

class DoctorDistanceSearchSerializer(serializers.Serializer):
    latitude = serializers.FloatField()
    longitude = serializers.FloatField()
    max_distance_km = serializers.FloatField(required=False)

class DoctorDistanceListSerializer(DoctorListSerializer):
    distance_km = serializers.FloatField(read_only=True)

    class Meta(DoctorListSerializer.Meta):
        fields = DoctorListSerializer.Meta.fields + ["distance_km"]