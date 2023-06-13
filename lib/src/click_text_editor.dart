import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ClickTextEditor extends StatefulWidget {
  @override
  _ClickTextEditorState createState() => _ClickTextEditorState();
}

class _ClickTextEditorState extends State<ClickTextEditor> {
  List<TextSpan> textSpans = [TextSpan(text: 'asdasdasd')];
  int cursorPosition = -1;
  TextPainter textPainter = TextPainter();

  @override
  void initState() {
    super.initState();
    textPainter.textDirection = TextDirection.ltr;
    textPainter.text = TextSpan(style: TextStyle(fontSize: 16), children: textSpans);
    textPainter.layout();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final tapPosition = box.globalToLocal(details.globalPosition);
        final offset = _getCursorPosition(tapPosition);
        setState(() {
          cursorPosition = offset;
        });
      },
      onLongPressMoveUpdate: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final tapPosition = box.globalToLocal(details.globalPosition);
        final offset = _getCursorPosition(tapPosition);
        setState(() {
          cursorPosition = offset;
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: CustomPaint(
          painter: _EditorPainter(
            textSpans: textSpans,
            cursorPosition: cursorPosition,
            textPainter: textPainter,
          ),
        ),
      ),
    );
  }

  int _getCursorPosition(Offset position) {
    int offset = 0;
    for (final span in textSpans) {
      final spanWidth = textPainter.width;
      if (position.dx <= spanWidth) {
        final textOffset = textPainter.getPositionForOffset(position);
        final textOffsetIndex = textOffset.offset;
        return offset + textOffsetIndex;
      }
      offset += span.toPlainText().length;
    }
    return offset;
  }
}

class _EditorPainter extends CustomPainter {
  final List<TextSpan> textSpans;
  final int cursorPosition;
  final TextPainter textPainter;

  _EditorPainter({required this.textSpans, required this.cursorPosition, required this.textPainter});

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制文本
    textPainter.paint(canvas, Offset.zero);
    // 绘制光标
    if (cursorPosition >= 0 && cursorPosition <= textPainter.text!.toPlainText().length) {
      final offset = _getTextOffsetAtPosition(cursorPosition);
      final cursorOffset = textPainter.getOffsetForCaret(TextPosition(offset: offset), Rect.zero);
      final cursorPaint = Paint()..color = Colors.black;
      canvas.drawLine(
        cursorOffset + Offset(0, -textPainter.height),
        cursorOffset + Offset(0, textPainter.height),
        cursorPaint,
      );
    }
  }

  int _getTextOffsetAtPosition(int position) {
    int offset = 0;
    for (final span in textSpans) {
      final spanLength = span.toPlainText().length;
      if (position <= offset + spanLength) {
        return position - offset;
      }
      offset += spanLength;
    }
    return offset;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

