import 'package:flutter/material.dart';
import '../utils/my_colors.dart';

enum AppTheme { White, Dark }

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final appThemeData = {
  AppTheme.White: ThemeData(
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
      color: Colors.black,
    )),
    brightness: Brightness.light,
    primaryColor: MyColors.primary,
    //primarySwatch: MyColors.primary,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: Colors.black87,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontFamily: 'WorkSans',
      ),
      headline4: TextStyle(
        color: Colors.black54,
        fontFamily: 'WorkSans',
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        fontFamily: 'WorkSans',
        fontSize: 18.0,
      ),
    ),
  ),
  AppTheme.Dark: ThemeData(
    //scaffoldBackgroundColor: MyColors.grey_90,
    //primaryColor: MyColors.grey_90,
    brightness: Brightness.dark,
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
      color: Colors.white,
    )),
    bottomSheetTheme: BottomSheetThemeData(
        //backgroundColor: MyColors.grey_90,
        ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.grey_95,
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: MyColors.grey_95),
    appBarTheme: AppBarTheme(
      color: MyColors.primary,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    dividerColor: Colors.grey.shade800,
    //bottomAppBarTheme: BottomAppBarTheme(color: MyColors.grey_90),
    cardTheme: CardTheme(
        //color: MyColors.grey_80,
        ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontFamily: 'WorkSans',
      ),
      subtitle2: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
        fontSize: 18.0,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      subtitle1: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontFamily: 'WorkSans',
      ),
      overline: TextStyle(
        color: Colors.white,
      ),
      caption: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
};
