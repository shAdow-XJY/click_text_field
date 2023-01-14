import 'package:flutter/material.dart';

import '../click_text_field.dart';

class ClickTextField extends StatefulWidget {
  final RegExp regExp;
  final Function(String) onTapText;
  const ClickTextField(
      {
        Key? key,
        required this.regExp,
        required this.onTapText
      }) : super(key: key);


  @override
  State<ClickTextField> createState() => _ClickTextFieldState();
}

class _ClickTextFieldState extends State<ClickTextField> {

  /// 章节内容输入框控制器
  final ClickTextEditingController textEditingController = ClickTextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.setRegExp(widget.regExp);
    textEditingController.setOnTapEvent((strCallBack) => {
      widget.onTapText(strCallBack),
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      maxLines: null,
    );
  }
}