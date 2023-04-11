import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle display4(BuildContext context) {
    return Theme.of(context).textTheme.headline1.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle display3(BuildContext context) {
    return Theme.of(context).textTheme.headline2.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle display2(BuildContext context) {
    return Theme.of(context).textTheme.headline3.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle display1(BuildContext context) {
    return Theme.of(context).textTheme.headline4.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headline5.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.headline6.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1.copyWith(
          fontSize: 18,
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle subhead(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyText2.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.caption.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.button.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle2.copyWith(
          fontFamily: 'WorkSans',
        );
  }

  static TextStyle overline(BuildContext context) {
    return Theme.of(context).textTheme.overline.copyWith(
          fontFamily: 'WorkSans',
        );
  }
}
