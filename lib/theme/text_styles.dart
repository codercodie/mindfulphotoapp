import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension TextStyles on TextTheme {
  TextStyle get title => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.15,
      );

  TextStyle get heading => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  TextStyle get prompt => const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  TextStyle get body => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  TextStyle get small => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );
  
  TextStyle get quicksandTitle => GoogleFonts.quicksand(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        height: 1.15,
      );

  TextStyle get quicksandHeading => GoogleFonts.quicksand(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  TextStyle get quicksandSmall => GoogleFonts.quicksand(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.0,
      );
  
    TextStyle get quicksandBody => GoogleFonts.quicksand(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.1,
      );

}