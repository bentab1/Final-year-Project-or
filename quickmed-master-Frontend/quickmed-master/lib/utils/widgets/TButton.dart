// import 'package:flutter/material.dart';
// import '../utils/TColors.dart';
// import '../utils/app_text_style.dart';
// import '../utils/device_utility.dart';
//
// enum TButtonType {
//   primary,
//   secondary,
//   outlined,
//   text,
//   social
// }
//
// class TButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed; // Made nullable
//   final TButtonType buttonType;
//   final double? width;
//   final double? height;
//   final BorderRadius? borderRadius;
//   final String? prefixImagePath;
//   final double? prefixImageWidth;
//   final double? prefixImageHeight;
//   final bool isLoading;
//   final Color? backgroundColor;
//   final Color? textColor;
//   final double? fontSize;
//   final FontWeight? fontWeight;
//   final EdgeInsetsGeometry? padding;
//
//   const TButton({
//     super.key,
//     required this.text,
//     required this.onPressed, // Still required but nullable
//     this.buttonType = TButtonType.primary,
//     this.width,
//     this.height = 52.0,
//     this.borderRadius,
//     this.prefixImagePath,
//     this.prefixImageWidth = 24.0,
//     this.prefixImageHeight = 24.0,
//     this.isLoading = false,
//     this.backgroundColor,
//     this.textColor,
//     this.fontSize = 16.0,
//     this.fontWeight = FontWeight.w600,
//     this.padding,
//   });
//
//   // Computed property to check if button is disabled
//   bool get isDisabled => onPressed == null && !isLoading;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = TDeviceUtils.isDarkMode(context);
//     final radius = borderRadius ?? BorderRadius.circular(10);
//
//     switch (buttonType) {
//       case TButtonType.primary:
//         return _buildPrimaryButton(context, isDark, radius);
//       case TButtonType.secondary:
//         return _buildSecondaryButton(context, isDark, radius);
//       case TButtonType.outlined:
//         return _buildOutlinedButton(context, isDark, radius);
//       case TButtonType.text:
//         return _buildTextButton(context, isDark, radius);
//       case TButtonType.social:
//         return _buildSocialButton(context, isDark, radius);
//     }
//   }
//
//   Widget _buildPrimaryButton(BuildContext context, bool isDark, BorderRadius radius) {
//     return GestureDetector(
//       onTap: (isLoading || isDisabled) ? null : onPressed,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: width ?? double.infinity,
//         height: height,
//         decoration: BoxDecoration(
//           color: _getPrimaryBackgroundColor(isDark),
//           borderRadius: radius,
//           boxShadow: isDisabled ? null : [
//             BoxShadow(
//               color: (_getPrimaryBackgroundColor(isDark)).withOpacity(0.15),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
//         child: _buildButtonContent(isDark),
//       ),
//     );
//   }
//
//   Widget _buildSecondaryButton(BuildContext context, bool isDark, BorderRadius radius) {
//     return GestureDetector(
//       onTap: (isLoading || isDisabled) ? null : onPressed,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: width ?? double.infinity,
//         height: height,
//         decoration: BoxDecoration(
//           color: _getSecondaryBackgroundColor(isDark),
//           borderRadius: radius,
//           boxShadow: isDisabled ? null : [
//             BoxShadow(
//               color: (_getSecondaryBackgroundColor(isDark)).withOpacity(0.15),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
//         child: _buildButtonContent(isDark),
//       ),
//     );
//   }
//
//   Widget _buildOutlinedButton(BuildContext context, bool isDark, BorderRadius radius) {
//     return GestureDetector(
//       onTap: (isLoading || isDisabled) ? null : onPressed,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: width ?? double.infinity,
//         height: height,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: radius,
//           border: Border.all(
//             color: _getOutlinedBorderColor(isDark),
//             width: 1,
//           ),
//         ),
//         padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
//         child: _buildButtonContent(isDark),
//       ),
//     );
//   }
//
//   Widget _buildTextButton(BuildContext context, bool isDark, BorderRadius radius) {
//     return GestureDetector(
//       onTap: (isLoading || isDisabled) ? null : onPressed,
//       child: Container(
//         width: width ?? double.infinity,
//         height: height ?? 30,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: radius,
//         ),
//         padding: padding ?? EdgeInsets.zero,
//         child: _buildButtonContent(isDark),
//       ),
//     );
//   }
//
//   Widget _buildSocialButton(BuildContext context, bool isDark, BorderRadius radius) {
//     return GestureDetector(
//       onTap: (isLoading || isDisabled) ? null : onPressed,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: width ?? double.infinity,
//         height: height,
//         decoration: BoxDecoration(
//           color: _getSocialBackgroundColor(isDark),
//           borderRadius: radius,
//           border: Border.all(
//             color: _getSocialBorderColor(isDark),
//             width: 1,
//           ),
//         ),
//         padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
//         child: _buildButtonContent(isDark),
//       ),
//     );
//   }
//
//   Widget _buildButtonContent(bool isDark) {
//     if (isLoading) {
//       return Center(
//         child: SizedBox(
//           height: 20,
//           width: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(
//               textColor ?? _getLoadingIndicatorColor(isDark),
//             ),
//           ),
//         ),
//       );
//     }
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         if (prefixImagePath != null)
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 200),
//               opacity: isDisabled ? 0.5 : 1.0,
//               child: Image(
//                 image: AssetImage(prefixImagePath!),
//                 width: prefixImageWidth,
//                 height: prefixImageHeight,
//               ),
//             ),
//           ),
//         Flexible(
//           child: AnimatedDefaultTextStyle(
//             duration: const Duration(milliseconds: 200),
//             style: TAppTextStyle.roboto(
//               color: textColor ?? _getDefaultTextColor(isDark),
//               fontSize: fontSize ?? 16.0,
//               weight: fontWeight ?? FontWeight.w500,
//             ),
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TAppTextStyle.roboto(
//                 color: textColor ?? _getDefaultTextColor(isDark),
//                 fontSize: fontSize ?? 16.0,
//                 weight: fontWeight ?? FontWeight.w500,
//               ),
//             ),
//
//           ),
//         ),
//       ],
//     );
//   }
//
//   Color _getPrimaryBackgroundColor(bool isDark) {
//     // Always prioritize custom backgroundColor when provided
//     if (backgroundColor != null) {
//       return backgroundColor!;
//     }
//
//     // Use default disabled colors only when no custom backgroundColor is provided
//     if (isDisabled) {
//       return isDark ? TColors.darkGray700 : TColors.lightGray300;
//     }
//
//     // Default active color
//     return TColors.buttonPrimary;
//   }
//
//   Color _getSecondaryBackgroundColor(bool isDark) {
//     // Always prioritize custom backgroundColor when provided
//     if (backgroundColor != null) {
//       return backgroundColor!;
//     }
//
//     // Use default disabled colors only when no custom backgroundColor is provided
//     if (isDisabled) {
//       return isDark ? TColors.darkGray700 : TColors.lightGray300;
//     }
//
//     // Default active color
//     return TColors.buttonSecondary;
//   }
//
//   Color _getOutlinedBorderColor(bool isDark) {
//     if (isDisabled) {
//       return isDark ? TColors.darkGray600 : TColors.lightGray400;
//     }
//     return backgroundColor ?? TColors.newPrimary500;
//   }
//
//   Color _getSocialBackgroundColor(bool isDark) {
//     // Always prioritize custom backgroundColor when provided
//     if (backgroundColor != null) {
//       return backgroundColor!;
//     }
//
//     if (isDisabled) {
//       return isDark ? TColors.darkGray800 : TColors.lightGray200;
//     }
//     return isDark ? TColors.darkCard : TColors.lightCard;
//   }
//
//   Color _getSocialBorderColor(bool isDark) {
//     if (isDisabled) {
//       return isDark ? TColors.darkGray600 : TColors.lightGray400;
//     }
//     return isDark ? TColors.darkGray600 : TColors.lightGray300;
//   }
//
//   Color _getLoadingIndicatorColor(bool isDark) {
//     switch (buttonType) {
//       case TButtonType.primary:
//         return textColor ?? TColors.buttonText;
//       case TButtonType.secondary:
//         return textColor ?? TColors.buttonText;
//       case TButtonType.outlined:
//       case TButtonType.text:
//         return textColor ?? TColors.newPrimary500;
//       case TButtonType.social:
//         return textColor ?? (isDark ? TColors.darkTextPrimary : TColors.lightTextPrimary);
//     }
//   }
//
//   Color _getDefaultTextColor(bool isDark) {
//     // Always prioritize custom textColor when provided
//     if (textColor != null) {
//       return textColor!;
//     }
//
//     // Handle primary and secondary button text colors based on your requirements
//     if (buttonType == TButtonType.primary || buttonType == TButtonType.secondary) {
//       if (isDark) {
//         // Dark mode: active = black text, inactive = white text
//         return isDisabled ? Colors.white : Colors.black;
//       } else {
//         // Light mode: always white text (active & inactive)
//         return Colors.white;
//       }
//     }
//
//     // For other button types, use original logic
//     if (isDisabled) {
//       switch (buttonType) {
//         case TButtonType.outlined:
//         case TButtonType.text:
//           return isDark ? TColors.darkTextDisabled : TColors.lightTextDisabled;
//         case TButtonType.social:
//           return isDark ? TColors.darkTextDisabled : TColors.lightTextDisabled;
//         default:
//           return isDark ? TColors.darkTextDisabled : TColors.lightTextDisabled;
//       }
//     }
//
//     switch (buttonType) {
//       case TButtonType.outlined:
//       case TButtonType.text:
//         return TColors.newPrimary500;
//       case TButtonType.social:
//         return isDark ? TColors.darkTextPrimary : TColors.lightTextPrimary;
//       default:
//         return TColors.buttonText;
//     }
//   }
// }


import 'package:flutter/material.dart';
import '../app_text_style.dart';
import '../device_utility.dart';
import '../theme/colors/q_color.dart';

enum QButtonType {
  primary,
  secondary,
  outlined,
  text,
  social
}

class QButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Made nullable
  final QButtonType buttonType;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final String? prefixImagePath;
  final double? prefixImageWidth;
  final double? prefixImageHeight;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor; // Added custom border color
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final bool isRequired; // Added required state
  final bool isFocused; // Added focused state

  const QButton({
    super.key,
    required this.text,
    required this.onPressed, // Still required but nullable
    this.buttonType = QButtonType.primary,
    this.width,
    this.height = 52.0,
    this.borderRadius,
    this.prefixImagePath,
    this.prefixImageWidth = 24.0,
    this.prefixImageHeight = 24.0,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor, // Added border color parameter
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.padding,
    this.isRequired = false, // Added required parameter
    this.isFocused = false, // Added focused parameter
  });

  // Computed property to check if button is disabled
  bool get isDisabled => onPressed == null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final bool isDark = TDeviceUtils.isDarkMode(context);
    final radius = borderRadius ?? BorderRadius.circular(10);

    switch (buttonType) {
      case QButtonType.primary:
        return _buildPrimaryButton(context, isDark, radius);
      case QButtonType.secondary:
        return _buildSecondaryButton(context, isDark, radius);
      case QButtonType.outlined:
        return _buildOutlinedButton(context, isDark, radius);
      case QButtonType.text:
        return _buildTextButton(context, isDark, radius);
      case QButtonType.social:
        return _buildSocialButton(context, isDark, radius);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: _getPrimaryBackgroundColor(isDark),
          borderRadius: radius,
          border: _shouldShowBorder() ? Border.all(
            color: _getDynamicBorderColor(isDark),
            width: _getBorderWidth(),
          ) : null,
          boxShadow: isDisabled ? null : [
            BoxShadow(
              color: (_getPrimaryBackgroundColor(isDark)).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: _getSecondaryBackgroundColor(isDark),
          borderRadius: radius,
          border: _shouldShowBorder() ? Border.all(
            color: _getDynamicBorderColor(isDark),
            width: _getBorderWidth(),
          ) : null,
          boxShadow: isDisabled ? null : [
            BoxShadow(
              color: (_getSecondaryBackgroundColor(isDark)).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: _getDynamicBorderColor(isDark),
            width: _getBorderWidth(),
          ),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 30,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: _shouldShowBorder() ? Border.all(
            color: _getDynamicBorderColor(isDark),
            width: _getBorderWidth(),
          ) : null,
        ),
        padding: padding ?? EdgeInsets.zero,
        child: _buildButtonContent(isDark),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, bool isDark, BorderRadius radius) {
    return GestureDetector(
      onTap: (isLoading || isDisabled) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: _getSocialBackgroundColor(isDark),
          borderRadius: radius,
          border: Border.all(
            color: _getDynamicBorderColor(isDark),
            width: _getBorderWidth(),
          ),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
        child: _buildButtonContent(isDark),
      ),
    );
  }

  // Helper method to determine if border should be shown
  bool _shouldShowBorder() {
    return buttonType == QButtonType.outlined ||
        buttonType == QButtonType.social ||
        isRequired ||
        isFocused ||
        borderColor != null;
  }

  // Helper method to get border width
  double _getBorderWidth() {
    if (isRequired || isFocused) {
      return 2.0; // Thicker border for required/focused states
    }
    return buttonType == QButtonType.outlined ? 1.5 : 1.0;
  }

  // Dynamic border color based on state
  Color _getDynamicBorderColor(bool isDark) {
    // Always prioritize custom borderColor when provided
    if (borderColor != null) {
      return borderColor!;
    }

    // Handle required state
    if (isRequired && !isFocused) {
      return Colors.red.shade400; // Red border for required fields
    }

    // Handle focused state
    if (isFocused) {
      return Color(0xFF1DB584); // Teal border for focused state (like your referral screen)
    }

    // Handle disabled state
    if (isDisabled) {
      return isDark ? QColors.darkGray600 : QColors.lightGray400;
    }

    // Default border colors for each button type
    switch (buttonType) {
      case QButtonType.outlined:
        return QColors.newPrimary500;
      case QButtonType.social:
        return isDark ? QColors.darkGray600 : QColors.lightGray300;
      case QButtonType.primary:
      case QButtonType.secondary:
        return QColors.newPrimary500;
      case QButtonType.text:
        return Colors.transparent;
    }
  }

  Widget _buildButtonContent(bool isDark) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? _getLoadingIndicatorColor(isDark),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixImagePath != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isDisabled ? 0.5 : 1.0,
              child: Image(
                image: AssetImage(prefixImagePath!),
                width: prefixImageWidth,
                height: prefixImageHeight,
              ),
            ),
          ),
        Flexible(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TAppTextStyle.inter(
              color: textColor ?? _getDefaultTextColor(isDark),
              fontSize: fontSize ?? 16.0,
              weight: fontWeight ?? FontWeight.w500,
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TAppTextStyle.inter(
                color: textColor ?? _getDefaultTextColor(isDark),
                fontSize: fontSize ?? 16.0,
                weight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPrimaryBackgroundColor(bool isDark) {
    // Always prioritize custom backgroundColor when provided
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    // Use default disabled colors only when no custom backgroundColor is provided
    if (isDisabled) {
      return isDark ? QColors.darkGray700 : QColors.lightGray300;
    }

    // Default active color
    return QColors.buttonPrimary;
  }

  Color _getSecondaryBackgroundColor(bool isDark) {
    // Always prioritize custom backgroundColor when provided
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    // Use default disabled colors only when no custom backgroundColor is provided
    if (isDisabled) {
      return isDark ? QColors.darkGray700 : QColors.lightGray300;
    }

    // Default active color
    return QColors.buttonSecondary;
  }

  Color _getSocialBackgroundColor(bool isDark) {
    // Always prioritize custom backgroundColor when provided
    if (backgroundColor != null) {
      return backgroundColor!;
    }

    if (isDisabled) {
      return isDark ? QColors.darkGray800 : QColors.lightGray200;
    }
    return isDark ? QColors.darkCard : QColors.lightCard;
  }

  Color _getLoadingIndicatorColor(bool isDark) {
    switch (buttonType) {
      case QButtonType.primary:
        return textColor ?? QColors.buttonText;
      case QButtonType.secondary:
        return textColor ?? QColors.buttonText;
      case QButtonType.outlined:
      case QButtonType.text:
        return textColor ?? QColors.newPrimary500;
      case QButtonType.social:
        return textColor ?? (isDark ? QColors.darkTextPrimary : QColors.lightTextPrimary);
    }
  }

  Color _getDefaultTextColor(bool isDark) {
    // Always prioritize custom textColor when provided
    if (textColor != null) {
      return textColor!;
    }

    // Handle primary and secondary button text colors based on your requirements
    if (buttonType == QButtonType.primary || buttonType == QButtonType.secondary) {
      if (isDark) {
        // Dark mode: active = black text, inactive = white text
        return isDisabled ? Colors.white : Colors.black;
      } else {
        // Light mode: always white text (active & inactive)
        return Colors.white;
      }
    }

    // For other button types, use original logic
    if (isDisabled) {
      switch (buttonType) {
        case QButtonType.outlined:
        case QButtonType.text:
          return isDark ? QColors.darkTextDisabled : QColors.lightTextDisabled;
        case QButtonType.social:
          return isDark ? QColors.darkTextDisabled : QColors.lightTextDisabled;
        default:
          return isDark ? QColors.darkTextDisabled : QColors.lightTextDisabled;
      }
    }

    switch (buttonType) {
      case QButtonType.outlined:
      case QButtonType.text:
        return QColors.newPrimary500;
      case QButtonType.social:
        return isDark ? QColors.darkTextPrimary : QColors.lightTextPrimary;
      default:
        return QColors.buttonText;
    }
  }
}