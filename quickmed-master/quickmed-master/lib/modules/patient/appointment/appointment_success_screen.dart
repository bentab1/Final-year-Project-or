import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/device_utility.dart';
import '../../../utils/theme/colors/q_color.dart';

class AppointmentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const AppointmentSuccessScreen({
    super.key,
    this.bookingData,
  });

  @override
  State<AppointmentSuccessScreen> createState() =>
      _AppointmentSuccessScreenState();
}

class _AppointmentSuccessScreenState extends State<AppointmentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _printReceivedData();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Scale animation for the success icon
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Fade animation for the content
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animation
    _animationController.forward();

    // Auto-navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/patientBottomNavScreen');
      }
    });
  }

  void _printReceivedData() {
    print("=== APPOINTMENT SUCCESS - RECEIVED DATA ===");
    print("Widget bookingData: ${widget.bookingData}");
    print("BookingData type: ${widget.bookingData.runtimeType}");

    if (widget.bookingData == null) {
      print("❌ No booking data received");
    } else {
      print("✅ Booking data received:");
      widget.bookingData!.forEach((key, value) {
        print("  $key: $value (${value.runtimeType})");
      });
    }
    print("=========================================");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// Animated Success Icon
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 100,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// Success Message
                      Text(
                        "Appointment Booked!",
                        style: TAppTextStyle.inter(
                          fontSize: 28,
                          weight: FontWeight.w700,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Your appointment has been successfully confirmed",
                        style: TAppTextStyle.inter(
                          fontSize: 16,
                          weight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      /// Loading indicator
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            QColors.newPrimary500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}