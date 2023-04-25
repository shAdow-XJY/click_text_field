import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_scanner/string_scanner.dart';

TextStyle clickTextStyle = TextStyle(
  textBaseline: TextBaseline.alphabetic,
  background: Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2
    ..color = Colors.deepPurpleAccent,
);

class ClickTextEditingController extends TextEditingController {
  RegExp _regExp = RegExp(r'');
  StringScanner _scanner = StringScanner("");
  Function(String) _onTap = (String clickText) {};
  TextStyle _clickTextStyle = clickTextStyle;

  void setRegExp(RegExp regExp) {
    if (_regExp.toString().compareTo(regExp.toString()) != 0) {
      // debugPrint(regExp.toString());
      _regExp = regExp;
    }
  }

  RegExp getRegExp() {
    return _regExp;
  }

  void setClickTextStyle(TextStyle textStyle) {
    _clickTextStyle = textStyle;
  }

  void setOnTapEvent(Function(String) onTap) {
    _onTap = onTap;
  }

  void runOnTapEvent(String clickText) {
    _onTap(clickText);
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    // debugPrint('scanning text as follow:');
    // debugPrint(text);

    var atIndex = 0;
    var spans = <InlineSpan>[];

    _scanner = StringScanner(text);
    if (_regExp.pattern.isNotEmpty) {
      while (!_scanner.isDone) {
        // debugPrint('scanning');
        // print('position: ${_scanner.position}');
        if (_scanner.scan(_regExp)) {
          int startIndex = _scanner.lastMatch?.start ?? 0;
          int endIndex = _scanner.lastMatch?.end ?? 0;
          // print('startIndex: ${startIndex}');
          // print('endIndex: ${endIndex}');
          if (startIndex < endIndex) {
            spans.add(TextSpan(
              text: text.substring(atIndex, startIndex),
              mouseCursor: SystemMouseCursors.text,
            ));
            spans.add(
              TextSpan(children: [
                TextSpan(
                  text: text.substring(startIndex, endIndex),
                  style: _clickTextStyle,
                  mouseCursor: SystemMouseCursors.click,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        runOnTapEvent(text.substring(startIndex, endIndex)),
                ),
              ]),
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
      text: text.substring(atIndex, (text.isNotEmpty) ? text.length : 0),
      mouseCursor: SystemMouseCursors.text,
    ));
    spans.add(const TextSpan(
      text: ' ',
      mouseCursor: SystemMouseCursors.text,
    ));
    // debugPrint('build TextSpan successfully');
    return TextSpan(
      children: spans,
      mouseCursor: SystemMouseCursors.text,
    );
  }
}
