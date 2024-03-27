import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/colors.dart';
import 'common.dart';

class AppTextInput extends StatelessWidget {
  final Widget? prefixIcon;
  final String? hint;
  final Function(String)? onTextChanged;
  final String? Function(String?)? validator;
  final EdgeInsets padding;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool securedTextEntry;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool enabled;
  final Function()? onTap;
  final FocusNode? focusNode;
  final bool isRequiredField;
  final bool isError;
  final Widget? suffixIcon;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const AppTextInput({
    Key? key,
    this.prefixIcon,
    this.hint,
    this.onTextChanged,
    this.controller,
    this.securedTextEntry = false,
    this.style,
    this.hintStyle,
    this.onTap,
    this.enabled = true,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.padding = const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.isRequiredField = false,
    this.isError = false,
    this.suffixIcon,
    this.errorText,
    this.inputFormatters,
    this.maxLines


  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onTap: onTap,
      enabled: enabled,
      textCapitalization: textCapitalization,
      key: key,
      onChanged: onTextChanged,
      validator: validator,
      cursorColor: AppColors.color1D1B20,
      cursorHeight: 20,
      cursorRadius: const Radius.circular(10),
      cursorWidth: 2,
      controller: controller,
      style: style,
      keyboardType: keyboardType,
      obscureText: securedTextEntry,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          errorText: errorText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6.0), // Adjust the radius as needed
          ),
          prefixIcon: prefixIcon,
          hintStyle: const TextStyle(color: AppColors.color79747E, fontSize: 12),
          contentPadding: padding,
          suffixIcon: Align(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: suffixIcon
          ),
          label: FittedBox(child:
          Row(children: [
            cText(hint ?? '', fontSize: 14, color: (isError) ? AppColors.colorB3261E : AppColors.color79747E, maxLine: maxLines),
            isRequiredField ?
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                    child: cText('*', fontSize: 18, color: Colors.red)
                )
                : const SizedBox()])),
          labelStyle: const TextStyle(fontSize: 14, color: AppColors.color1D1B20),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      scrollPadding: EdgeInsets.zero,
    );
  }
}

