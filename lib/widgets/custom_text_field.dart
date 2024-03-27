import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:union_pay/extensions/widget_extension.dart';

import '../generated/l10n.dart';
import '../helper/colors.dart';
import 'common.dart';

class CustomTextFiled extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onResult;
  final String? hintText;
  final Color? fillColor;
  final double? hintFontSize;
  final Color? hintColor;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? errorText;
  final double? radius;
  final int? maxLength;
  final bool? hasPrefixIcon;
  final double? borderWith;
  final Color? borderColor;
  final bool? isUnder;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;
  final bool isShowSufixSearch;

  //是否是金额输入框
  final bool amountInput;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;
  final bool obscureText;

  const CustomTextFiled(
      {Key? key,
        this.onChanged,
        this.onResult,
        this.prefixIcon,
        this.controller,
        this.hintText,
        this.errorText,
        this.hintColor,
        this.focusNode,
        this.maxLength,
        this.enable,
        this.amountInput = false,
        this.hasPrefixIcon = true,
        this.isUnder = false,
        this.radius = 24.0,
        this.hintFontSize = 14,
        this.borderWith = 0,
        this.borderColor,
        this.style,
        this.contentPadding,
        this.keyboardType = TextInputType.text,
        this.fillColor = Colors.white,
        this.obscureText = false,
        this.inputFormatters,
        this.isShowSufixSearch = true
      })
      : super(key: key);

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();

}


class _CustomTextFiledState extends State<CustomTextFiled> {
  TextEditingController? controller;

  var _showClear = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      controller = widget.controller;
    } else {
      controller = TextEditingController();
    }
  }

  InputBorder _builderInputBorder() {
    return widget.isUnder == true
        ? UnderlineInputBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(widget.radius ?? 24.0)),
        borderSide: BorderSide(
          width: widget.borderWith ?? 0,
          color: widget.borderColor ?? Colors.transparent,
        ))
        : OutlineInputBorder(
        borderRadius:
        BorderRadius.all(Radius.circular(widget.radius ?? 24.0)),
        borderSide: BorderSide(
          width: widget.borderWith ?? 0,
          color: widget.borderColor ?? Colors.transparent,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var clear = _showClear
        ? InkWell(
        onTap: () {
          setState(() {
            controller?.clear();
            widget.onChanged?.call('');
            _showClear = false;
            widget.onResult?.call(null);
          });
        },
        child: const Icon(Icons.cancel, size: 16.0, color: Color(0xffcccccc))
            .intoContainer(padding: EdgeInsets.symmetric(horizontal: 5)))
        : null;
    return TextField(
      controller: controller,
      maxLength: widget.maxLength,
      maxLines: 1,
      enabled: widget.enable,
      obscureText: widget.obscureText,
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {
          _showClear = value.isNotEmpty;
        });
      },
      onEditingComplete: () {
        widget.onResult?.call(controller?.text.toString());
      },
      style: widget.style,
      focusNode: widget.focusNode,
      keyboardType: widget.amountInput
          ? const TextInputType.numberWithOptions(decimal: true)
          : widget.keyboardType,
      decoration: InputDecoration(
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
          disabledBorder: _builderInputBorder(),
          focusedBorder: _builderInputBorder(),
          enabledBorder: _builderInputBorder(),
          errorBorder: _builderInputBorder(),
          fillColor: widget.fillColor,
          filled: true,
          errorText: widget.errorText,
          errorStyle: TextStyle(fontSize: 11),
          errorMaxLines: 2,
          prefixIcon: widget.hasPrefixIcon == true
              ? (widget.prefixIcon ??
              const Icon(
                Icons.search,
                color: AppColors.black80212121,
              ))
              : null,
          suffixIcon: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (clear != null) clear,
                if (widget.onResult != null)
                  Visibility(
                    visible: widget.isShowSufixSearch ,
                    child: InkWell(
                      onTap: () {
                        widget.onResult?.call(controller?.text.toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child:
                        cText(S().search, color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          ),
          hintText: widget.hintText ?? S.of(context).search,
          hintStyle: TextStyle(
              color: widget.hintColor, fontSize: widget.hintFontSize ?? 11)),
    );
  }
}

