import 'package:flutter/material.dart';

import 'click_text_edit_controller.dart';


class ClickTextField extends StatefulWidget {
  final RegExp regExp;
  final Function(String) onTapText;
  final ClickTextEditingController controller;
  final TextStyle? textStyle;
  final TextStyle? clickTextStyle;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool? enable;
  final void Function(String)? onChanged;
  final TextAlign? textAlign;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  const ClickTextField(
      {
        Key? key,
        required this.regExp,
        required this.onTapText,
        required this.controller,
        this.enable,
        this.textStyle,
        this.textAlign,
        this.focusNode,
        this.decoration,
        this.clickTextStyle,
        this.onTap,
        this.onChanged,
        this.onTapOutside,
      }) : super(key: key);


  @override
  State<ClickTextField> createState() => _ClickTextFieldState();
}

class _ClickTextFieldState extends State<ClickTextField> {

  late FocusNode focusNode;
  late TextAlign textAlign;
  late InputDecoration decoration;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode??FocusNode();
    textAlign = widget.textAlign ?? TextAlign.start;
    decoration = widget.decoration??const InputDecoration();
    if (widget.textStyle != null) {
      widget.controller.textStyle = widget.textStyle!;
    }
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
    if (widget.textStyle != null && widget.textStyle != oldWidget.textStyle) {
      widget.controller.textStyle = widget.textStyle!;
    }
    if (widget.clickTextStyle != null && widget.clickTextStyle != oldWidget.clickTextStyle) {
      widget.controller.clickTextStyle = widget.clickTextStyle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      enabled: widget.enable,
      controller: widget.controller,
      focusNode: focusNode,
      textAlign: textAlign,
      decoration: decoration,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
    );
  }
}