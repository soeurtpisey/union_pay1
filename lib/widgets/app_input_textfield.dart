
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';
import 'package:union_pay/helper/colors.dart';
import 'package:union_pay/widgets/common.dart';

class AppTextInput extends StatefulWidget {
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
  final int? maxLength;
  final int? maxLines;
  final bool? isUnderline;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextInput(
      {super.key,
      this.prefixIcon,
      this.hint,
      this.onTextChanged,
      this.controller,
      this.securedTextEntry = false,
      this.style,
      this.hintStyle,
      this.onTap,
      this.enabled = true,
      this.isUnderline = false,
      this.focusNode,
      this.maxLength,
      this.maxLines,
      this.inputFormatters,
      this.keyboardType = TextInputType.text,
      this.padding = const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      this.validator,
      this.textCapitalization = TextCapitalization.none,
      this.isRequiredField = false,
      this.isError = false,
      this.suffixIcon,
      this.errorText});

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  var _showClear = false;

  InputBorder getInputBorder(Color color) {
    return widget.isUnderline == true
        ? UnderlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 0.5),
    )
        : OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon;
    if (widget.suffixIcon == null) {
      suffixIcon = _showClear
          ? InkWell(
          onTap: () {
            setState(() {
              widget.controller?.clear();
              widget.onTextChanged?.call('');
              _showClear = false;
            });
          },
          child: const Icon(Icons.cancel, size: 24.0, color: Color(0xffcccccc))
              .intoContainer(padding: const EdgeInsets.symmetric(horizontal: 5)))
          : null;
    } else {
      suffixIcon = widget.suffixIcon;
    }
    return TextFormField(
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      textCapitalization: widget.textCapitalization,
      key: widget.key,
      onChanged: (value) {
        widget.onTextChanged?.call(value);
        setState(() {
          _showClear = value.isNotEmpty;
        });
      },
      validator: widget.validator,
      cursorColor: AppColors.color1D1B20,
      cursorHeight: 20,
      cursorRadius: const Radius.circular(10),
      cursorWidth: 2,
      controller: widget.controller,
      style: widget.style,
      maxLines: widget.maxLines,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      obscureText: widget.securedTextEntry,
      decoration: InputDecoration(
          errorText: widget.errorText,
          disabledBorder: getInputBorder(AppColors.color79747E),
          enabledBorder: getInputBorder(AppColors.color79747E),
          border: widget.isError
              ? getInputBorder(AppColors.colorB3261E)
              : getInputBorder(AppColors.color79747E),
          focusedBorder: getInputBorder(AppColors.color79747E),
          errorBorder: getInputBorder(AppColors.colorB3261E),
          prefixIcon: widget.prefixIcon,
          hintStyle:
          const TextStyle(color: AppColors.color79747E, fontSize: 16),
          contentPadding: widget.padding,
          suffixIcon:
          Align(widthFactor: 0.5, heightFactor: 0.5, child: suffixIcon),
          label: FittedBox(
              child: Row(children: [
                cText(widget.hint ?? '',
                    fontSize: 16,
                    color: (widget.isError)
                        ? AppColors.colorB3261E
                        : AppColors.color79747E),
                widget.isRequiredField
                    ? cText('*', fontSize: 18, color: AppColors.colorB3261E)
                    : const SizedBox()
              ])),
          labelStyle:
          const TextStyle(fontSize: 16, color: AppColors.color1D1B20),
          floatingLabelBehavior: FloatingLabelBehavior.auto),
      scrollPadding: EdgeInsets.zero,
    );
  }
}