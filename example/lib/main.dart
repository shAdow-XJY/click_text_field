import 'package:flutter/material.dart';
import 'package:click_text_field/click_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'click_text_field',
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// ClickTextEditingController
  final ClickTextEditingController textEditingController = ClickTextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('click_text_field'),
      ),
      body: Column(
        children: [
          ClickTextField(
              controller: textEditingController,
              regExp: RegExp(r'people a'),
              clickTextStyle: TextStyle(
                background: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.cyanAccent,
              ),
              onTapText: (clickCallBack) => {
                debugPrint('U click the highlight text $clickCallBack'),
              }
          ),
          SuggestClickTextField(
            controller: ClickTextEditingController(),
            regExp: RegExp(r'people a|people b|people c|people d|doctor b|building c'),
            onTapText: (clickCallBack ) {  },
          )
        ]
      )
    );
  }
}
