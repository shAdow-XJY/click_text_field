import 'dart:ffi';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

TextStyle defaultTextStyle = const TextStyle(
  height: 1.2,
  fontSize: 14.0,
);

TextStyle defaultClickTextStyle = TextStyle(
  height: 1.2,
  fontSize: 14.0,
  textBaseline: TextBaseline.alphabetic,
  background: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = Colors.deepPurpleAccent,
);

class ClickTextEditorController extends TextEditingController {
  RegExp regExp = RegExp(r'');
  StringScanner _scanner = StringScanner("");
  void Function(String) _onTap = (String clickText) {};
  TextStyle _textStyle = defaultTextStyle;
  TextStyle _clickTextStyle = defaultClickTextStyle;
  TextSpan textSpan = const TextSpan();
  TextSpan clickTextSpan = const TextSpan();
  // final ValueNotifier<TextSpan> clickTextSpanNotifier = ValueNotifier<TextSpan>(const TextSpan());

  set onTap(void Function(String) onTap) {
    _onTap = onTap;
  }

  set textStyle(TextStyle textStyle) {
    _textStyle = textStyle;
  }

  set clickTextStyle(TextStyle clickTextStyle) {
    _clickTextStyle = clickTextStyle;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    // debugPrint('scanning text as follow:');
    // debugPrint(text);

    int atIndex = 0;
    List<InlineSpan> spans = [];
    List<InlineSpan> clickSpans = [];

    _scanner = StringScanner(text);
    if (regExp.pattern.isNotEmpty) {
      while (!_scanner.isDone) {
        // debugPrint('scanning');
        // print('position: ${_scanner.position}');
        if (_scanner.scan(regExp)) {
          int startIndex = _scanner.lastMatch?.start ?? 0;
          int endIndex = _scanner.lastMatch?.end ?? 0;
          // print('startIndex: ${startIndex}');
          // print('endIndex: ${endIndex}');
          if (startIndex < endIndex) {
            spans.add(TextSpan(
              text: text.substring(atIndex, startIndex),
              style: _textStyle,
            ));
            clickSpans.add(TextSpan(
              text: text.substring(atIndex, startIndex),
              style: _textStyle,
            ));
            spans.add(
              TextSpan(
                text: text.substring(startIndex, endIndex),
                style: _clickTextStyle,
                mouseCursor: SystemMouseCursors.click,
              ),
            );
            clickSpans.add(
                TextSpan(
                  text: text.substring(startIndex, endIndex),
                  style: _clickTextStyle,
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _onTap(text.substring(startIndex, endIndex)),
                ),
            );
            // debugPrint('is highlight text span!!!!');
            atIndex = endIndex;
            _scanner.position = atIndex;
          } else {
            _scanner.position++;
          }
        } else if (text.length > _scanner.position) {
          _scanner.position++;
        } else {
          break;
        }
      }
    }
    _scanner.position = 0;
    spans.add(TextSpan(
      text: '${text.substring(atIndex, (text.isNotEmpty) ? text.length : 0)}\u00A0',
      style: _textStyle,
    ));
    clickSpans.add(TextSpan(
      text: '${text.substring(atIndex, (text.isNotEmpty) ? text.length : 0)}\u00A0',
      style: _textStyle,
    ));
    // debugPrint('build TextSpan successfully');
    textSpan = TextSpan(
      children: spans,
      mouseCursor: SystemMouseCursors.text,
    );
    clickTextSpan = TextSpan(
      children: clickSpans,
      mouseCursor: SystemMouseCursors.text,
    );
    // clickTextSpanNotifier.value = TextSpan(
    //   children: clickSpans,
    //   mouseCursor: SystemMouseCursors.text,
    // );
    return textSpan;
  }
}
