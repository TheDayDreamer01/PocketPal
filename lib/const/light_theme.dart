import "package:flutter/material.dart";
import "package:pocket_pal/const/color_palette.dart";


ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: ColorPalette.darkCrimson,
  brightness: Brightness.light,
  scaffoldBackgroundColor: ColorPalette.white,
  appBarTheme: AppBarTheme(
    backgroundColor: ColorPalette.white, 
  )
);