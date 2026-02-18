import 'dart:ui';

class QColors {
  QColors._();

  // =============================================================================
  // NEW PRIMARY COLOR PALETTE - Bright Cyan (#0CCEE4)
  // =============================================================================
  static const Color newPrimary100 = Color(0xFFE0FBFE);
  static const Color newPrimary200 = Color(0xFFB8F5FC);
  static const Color newPrimary300 = Color(0xFF8FEFF9);
  static const Color newPrimary400 = Color(0xFF66E9F7);
  static const Color newPrimary500 = Color(0xFF0CCEE4); // Your new primary color - Bright Cyan
  static const Color newPrimary600 = Color(0xFF0AB9CD);
  static const Color newPrimary700 = Color(0xFF09A4B6);
  static const Color newPrimary800 = Color(0xFF078F9F);
  static const Color newPrimary900 = Color(0xFF067A88);
  static const Color newPrimary1000 = Color(0xFF04343A);
  static const Color newPrimary1100 = Color(0xFFADF3FB);

  // =============================================================================
  // ACCENT COLOR PALETTE - Coral Pink (Interactive Elements)
  // =============================================================================
  static const Color accent100 = Color(0xFFFFE8EC);
  static const Color accent200 = Color(0xFFFFD1D9);
  static const Color accent300 = Color(0xFFFFBAC6);
  static const Color accent400 = Color(0xFFFFA3B3);
  static const Color accent500 = Color(0xFFFF6B81); // Your accent color for interactive elements
  static const Color accent600 = Color(0xFFE6556E);
  static const Color accent700 = Color(0xFFCC3F5B);
  static const Color accent800 = Color(0xFFB32948);
  static const Color accent900 = Color(0xFF991335);
  static const Color accent9001 = Color(0xFFEB4D65);
  static const Color tabDark = Color(0xFFEB4D65);
  static const Color tabDarkSha = Color(0xFF521722);
  static const Color tabLight = Color(0xFFFF6B81);
  static const Color tabLightSHA = Color(0xFFECB4BC);

  // =============================================================================
  // ORIGINAL BRAND COLORS (keeping for backward compatibility)
  // =============================================================================
  static const Color brand100 = Color(0xFFCCD2DD);
  static const Color brand200 = Color(0xFF99A5BB);
  static const Color brand300 = Color(0xFF667998);
  static const Color brand400 = Color(0xFF334C76);
  static const Color brand500 = Color(0xFF001F54); // Original brand color
  static const Color brand600 = Color(0xFF001943);
  static const Color brand700 = Color(0xFF001332);
  static const Color brand800 = Color(0xFF000C22);
  static const Color brand900 = Color(0xFF000611);
  static const lightBorder = Color(0xFFE0E0E0);
  static const darkBorder = Color(0xFF444444);

  // Icon and container colors
  static const Color iconColorLightMode = Color(0xFF999999);
  static const Color iconColorLight = Color(0xFFA0A9B3);
  static const Color iconColorDark = Color(0xFF495563);
  static const Color containerbackgroundColorLightMode = Color(0xFF0CCEE4); // Updated to new primary

  // Updated primary references
  static const Color primary = newPrimary500; // Updated to bright cyan
  static const Color primaryAccent = accent500; // Coral for interactive elements

  // Legacy primary colors (keeping for backward compatibility)
  static const Color main = Color(0xFF7C3AED);
  static const Color darkPrimary = Color(0xFF0CCEE4); // Updated to new primary

  // =============================================================================
  // LIGHT MODE COLORS
  // =============================================================================
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkProgress = Color(0xFF171717);
  static const Color lightSurface = Color(0xFFF9FAFB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextColor = Color(0xFF000000);
  static const Color progressLight = newPrimary500; // Updated to bright cyan
  static const Color lightTextColor1 = Color(0xFF0D0D0D);

  // Light mode grays
  static const Color lightGray100 = Color(0xFFF2F4F7);
  static const Color lightGray200 = Color(0xFFEAECF0);
  static const Color lightGray300 = Color(0xFFD0D5DD);
  static const Color lightGray400 = Color(0xFF98A2B3);
  static const Color lightGray500 = Color(0xFF667085);
  static const Color lightGray600 = Color(0xFF475467);
  static const Color lightGray700 = Color(0xFF344054);
  static const Color lightGray800 = Color(0xFF182230);
  static const Color lightGray900 = Color(0xFF101828);

  // Light mode text colors
  static const Color lightTextPrimary = lightGray900;
  static const Color lightTextSecondary = lightGray600;
  static const Color lightTextTertiary = lightGray500;
  static const Color lightTextDisabled = lightGray400;

  // =============================================================================
  // DARK MODE COLORS
  // =============================================================================
  static const Color darkBackground = Color(0xFF090E17);
  static const Color darkSurface = Color(0xFF1E2939);
  static const Color darkCard = Color(0xFF1E2939);

  // Dark mode grays (optimized for dark backgrounds)
  static const Color darkGray100 = Color(0xFFFFFFFF);
  static const Color darkGray200 = Color(0xFFECECED);
  static const Color darkGray300 = Color(0xFFCECFD2);
  static const Color darkGray400 = Color(0xFF94969C);
  static const Color darkGray500 = Color(0xFF85888E);
  static const Color darkGray600 = Color(0xFF61646C);
  static const Color iconBack = Color(0xFF99A5BB);
  static const Color darkGray700 = Color(0xFF333741);
  static const Color darkGray800 = Color(0xFF1F242F);
  static const Color darkGray900 = Color(0xFF161B26);
  static const Color fillDark = Color(0xFF161616);
  static const Color fillLight = Color(0xFFE9E9E9);

  // Dark mode text colors
  static const Color darkTextPrimary = darkGray100;
  static const Color darkTextSecondary = darkGray300;
  static const Color darkTextTertiary = darkGray400;
  static const Color darkTextDisabled = darkGray500;

  // App bar colors
  static const Color appbarLight = Color(0xFFFFFFFF);
  static const Color appbarDark = Color(0xFF222222);
  static const Color chipColor = Color(0xFF383838);

  // =============================================================================
  // SEMANTIC COLORS (Same for both modes, with different opacity/usage)
  // =============================================================================

  // Error Colors
  static const Color error100 = Color(0xFFFEE4E2);
  static const Color error200 = Color(0xFFFECDCA);
  static const Color error300 = Color(0xFFFDA29B);
  static const Color error400 = Color(0xFFF97066);
  static const Color error500 = Color(0xFFF04438); // Primary error
  static const Color error600 = Color(0xFFD92D20);
  static const Color error700 = Color(0xFFB42318);
  static const Color error800 = Color(0xFF912018);
  static const Color error900 = Color(0xFF7A271A);

  // Warning Colors
  static const Color warning100 = Color(0xFFFEF0C7);
  static const Color warning200 = Color(0xFFFEDF89);
  static const Color warning300 = Color(0xFFFEC84B);
  static const Color warning400 = Color(0xFFFDB022);
  static const Color warning500 = Color(0xFFF79009); // Primary warning
  static const Color warning600 = Color(0xFFDC6803);
  static const Color warning700 = Color(0xFFB54708);
  static const Color warning800 = Color(0xFF93370D);
  static const Color warning900 = Color(0xFF7A2E0E);

  // Success Colors (Updated to use bright cyan tones)
  static const Color success100 = Color(0xFFE0FBFE);
  static const Color success200 = Color(0xFFB8F5FC);
  static const Color success300 = Color(0xFF8FEFF9);
  static const Color success400 = Color(0xFF66E9F7);
  static const Color success500 = Color(0xFF0CCEE4); // Using your new primary as success
  static const Color success600 = Color(0xFF0AB9CD);
  static const Color success700 = Color(0xFF09A4B6);
  static const Color success800 = Color(0xFF078F9F);
  static const Color success900 = Color(0xFF067A88);

  // Info Colors (using original brand colors)
  static const Color info100 = brand100;
  static const Color info200 = brand200;
  static const Color info300 = brand300;
  static const Color info400 = brand400;
  static const Color info500 = brand500; // Primary info
  static const Color info600 = brand600;
  static const Color info700 = brand700;
  static const Color info800 = brand800;
  static const Color info900 = brand900;

  // Legacy semantic colors (keeping for backward compatibility)
  static const Color error = error500;
  static const Color success = success500;
  static const Color info = info500;

  // =============================================================================
  // INTERACTIVE ELEMENT COLORS (New section for UI components)
  // =============================================================================

  // Radio Button Colors
  static const Color radioButtonSelected = accent500; // Pink coral for selected state
  static const Color radioButtonUnselected = lightGray400;
  static const Color radioButtonSelectedDark = accent400; // Lighter pink for dark mode
  static const Color radioButtonUnselectedDark = darkGray500;

  // Checkbox Colors
  static const Color checkboxSelected = accent500; // Pink coral for checked state
  static const Color checkboxUnselected = lightGray400;
  static const Color checkboxSelectedDark = accent400; // Lighter pink for dark mode
  static const Color checkboxUnselectedDark = darkGray500;

  // Button Colors
  static const Color buttonPrimary = newPrimary500; // Bright cyan for primary buttons
  static const Color buttonSecondary = accent500; // Pink coral for secondary buttons
  static const Color buttonText = Color(0xFFFFFFFF);

  // Switch Colors
  static const Color switchActive = accent500; // Pink coral for active switch
  static const Color switchInactive = lightGray300;
  static const Color switchActiveDark = accent400;
  static const Color switchInactiveDark = darkGray600;

  // =============================================================================
  // SECONDARY COLORS (keeping original)
  // =============================================================================

  // Chartreuse Green Palette (accent colors)
  static const Color chartreuse100 = Color(0xFFE0F9AC);
  static const Color chartreuse200 = Color(0xFFD4F78D);
  static const Color chartreuse300 = Color(0xFFC8F56E);
  static const Color chartreuse400 = Color(0xFFBDF34F);
  static const Color chartreuse500 = Color(0xFFD8F897);
  static const Color chartreuse600 = Color(0xFF96CD29);
  static const Color chartreuse700 = Color(0xFF7CA922);
  static const Color chartreuse800 = Color(0xFF61851A);
  static const Color chartreuse900 = Color(0xFF476013);

  // Gray Blue Palette (alternative to default gray)
  static const Color grayBlue100 = Color(0xFFEAECF5);
  static const Color grayBlue200 = Color(0xFFD5D9EB);
  static const Color grayBlue300 = Color(0xFFB3B8DB);
  static const Color grayBlue400 = Color(0xFF717BBC);
  static const Color grayBlue500 = Color(0xFF4E5BA6);
  static const Color grayBlue600 = Color(0xFF3E4784);
  static const Color grayBlue700 = Color(0xFF363F72);
  static const Color grayBlue800 = Color(0xFF293056);

  // =============================================================================
  // LEGACY COLORS (keeping for backward compatibility)
  // =============================================================================
  static const Color lightest = Color(0xFFC6ACF9);
  static const Color lighter = Color(0xFFB08DF7);
  static const Color light = Color(0xFF9B6EF5);
  static const Color medium = Color(0xFF854FF3);
  static const Color dark = Color(0xFF5F29CD);
  static const Color darker = Color(0xFF4E22A9);
  static const Color darkest = Color(0xFF2D1360);
  static const Color darkest12 = Color(0xFF395998);
  static const Color darkest1212 = Color(0xFF4285F4);
  static const Color backGroundDarkCard = Color(0xFF1E2939);
  static const Color chartreuse600a = Color(0x0f0ba02c);
  static const Color lightGray1000 = Color(0xFF1F2024);
  static const Color darkGray1001 = Color(0xFFF0F1F1);
  static const Color darkGray1000 = Color(0xFF150A33);
  static const Color textDarkColor = Color(0xFF1E1E1E);
}