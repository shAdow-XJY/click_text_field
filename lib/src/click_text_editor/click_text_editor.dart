import 'package:flutter/material.dart';
import 'click_text_editor_controller.dart';

class ClickTextEditor extends StatefulWidget {
  final TextStyle? style;
  final TextStyle? clickStyle;
  const ClickTextEditor(
      {
        super.key,
        this.style,
        this.clickStyle,
      });


  @override
  _ClickTextEditorState createState() => _ClickTextEditorState();
}

class _ClickTextEditorState extends State<ClickTextEditor> {

  final ClickTextEditorController _clickTextEditorController = ClickTextEditorController();

  @override
  void initState() {
    super.initState();
    _clickTextEditorController.regExp = RegExp('people a');
    _clickTextEditorController.onTap = (String a) => debugPrint('a');
    _clickTextEditorController.addListener(() {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _clickTextEditorController.clickTextSpan;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // TextField
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _clickTextEditorController,
              maxLines: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              maxLines: null,
              text: _clickTextEditorController.clickTextSpan,
            ),
          ),
        ],
      ),
    );
  }
}
