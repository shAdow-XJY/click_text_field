import 'package:flutter/material.dart';
import 'package:click_text_field/click_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return const MaterialApp(
      title: 'click_text_field',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// 章节内容输入框控制器
  final ClickTextEditingController textEditingController = ClickTextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(),
      body: Column(
        children: [
          ClickTextField(
              controller: ClickTextEditingController(),
              regExp: RegExp(r'people a'),
              onTapText: (clickCallBack) => {
                debugPrint('U click the highlight text $clickCallBack'),
              }
          )
        ]
      )
    );
  }
}
