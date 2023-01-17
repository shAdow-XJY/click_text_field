import 'package:flutter/material.dart';

import '../click_text_field.dart';

class ClickTextField extends StatefulWidget {
  final RegExp regExp;
  final Function(String) onTapText;
  final ClickTextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  const ClickTextField(
      {
        Key? key,
        required this.regExp,
        required this.onTapText,
        required this.controller,
        this.focusNode,
        this.decoration,
      }) : super(key: key);


  @override
  State<ClickTextField> createState() => _ClickTextFieldState();
}

class _ClickTextFieldState extends State<ClickTextField> {

  RegExp preRegExp = RegExp(r'');

  @override
  void initState() {
    super.initState();
    preRegExp = widget.regExp;
    widget.controller.setRegExp(widget.regExp);
    widget.controller.setOnTapEvent((strCallBack) => {
      widget.onTapText(strCallBack),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.regExp.toString().compareTo(preRegExp.toString()) != 0) {
      setState(() {
        widget.controller.setRegExp(widget.regExp);
      });
      preRegExp = widget.regExp;
    }
    return TextField(
      maxLines: null,
      controller: widget.controller,
      focusNode: widget.focusNode ?? FocusNode(),
      decoration: widget.decoration ?? const InputDecoration(),
    );
  }
}