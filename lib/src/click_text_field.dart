import 'package:flutter/material.dart';

import '../click_text_field.dart';

class ClickTextField extends StatefulWidget {
  final RegExp regExp;
  final Function(String) onTapText;
  final ClickTextEditingController controller;
  final TextStyle? clickTextStyle;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool? enable;
  final void Function(String)? onChanged;
  final TextAlign? textAlign;
  const ClickTextField(
      {
        Key? key,
        required this.regExp,
        required this.onTapText,
        required this.controller,
        this.clickTextStyle,
        this.focusNode,
        this.decoration,
        this.enable,
        this.onChanged,
        this.textAlign
      }) : super(key: key);


  @override
  State<ClickTextField> createState() => _ClickTextFieldState();
}

class _ClickTextFieldState extends State<ClickTextField> {

  @override
  void initState() {
    super.initState();
    if (widget.clickTextStyle != null) {
      widget.controller.clickTextStyle = widget.clickTextStyle!;
    }
    widget.controller.regExp = widget.regExp;
    widget.controller.onTap = (strCallBack) => {
      widget.onTapText(strCallBack),
    };
  }

  @override
  void didUpdateWidget(ClickTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.regExp.toString().compareTo(oldWidget.regExp.toString()) != 0) {
      widget.controller.regExp = widget.regExp;
    }
    if (widget.clickTextStyle != null && widget.clickTextStyle != oldWidget.clickTextStyle) {
      widget.controller.clickTextStyle = widget.clickTextStyle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: widget.controller,
      focusNode: widget.focusNode ?? FocusNode(),
      decoration: widget.decoration ?? const InputDecoration(),
      enabled: widget.enable,
      onChanged: widget.onChanged,
      textAlign: widget.textAlign ?? TextAlign.start,
    );
  }
}