  import 'package:flutter/material.dart';

  import '../../../utils/app_text_style.dart';

  class ErrorStateWidget extends StatelessWidget {
    final String title;
    final String? message;
    final VoidCallback? onRetry;
    final IconData icon;
    final MaterialColor iconColor;
    final double iconSize;
    final EdgeInsetsGeometry padding;

    const ErrorStateWidget({
      Key? key,
      this.title = "Something went wrong",
      this.message,
      this.onRetry,
      this.icon = Icons.error_outline,
      this.iconColor = Colors.red,
      this.iconSize = 80,
      this.padding = const EdgeInsets.all(40),
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor.shade400,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TAppTextStyle.inter(
                color: iconColor.shade600,
                fontSize: 16,
                weight: FontWeight.w500,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TAppTextStyle.inter(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  weight: FontWeight.w400,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ],
          ],
        ),
      );
    }
  }
