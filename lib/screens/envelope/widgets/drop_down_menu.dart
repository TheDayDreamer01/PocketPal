import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pocket_pal/const/color_palette.dart';
import 'package:pocket_pal/const/font_style.dart';

class MyDropDownMenuWidget extends StatefulWidget {
  final String? dropdownValue;
  final List<String> categories;
  final List<Color> categoryColors;
  final void Function(String?)? onChanged;
  final GlobalKey<FormState> formKey;
  final String? Function(String?)? validator;

  const MyDropDownMenuWidget({
    this.dropdownValue,
    required this.categories,
    required this.categoryColors,
    required this.onChanged,
    required this.formKey,
    required this.validator,
    super.key});

  @override
  State<MyDropDownMenuWidget> createState() => _MyDropDownMenuWidgetState();
}

class _MyDropDownMenuWidgetState extends State<MyDropDownMenuWidget> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: widget.formKey,
        value: widget.dropdownValue ?? widget.categories[0],
        items: [
          ...widget.categories.map((category) {
        int index = widget.categories.indexOf(category);
        return DropdownMenuItem<String>(
            value: category,
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: index < widget.categoryColors.length ? widget.categoryColors[index] : ColorPalette.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10.w),
                bodyText(
                  category,
                ),
              ],
            ),
          );
        }).toList(),
        DropdownMenuItem<String>(
            value: 'User-defined',
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                bodyText(
                  'User-defined',),
              ],
            ),
          ),
          ],
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            labelText: 'Category',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: ColorPalette.grey!
              ),
              borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
            focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: ColorPalette.crimsonRed.shade200
                  ),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
        ),
        onChanged:  widget.onChanged,
         validator: widget.validator,
        );
  }
}