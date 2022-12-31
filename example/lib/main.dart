import 'package:flutter/material.dart';
import 'package:click_text_field/click_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return const MaterialApp(
      title: 'click_text_field',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// 章节内容输入框控制器
  final ClickTextEditingController textEditingController = ClickTextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.setRegExp(RegExp(r'people'));
    textEditingController.setOnTapEvent((strCallBack) => {
      debugPrint('U click the highlight text $strCallBack'),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: TextField(
          controller: textEditingController,
          maxLines: null,
        ),
      )
    );
  }
}
