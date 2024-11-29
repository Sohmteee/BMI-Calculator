import 'package:bmi/res/res.dart';

final theme = ThemeData(
  useMaterial3: false,
  fontFamily: 'Circular',
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  canvasColor: accentColor,
  cardColor: secondaryColor,
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
    ),
  ),
);
