import 'package:flutter/material.dart';

import '../click_text_field.dart';

class ClickTextField extends StatefulWidget {
  const ClickTextField({Key? key}) : super(key: key);


  @override
  State<ClickTextField> createState() => _ClickTextFieldState();
}

class _ClickTextFieldState extends State<ClickTextField> {

  /// 章节内容输入框控制器
  final ClickTextEditingController textEditingController = ClickTextEditingController();
  /// flag
  bool changeRegex = false;

  @override
  void initState() {
    super.initState();
    textEditingController.setRegExp(RegExp(r'people a'));
    textEditingController.setOnTapEvent((strCallBack) => {
      debugPrint('U click the highlight text $strCallBack'),
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