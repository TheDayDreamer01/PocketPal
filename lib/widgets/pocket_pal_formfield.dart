import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:pocket_pal/const/color_palette.dart";


class PocketPalFormField extends StatelessWidget {

  final TextEditingController ? formController;
  final String formHintText;
  
  final bool formIsObsecure;
  final bool formIsReadOnly;

  final Widget ? formSuffixIcon;

  final String ? Function(String?) ? formValidator;
  final void Function() ? formOnTap;
  final void Function(String) ? formOnChange;
  final void Function(String?) ? formOnSaved;

  const PocketPalFormField({
    super.key,
    this.formController,
    required this.formHintText,
    this.formIsObsecure = false,
    this.formIsReadOnly = false,  
    this.formSuffixIcon,
    this.formValidator,
    this.formOnTap,
    this.formOnChange,
    this.formOnSaved
  });

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller : formController,
      obscureText: formIsObsecure,
      readOnly: formIsReadOnly,
      onTap: formOnTap,
      onChanged: formOnChange,
      onSaved: formOnSaved,

      decoration: InputDecoration(
        hintText: formHintText, 
  
        hintStyle: GoogleFonts.poppins(
          fontSize : 16,
          color : ColorPalette.grey
        ),

        suffixIcon: formSuffixIcon,
        
      ),

      validator: formValidator,
    );
  }
}