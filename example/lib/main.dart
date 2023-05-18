import 'package:flutter/gestures.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ClickTextField(
            //     controller: textEditingController,
            //     regExp: RegExp(r'people a|people b|people c'),
            //     clickTextStyle: TextStyle(
            //       background: Paint()
            //         ..style = PaintingStyle.stroke
            //         ..strokeWidth = 2
            //         ..color = Colors.cyanAccent,
            //     ),
            //     onTapText: (clickCallBack) => {
            //       debugPrint('U click the highlight text $clickCallBack'),
            //     }
            // ),
            // SuggestClickTextField(
            //     controller: ClickTextEditingController(),
            //     regExp: RegExp(r'people a|people b|people c|embed c|building d|人物一'),
            //     textStyle: const TextStyle(
            //       color: Colors.deepPurple
            //     ),
            //     clickTextStyle: TextStyle(
            //       background: Paint()
            //         ..style = PaintingStyle.stroke
            //         ..strokeWidth = 2
            //         ..color = Colors.cyanAccent,
            //     ),
            //     onTapText: (clickCallBack) => {
            //       debugPrint('U click the highlight text $clickCallBack'),
            //     }
            // ),
            TextField(
              maxLines: null,
              controller: ClickController(),
            )
          ],
        ),
      ),
    );
  }
}

class ClickController extends TextEditingController {

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {

    var spans = <InlineSpan>[];

    int startIndex = 0;

    for (var i = 0; i < text.length; ++i) {
      if (text[i] == 'A') {
        spans.add(
          TextSpan(
            text: text.substring(startIndex, i),
            mouseCursor: SystemMouseCursors.click,
            recognizer: TapGestureRecognizer()..onTap = () => debugPrint('click A'),
          ),
        );
        spans.add(
          TextSpan(
            text: 'A',
            mouseCursor: SystemMouseCursors.click,
            recognizer: TapGestureRecognizer()..onTap = () => debugPrint('click A'),
          ),
        );
        startIndex = i + 1;
      }
    }
    if (startIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(startIndex, text.length),
          mouseCursor: SystemMouseCursors.text,
        ),
      );
    }

    return TextSpan(
      children: spans,
      mouseCursor: SystemMouseCursors.text,
    );
  }
}