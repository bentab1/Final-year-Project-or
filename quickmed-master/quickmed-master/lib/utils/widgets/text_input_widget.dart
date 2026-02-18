// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart'; // Add this dependency
// //
// // import '../utils/TColors.dart';
// // import '../utils/app_text_style.dart';
// // import '../utils/sizes.dart';
// //
// // class TextInputWidget extends StatefulWidget {
// //   const TextInputWidget({
// //     super.key,
// //     this.controller,
// //     this.suffixIcon,
// //     this.prefixIcon,
// //     this.suffixSvgPath,
// //     this.prefixSvgPath,
// //     this.onSuffixIconPressed,
// //     this.isPassword = false,
// //     this.hintText,
// //     required this.dark,
// //     this.headerText,
// //     this.headerStyle,
// //     this.headerFontWeight,
// //     this.headerFontFamily,
// //     this.hintTextColor,
// //     this.focusNode,
// //     this.radius,
// //     this.maxLines = 1,
// //     this.isEmail = false,
// //     this.validator,
// //     this.keyboardType,
// //     this.onChanged,
// //     this.onSubmitted,
// //     this.textInputAction,
// //     this.isRequired = false,
// //     // New color parameters
// //     this.fillColor,
// //     this.borderColor,
// //     this.focusedBorderColor,
// //     this.errorBorderColor,
// //     this.textColor,
// //     this.iconColor,
// //     this.height = 54,
// //     this.iconSize = 18.0,
// //   });
// //
// //   final TextEditingController? controller;
// //   final Icon? suffixIcon;
// //   final Icon? prefixIcon;
// //   final String? suffixSvgPath;
// //   final String? prefixSvgPath;
// //   final VoidCallback? onSuffixIconPressed;
// //   final bool isPassword;
// //   final String? hintText;
// //   final bool dark;
// //   final String? headerText;
// //   final TextStyle? headerStyle;
// //   final FontWeight? headerFontWeight;
// //   final String? headerFontFamily;
// //   final Color? hintTextColor;
// //   final BorderRadius? radius;
// //   final FocusNode? focusNode;
// //   final int? maxLines;
// //   final bool isEmail;
// //   final String? Function(String?)? validator;
// //   final TextInputType? keyboardType;
// //   final Function(String)? onChanged;
// //   final Function(String)? onSubmitted;
// //   final TextInputAction? textInputAction;
// //   final bool isRequired;
// //
// //   // New color parameters
// //   final Color? fillColor;
// //   final Color? borderColor;
// //   final Color? focusedBorderColor;
// //   final Color? errorBorderColor;
// //   final Color? textColor;
// //   final Color? iconColor;
// //   final double? height;
// //   final double iconSize;
// //
// //   @override
// //   State<TextInputWidget> createState() => _TextInputWidgetState();
// // }
// //
// // class _TextInputWidgetState extends State<TextInputWidget> {
// //   bool _obscureText = true;
// //
// //   // Default fill colors
// //   static const Color fillDark = Color(0xFF161616);
// //   static const Color fillLight = Color(0xFFE9E9E9);
// //
// //   static final RegExp _emailRegex = RegExp(
// //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
// //   );
// //
// //   String? _defaultEmailValidator(String? value) {
// //     if (value == null || value.isEmpty) {
// //       return widget.isRequired ? 'Email is required' : null;
// //     }
// //
// //     if (!_emailRegex.hasMatch(value)) {
// //       return 'Please enter a valid email address';
// //     }
// //     return null;
// //   }
// //
// //   // Updated color methods to use custom colors if provided, otherwise use defaults
// //   Color _getFillColor() {
// //     if (widget.fillColor != null) {
// //       return widget.fillColor!;
// //     }
// //     return widget.dark ? fillDark : fillLight;
// //   }
// //
// //   Color _getBorderColor() {
// //     if (widget.borderColor != null) {
// //       return widget.borderColor!;
// //     }
// //     return widget.dark
// //         ? TColors.darkGray600.withOpacity(0.4)
// //         : TColors.lightGray300;
// //   }
// //
// //   Color _getFocusedBorderColor() {
// //     if (widget.focusedBorderColor != null) {
// //       return widget.focusedBorderColor!;
// //     }
// //     return widget.dark
// //         ? TColors.newPrimary400
// //         : TColors.newPrimary500;
// //   }
// //
// //   Color _getErrorBorderColor() {
// //     if (widget.errorBorderColor != null) {
// //       return widget.errorBorderColor!;
// //     }
// //     return widget.dark
// //         ? TColors.error400
// //         : TColors.error500;
// //   }
// //
// //   Color _getTextColor() {
// //     if (widget.textColor != null) {
// //       return widget.textColor!;
// //     }
// //     return widget.dark ? TColors.darkTextPrimary : TColors.lightTextPrimary;
// //   }
// //
// //   Color _getIconColor() {
// //     if (widget.iconColor != null) {
// //       return widget.iconColor!;
// //     }
// //     return widget.dark
// //         ? TColors.darkTextTertiary
// //         : TColors.darkTextTertiary;
// //   }
// //
// //   // Helper method to build prefix icon widget
// //   Widget? _buildPrefixIcon() {
// //     if (widget.isEmail) {
// //       return Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //         child: Icon(
// //           Icons.email_outlined,
// //           color: _getIconColor(),
// //           size: widget.iconSize,
// //         ),
// //       );
// //     } else if (widget.prefixSvgPath != null) {
// //       return Padding(
// //         padding: const EdgeInsets.all( 8.0),
// //         child: SvgPicture.asset(
// //           widget.prefixSvgPath!,
// //           width: widget.iconSize,
// //           height: widget.iconSize,
// //           colorFilter: ColorFilter.mode(
// //             _getIconColor(),
// //             BlendMode.srcIn,
// //           ),
// //         ),
// //       );
// //     } else if (widget.prefixIcon != null) {
// //       return Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //         child: Icon(
// //           widget.prefixIcon!.icon,
// //           color: _getIconColor(),
// //           size: widget.iconSize,
// //         ),
// //       );
// //     }
// //     return null;
// //   }
// //
// //   // Helper method to build suffix icon widget
// //   Widget? _buildSuffixIcon() {
// //     if (widget.isPassword) {
// //       return IconButton(
// //         onPressed: () {
// //           setState(() {
// //             _obscureText = !_obscureText;
// //           });
// //         },
// //         icon: Icon(
// //           _obscureText ? Icons.visibility_off : Icons.visibility,
// //           color: _getIconColor(),
// //           size: widget.iconSize,
// //         ),
// //         splashRadius: 20,
// //       );
// //     } else if (widget.suffixSvgPath != null) {
// //       return IconButton(
// //         onPressed: widget.onSuffixIconPressed,
// //         icon: SvgPicture.asset(
// //           widget.suffixSvgPath!,
// //           width: widget.iconSize,
// //           height: widget.iconSize,
// //           colorFilter: ColorFilter.mode(
// //             _getIconColor(),
// //             BlendMode.srcIn,
// //           ),
// //         ),
// //         splashRadius: 20,
// //       );
// //     } else if (widget.suffixIcon != null) {
// //       return IconButton(
// //         onPressed: widget.onSuffixIconPressed,
// //         icon: Icon(
// //           widget.suffixIcon!.icon,
// //           color: _getIconColor(),
// //           size: widget.iconSize,
// //         ),
// //         splashRadius: 20,
// //       );
// //     }
// //     return null;
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _obscureText = widget.isPassword;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         if (widget.headerText != null) ...[
// //           Row(
// //             children: [
// //               Text(
// //                 widget.headerText!,
// //                 style: widget.headerStyle ?? TAppTextStyle.inter(
// //                   color: widget.dark ? Colors.white.withValues(alpha: 0.66) : Colors.black.withValues(alpha: 0.66),
// //                   fontSize: 14.0,
// //                   weight: widget.headerFontWeight ?? FontWeight.w400,
// //                 ),
// //               ),
// //               if (widget.isRequired)
// //                 Text(
// //                   ' *',
// //                   style: TAppTextStyle.inter(
// //                     color: TColors.error500,
// //                     fontSize: 15.0,
// //                     weight: FontWeight.w500,
// //                   ),
// //                 ),
// //             ],
// //           ),
// //           const SizedBox(height: TSizes.inputFieldRadius - 4),
// //         ],
// //         SizedBox(
// //           height: widget.height,
// //           child: TextFormField(
// //             focusNode: widget.focusNode,
// //             controller: widget.controller,
// //             maxLines: widget.maxLines,
// //             obscureText: widget.isPassword ? _obscureText : false,
// //             keyboardType: widget.isEmail
// //                 ? TextInputType.emailAddress
// //                 : (widget.keyboardType ?? TextInputType.text),
// //             textInputAction: widget.textInputAction ??
// //                 (widget.isEmail ? TextInputAction.done : TextInputAction.next),
// //             onChanged: widget.onChanged,
// //             onFieldSubmitted: widget.onSubmitted,
// //             validator: widget.isEmail
// //                 ? (widget.validator ?? _defaultEmailValidator)
// //                 : widget.validator,
// //             decoration: InputDecoration(
// //               filled: true,
// //               fillColor: _getFillColor(),
// //               hintText: widget.hintText,
// //               hintStyle: TAppTextStyle.roboto(
// //                 color: widget.hintTextColor ??
// //                     (widget.dark ? TColors.darkTextTertiary : TColors.lightTextTertiary),
// //                 fontSize: 14.0,
// //                 weight: FontWeight.w400,
// //               ),
// //               prefixIcon: _buildPrefixIcon(),
// //               suffixIcon: _buildSuffixIcon(),
// //               border: OutlineInputBorder(
// //                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
// //                 borderSide: BorderSide(width: 1.0, color: _getBorderColor()),
// //               ),
// //               enabledBorder: OutlineInputBorder(
// //                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
// //                 borderSide: BorderSide(width: 1.0, color: _getBorderColor()),
// //               ),
// //               focusedBorder: OutlineInputBorder(
// //                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
// //                   borderSide: BorderSide(width: 1.0, color: _getFocusedBorderColor()),
// //               ),
// //               errorBorder: OutlineInputBorder(
// //                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
// //                 borderSide: BorderSide(width: 1.0, color: _getErrorBorderColor()),
// //               ),
// //               focusedErrorBorder: OutlineInputBorder(
// //                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
// //                   borderSide: BorderSide(width: 1.0, color: _getErrorBorderColor()),
// //               ),
// //               contentPadding: const EdgeInsets.symmetric(
// //                 vertical: 18.0,
// //                 horizontal: 18.0,
// //               ),
// //             ),
// //             style: TAppTextStyle.inter(
// //               color: _getTextColor(),
// //               fontSize: 14.0,
// //               weight: FontWeight.w400,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Add this dependency
//
// import '../utils/TColors.dart';
// import '../utils/app_text_style.dart';
// import '../utils/sizes.dart';
//
// class TextInputWidget extends StatefulWidget {
//   const TextInputWidget({
//     super.key,
//     this.controller,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.suffixSvgPath,
//     this.prefixSvgPath,
//     this.onSuffixIconPressed,
//     this.isPassword = false,
//     this.hintText,
//     required this.dark,
//     this.headerText,
//     this.headerStyle,
//     this.headerFontWeight,
//     this.headerFontFamily,
//     this.hintTextColor,
//     this.focusNode,
//     this.radius,
//     this.maxLines = 1,
//     this.isEmail = false,
//     this.validator,
//     this.keyboardType,
//     this.onChanged,
//     this.onSubmitted,
//     this.textInputAction,
//     this.isRequired = false,
//     // New color parameters
//     this.fillColor,
//     this.borderColor,
//     this.focusedBorderColor,
//     this.errorBorderColor,
//     this.textColor,
//     this.iconColor,
//     this.height = 54,
//     this.iconSize = 18.0,
//   });
//
//   final TextEditingController? controller;
//   final Icon? suffixIcon;
//   final Icon? prefixIcon;
//   final String? suffixSvgPath;
//   final String? prefixSvgPath;
//   final VoidCallback? onSuffixIconPressed;
//   final bool isPassword;
//   final String? hintText;
//   final bool dark;
//   final String? headerText;
//   final TextStyle? headerStyle;
//   final FontWeight? headerFontWeight;
//   final String? headerFontFamily;
//   final Color? hintTextColor;
//   final BorderRadius? radius;
//   final FocusNode? focusNode;
//   final int? maxLines;
//   final bool isEmail;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final Function(String)? onChanged;
//   final Function(String)? onSubmitted;
//   final TextInputAction? textInputAction;
//   final bool isRequired;
//
//   // New color parameters
//   final Color? fillColor;
//   final Color? borderColor;
//   final Color? focusedBorderColor;
//   final Color? errorBorderColor;
//   final Color? textColor;
//   final Color? iconColor;
//   final double? height;
//   final double iconSize;
//
//   @override
//   State<TextInputWidget> createState() => _TextInputWidgetState();
// }
//
// class _TextInputWidgetState extends State<TextInputWidget> {
//   bool _obscureText = true;
//
//   // Default fill colors
//   static const Color fillDark = Color(0xFF161616);
//   static const Color fillLight = Color(0xFFE9E9E9);
//
//   static final RegExp _emailRegex = RegExp(
//     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//   );
//
//   String? _defaultEmailValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return widget.isRequired ? 'Email is required' : null;
//     }
//
//     if (!_emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }
//
//   // Updated color methods to use custom colors if provided, otherwise use defaults
//   Color _getFillColor() {
//     if (widget.fillColor != null) {
//       return widget.fillColor!;
//     }
//     return widget.dark ? fillDark : fillLight;
//   }
//
//   Color _getBorderColor() {
//     if (widget.borderColor != null) {
//       return widget.borderColor!;
//     }
//     return widget.dark
//         ? TColors.darkGray600.withOpacity(0.4)
//         : TColors.lightGray300;
//   }
//
//   Color _getFocusedBorderColor() {
//     if (widget.focusedBorderColor != null) {
//       return widget.focusedBorderColor!;
//     }
//     return widget.dark
//         ? TColors.newPrimary400
//         : TColors.newPrimary500;
//   }
//
//   Color _getErrorBorderColor() {
//     if (widget.errorBorderColor != null) {
//       return widget.errorBorderColor!;
//     }
//     return widget.dark
//         ? TColors.error400
//         : TColors.error500;
//   }
//
//   Color _getTextColor() {
//     if (widget.textColor != null) {
//       return widget.textColor!;
//     }
//     return widget.dark ? TColors.darkTextPrimary : TColors.lightTextPrimary;
//   }
//
//   Color _getIconColor() {
//     if (widget.iconColor != null) {
//       return widget.iconColor!;
//     }
//     return widget.dark
//         ? TColors.darkTextTertiary
//         : TColors.lightTextTertiary; // Fixed: was using darkTextTertiary for both
//   }
//
//   // Helper method to build prefix icon widget with FIXED sizing
//   Widget? _buildPrefixIcon() {
//     if (widget.isEmail) {
//       return Container(
//         width: 48, // Fixed container width
//         height: 48, // Fixed container height
//         alignment: Alignment.center,
//         child: Icon(
//           Icons.email_outlined,
//           color: _getIconColor(),
//           size: widget.iconSize,
//         ),
//       );
//     } else if (widget.prefixSvgPath != null) {
//       return Container(
//         width: 48, // Fixed container width
//         height: 48, // Fixed container height
//         alignment: Alignment.center,
//         child: SizedBox(
//           width: widget.iconSize, // Constrain SVG size
//           height: widget.iconSize, // Constrain SVG size
//           child: SvgPicture.asset(
//             widget.prefixSvgPath!,
//             width: widget.iconSize,
//             height: widget.iconSize,
//             fit: BoxFit.contain, // Ensure it fits within the constraints
//             colorFilter: ColorFilter.mode(
//               _getIconColor(),
//               BlendMode.srcIn,
//             ),
//           ),
//         ),
//       );
//     } else if (widget.prefixIcon != null) {
//       return Container(
//         width: 48, // Fixed container width
//         height: 48, // Fixed container height
//         alignment: Alignment.center,
//         child: Icon(
//           widget.prefixIcon!.icon,
//           color: _getIconColor(),
//           size: widget.iconSize,
//         ),
//       );
//     }
//     return null;
//   }
//
//   // Helper method to build suffix icon widget with FIXED sizing
//   Widget? _buildSuffixIcon() {
//     if (widget.isPassword) {
//       return Container(
//         width: 48, // Fixed container width
//         height: 48, // Fixed container height
//         alignment: Alignment.center,
//         child: IconButton(
//           onPressed: () {
//             setState(() {
//               _obscureText = !_obscureText;
//             });
//           },
//           icon: Icon(
//             _obscureText ? Icons.visibility_off : Icons.visibility,
//             color: _getIconColor(),
//             size: widget.iconSize,
//           ),
//           splashRadius: 20,
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//         ),
//       );
//     } else if (widget.suffixSvgPath != null) {
//       return Container(
//         width: 48, // Fixed container width
//         height: 48, // Fixed container height
//         alignment: Alignment.center,
//         child: IconButton(
//           onPressed: widget.onSuffixIconPressed,
//           icon: SizedBox(
//             width: widget.iconSize, // Constrain SVG size
//             height: widget.iconSize, // Constrain SVG size
//             child: SvgPicture.asset(
//               widget.suffixSvgPath!,
//               width: widget.iconSize,
//               height: widget.iconSize,
//               fit: BoxFit.contain, // Ensure it fits within the constraints
//               colorFilter: ColorFilter.mode(
//                 _getIconColor(),
//                 BlendMode.srcIn,
//               ),
//             ),
//           ),
//           splashRadius: 20,
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//         ),
//       );
//     } else if (widget.suffixIcon != null) {
//       return Container(
//         width: 48, // Fixed container width
//         height: 48, // Fixed container height
//         alignment: Alignment.center,
//         child: IconButton(
//           onPressed: widget.onSuffixIconPressed,
//           icon: Icon(
//             widget.suffixIcon!.icon,
//             color: _getIconColor(),
//             size: widget.iconSize,
//           ),
//           splashRadius: 20,
//           padding: EdgeInsets.zero,
//           constraints: const BoxConstraints(),
//         ),
//       );
//     }
//     return null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _obscureText = widget.isPassword;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.headerText != null) ...[
//           Row(
//             children: [
//               Text(
//                 widget.headerText!,
//                 style: widget.headerStyle ?? TAppTextStyle.inter(
//                   color: widget.dark
//                       ? Colors.white.withOpacity(0.66)
//                       : Colors.black.withOpacity(0.66), // Fixed withValues to withOpacity
//                   fontSize: 14.0,
//                   weight: widget.headerFontWeight ?? FontWeight.w400,
//                 ),
//               ),
//               if (widget.isRequired)
//                 Text(
//                   ' *',
//                   style: TAppTextStyle.inter(
//                     color: TColors.error500,
//                     fontSize: 15.0,
//                     weight: FontWeight.w500,
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: TSizes.inputFieldRadius - 4),
//         ],
//         SizedBox(
//           height: widget.height,
//           child: TextFormField(
//             focusNode: widget.focusNode,
//             controller: widget.controller,
//             maxLines: widget.maxLines,
//             obscureText: widget.isPassword ? _obscureText : false,
//             keyboardType: widget.isEmail
//                 ? TextInputType.emailAddress
//                 : (widget.keyboardType ?? TextInputType.text),
//             textInputAction: widget.textInputAction ??
//                 (widget.isEmail ? TextInputAction.done : TextInputAction.next),
//             onChanged: widget.onChanged,
//             onFieldSubmitted: widget.onSubmitted,
//             validator: widget.isEmail
//                 ? (widget.validator ?? _defaultEmailValidator)
//                 : widget.validator,
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: _getFillColor(),
//               hintText: widget.hintText,
//               hintStyle: TAppTextStyle.roboto(
//                 color: widget.hintTextColor ??
//                     (widget.dark ? TColors.darkTextTertiary : TColors.lightTextTertiary),
//                 fontSize: 14.0,
//                 weight: FontWeight.w400,
//               ),
//               prefixIcon: _buildPrefixIcon(),
//               suffixIcon: _buildSuffixIcon(),
//               border: OutlineInputBorder(
//                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
//                 borderSide: BorderSide(width: 1.0, color: _getBorderColor()),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
//                 borderSide: BorderSide(width: 1.0, color: _getBorderColor()),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
//                 borderSide: BorderSide(width: 1.0, color: _getFocusedBorderColor()),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
//                 borderSide: BorderSide(width: 1.0, color: _getErrorBorderColor()),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: widget.radius ?? BorderRadius.circular(8.0),
//                 borderSide: BorderSide(width: 1.0, color: _getErrorBorderColor()),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 18.0,
//                 horizontal: 18.0,
//               ),
//             ),
//             style: TAppTextStyle.inter(
//               color: _getTextColor(),
//               fontSize: 14.0,
//               weight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this dependency
import '../app_text_style.dart';
import '../sizes.dart';
import '../theme/colors/q_color.dart';

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    super.key,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixSvgPath,
    this.prefixSvgPath,
    this.onSuffixIconPressed,
    this.isPassword = false,
    this.hintText,
    required this.dark,
    this.headerText,
    this.headerStyle,
    this.headerFontWeight,
    this.headerFontFamily,
    this.hintTextColor,
    this.focusNode,
    this.radius,
    this.maxLines = 1,
    this.isEmail = false,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.isRequired = false,
    // New color parameters
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.iconColor,
    this.height = 54,
    this.iconSize = 18.0,
    this.errorText,
  });

  final TextEditingController? controller;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String? suffixSvgPath;
  final String? prefixSvgPath;
  final VoidCallback? onSuffixIconPressed;
  final bool isPassword;
  final String? hintText;
  final bool dark;
  final String? errorText;
  final String? headerText;
  final TextStyle? headerStyle;
  final FontWeight? headerFontWeight;
  final String? headerFontFamily;
  final Color? hintTextColor;
  final BorderRadius? radius;
  final FocusNode? focusNode;
  final int? maxLines;
  final bool isEmail;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final bool isRequired;

  // New color parameters
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? iconColor;
  final double? height;
  final double iconSize;

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool _obscureText = true;

  // Default fill colors
  static const Color fillDark = Color(0xFF161616);
  static const Color fillLight = Color(0xFFE9E9E9);

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return widget.isRequired ? 'Email is required' : null;
    }

    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Updated color methods to use custom colors if provided, otherwise use defaults
  Color _getFillColor() {
    if (widget.fillColor != null) {
      return widget.fillColor!;
    }
    return widget.dark ? fillDark : fillLight;
  }

  Color _getBorderColor() {
    if (widget.borderColor != null) {
      return widget.borderColor!;
    }
    return widget.dark
        ? QColors.darkGray600.withOpacity(0.4)
        : QColors.lightGray300;
  }

  Color _getFocusedBorderColor() {
    if (widget.focusedBorderColor != null) {
      return widget.focusedBorderColor!;
    }
    return widget.dark ? QColors.newPrimary400 : QColors.newPrimary500;
  }

  Color _getErrorBorderColor() {
    if (widget.errorBorderColor != null) {
      return widget.errorBorderColor!;
    }
    return widget.dark ? QColors.error400 : QColors.error500;
  }

  Color _getTextColor() {
    if (widget.textColor != null) {
      return widget.textColor!;
    }
    return widget.dark ? QColors.darkTextPrimary : QColors.lightTextPrimary;
  }

  Color _getIconColor() {
    if (widget.iconColor != null) {
      return widget.iconColor!;
    }
    return widget.dark
        ? QColors.darkTextTertiary
        : QColors.lightTextTertiary;
  }

  // Helper method to build prefix icon widget with FIXED sizing
  Widget? _buildPrefixIcon() {
    if (widget.isEmail) {
      return Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Icon(
          Icons.email_outlined,
          color: _getIconColor(),
          size: widget.iconSize,
        ),
      );
    } else if (widget.prefixSvgPath != null) {
      return Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: SizedBox(
          width: widget.iconSize,
          height: widget.iconSize,
          child: SvgPicture.asset(
            widget.prefixSvgPath!,
            width: widget.iconSize,
            height: widget.iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              _getIconColor(),
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    } else if (widget.prefixIcon != null) {
      return Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Icon(
          widget.prefixIcon!.icon,
          color: _getIconColor(),
          size: widget.iconSize,
        ),
      );
    }
    return null;
  }

  // Helper method to build suffix icon widget with proper sizing
  Widget? _buildSuffixIcon() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: _getIconColor(),
          size: widget.iconSize,
        ),
        splashRadius: 20,
      );
    } else if (widget.suffixSvgPath != null) {
      return IconButton(
        onPressed: widget.onSuffixIconPressed,
        icon: SizedBox(
          width: widget.iconSize,
          height: widget.iconSize,
          child: SvgPicture.asset(
            widget.suffixSvgPath!,
            width: widget.iconSize,
            height: widget.iconSize,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              _getIconColor(),
              BlendMode.srcIn,
            ),
          ),
        ),
        splashRadius: 20,
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        onPressed: widget.onSuffixIconPressed,
        icon: Icon(
          widget.suffixIcon!.icon,
          color: _getIconColor(),
          size: widget.iconSize,
        ),
        splashRadius: 20,
      );
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headerText != null) ...[
          Row(
            children: [
              Text(
                widget.headerText!,
                style: widget.headerStyle ??
                    TAppTextStyle.inter(
                      color: widget.dark
                          ? Colors.white.withOpacity(0.66)
                          : Colors.black.withOpacity(0.66),
                      fontSize: 14.0,
                      weight: widget.headerFontWeight ?? FontWeight.w400,
                    ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: TAppTextStyle.inter(
                    color: QColors.error500,
                    fontSize: 15.0,
                    weight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: QSizes.inputFieldRadius - 4),
        ],
        // Main input field with fixed height
        SizedBox(
          height: widget.height,
          child: TextFormField(
            focusNode: widget.focusNode,
            controller: widget.controller,
            maxLines: widget.maxLines,
            obscureText: widget.isPassword ? _obscureText : false,
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : (widget.keyboardType ?? TextInputType.text),
            textInputAction: widget.textInputAction ??
                (widget.isEmail ? TextInputAction.done : TextInputAction.next),
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.isEmail
                ? (widget.validator ?? _defaultEmailValidator)
                : widget.validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: _getFillColor(),
              hintText: widget.hintText,
              hintStyle: TAppTextStyle.inter(
                color: widget.hintTextColor ??
                    (widget.dark
                        ? QColors.darkTextTertiary
                        : QColors.lightTextTertiary),
                fontSize: 14.0,
                weight: FontWeight.w400,
              ),
              prefixIcon: _buildPrefixIcon(),
              suffixIcon: _buildSuffixIcon(),
              border: OutlineInputBorder(
                borderRadius: widget.radius ?? BorderRadius.circular(8.0),
                borderSide: BorderSide(width: 1.0, color: _getBorderColor()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: widget.radius ?? BorderRadius.circular(8.0),
                borderSide: BorderSide(width: 1.0, color: _getBorderColor()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: widget.radius ?? BorderRadius.circular(8.0),
                borderSide:
                BorderSide(width: 1.0, color: _getFocusedBorderColor()),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: widget.radius ?? BorderRadius.circular(8.0),
                borderSide: BorderSide(width: 1.0, color: _getErrorBorderColor()),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: widget.radius ?? BorderRadius.circular(8.0),
                borderSide: BorderSide(width: 1.0, color: _getErrorBorderColor()),
              ),
              // Remove errorText from here - it will be displayed separately below
              errorText: null,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 18.0,
              ),
            ),
            style: TAppTextStyle.inter(
              color: _getTextColor(),
              fontSize: 14.0,
              weight: FontWeight.w400,
            ),
          ),
        ),
        // Display error text separately below the field to maintain consistent height
        if (widget.errorText != null && widget.errorText!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: TAppTextStyle.inter(
              color: _getErrorBorderColor(),
              fontSize: 12,
              weight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
