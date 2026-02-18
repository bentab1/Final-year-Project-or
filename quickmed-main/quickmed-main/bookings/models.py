from django.db import models
from django.contrib.auth import get_user_model
from users.models import PatientProfile, DoctorProfile

User = get_user_model()

class Booking(models.Model):
    patient = models.ForeignKey(
        PatientProfile, on_delete=models.CASCADE, related_name="bookings"
    )
    doctor = models.ForeignKey(
        DoctorProfile, on_delete=models.CASCADE, related_name="appointments"
    )

    medical_history = models.TextField(null=True, blank=True)
    current_symptoms = models.TextField(null=True, blank=True)

    date = models.DateField()
    time = models.TimeField()

    STATUS_CHOICES = (
        ("pending", "Pending"),
        ("approved", "Approved"),
        ("rejected", "Rejected"),
        ("cancelled", "Cancelled"),
        ("completed", "Completed"),
        ("no show", "No Show")
    )

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="pending")

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.patient.user.email} → {self.doctor.user.email} on {self.date}"
