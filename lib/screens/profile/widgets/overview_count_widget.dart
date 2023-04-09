import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket_pal/const/color_palette.dart';

class OverviewCountWidget extends StatelessWidget {

  final int count;
  final String countTitle;

  const OverviewCountWidget({
    super.key,
    required this.count,
    required this.countTitle,
    });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "$count\n",
            style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ColorPalette.rustic,
            )
          ),
          TextSpan(
            text: countTitle,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: ColorPalette.grey
            )
          )
        ]
      ),
    );
  }
}