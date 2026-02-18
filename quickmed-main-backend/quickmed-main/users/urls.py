from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView



from .views import (
    RegisterView, 
    LoginView, 
    ProfileView,
    ForgotPasswordView,
    VerifyOTPView,
    ResetPasswordView,
    FindDoctorsView,  # Add this import,
    AvailableDoctorsNowView,
    LogoutView
)

urlpatterns = [
    path("register/", RegisterView.as_view(), name="register"),
    path("login/", LoginView.as_view(), name="login"),
    path("refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("profile/", ProfileView.as_view(), name="profile"),
    path("forgot-password/", ForgotPasswordView.as_view(), name="forgot_password"),
    path("verify-otp/", VerifyOTPView.as_view(), name="verify_otp"),
    path("reset-password/", ResetPasswordView.as_view(), name="reset_password"),
    path("find-doctors/", FindDoctorsView.as_view(), name="find_doctors"),  # Add this
    path("available-doctors/now/",AvailableDoctorsNowView.as_view(),                name="available_doctors_now"
    ),
    path("logout/", LogoutView.as_view(), name="logout"),  # Add this
]