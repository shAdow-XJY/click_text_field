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
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          TextButton(
            child: const Text('Click reset regex'),
            onPressed: () {
              textEditingController.setRegExp(
                  changeRegex ?
                  RegExp(r'people a') : RegExp(r'people a')
              );
              changeRegex = !changeRegex;
            },
          ),
          TextField(
            controller: textEditingController,
            maxLines: null,
          ),
        ]
      )
    );
  }
}
