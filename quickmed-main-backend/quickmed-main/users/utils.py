from django.utils import timezone
from django.db.models import Q


def get_today_day():
    return timezone.localtime().strftime("%A").lower()

def available_now_queryset(queryset):
    now = timezone.localtime()
    today = now.strftime("%A").lower()
    current_time = now.time()

    return queryset.filter(
        doctor_profile__working_hours__day=today,
        doctor_profile__working_hours__is_working=True,
        doctor_profile__working_hours__start_time__lte=current_time,
        doctor_profile__working_hours__end_time__gte=current_time,
    ).distinct()

WEEK_DAYS = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
]

DEFAULT_WORKING_DAYS = {
    "monday": ("09:00", "17:00"),
    "tuesday": ("09:00", "17:00"),
    "wednesday": ("09:00", "17:00"),
    "thursday": ("09:00", "17:00"),
    "friday": ("09:00", "17:00"),
}
