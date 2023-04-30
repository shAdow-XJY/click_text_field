import 'package:click_text_field/src/regexp_dawg.dart';
import 'package:flutter/material.dart';
import '../click_text_field.dart';


class SuggestClickTextField extends StatefulWidget {
  final RegExp regExp;
  final Function(String) onTapText;
  final ClickTextEditingController controller;
  final TextStyle? clickTextStyle;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final bool? enable;
  final void Function(String)? onChanged;
  final TextAlign? textAlign;
  const SuggestClickTextField(
      {Key? key,
      required this.regExp,
      required this.onTapText,
      required this.controller,
      this.clickTextStyle,
      this.focusNode,
      this.decoration,
      this.enable,
      this.onChanged,
      this.textAlign})
      : super(key: key);

  @override
  State<SuggestClickTextField> createState() => _SuggestClickTextFieldState();
}

class _SuggestClickTextFieldState extends State<SuggestClickTextField> {
  final mtcStrNotifier = ValueNotifier<String>('');
  final suggestNotifier = ValueNotifier<bool>(false);

  final DAWG _dawg = DAWG();

  int _startIndex = -1;
  int _endIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.regExp.pattern.split('|').forEach((element) {
      _dawg.addString(element);
    });
  }

  void matchListener(String text) {
    final selection = widget.controller.selection;
    if (selection.baseOffset > 0 && selection.baseOffset == selection.extentOffset) {
      if (mtcStrNotifier.value.isEmpty) {
        final String beginChar = text.substring(selection.baseOffset - 1, selection.baseOffset);
        if (_dawg.isPrefixMatched(beginChar)) {
          _startIndex = selection.baseOffset - 1;
          _endIndex = selection.baseOffset;
          mtcStrNotifier.value = beginChar;
          suggestNotifier.value = true;
        } else {
          return;
        }
      } else if (selection.baseOffset > _startIndex) {
        final String beginChar = text.substring(selection.baseOffset - 1, selection.baseOffset);
        final String prefixStr = text.substring(_startIndex, selection.baseOffset);
        if (_dawg.isPrefixMatched(prefixStr)) {
          _endIndex = selection.baseOffset;
          mtcStrNotifier.value = prefixStr;
          suggestNotifier.value = true;
        } else if (_dawg.isPrefixMatched(beginChar)) {
          _startIndex = selection.baseOffset - 1;
          _endIndex = selection.baseOffset;
          mtcStrNotifier.value = beginChar;
          suggestNotifier.value = true;
        } else {
          suggestNotifier.value = false;
          return;
        }
      } else {
        mtcStrNotifier.value = '';
        suggestNotifier.value = false;
      }
    } else {
      mtcStrNotifier.value = '';
      suggestNotifier.value = false;
    }
  }

  Widget overlayWidget(List<String> items) {
    final text = widget.controller.text;
    final textDirection = Directionality.of(context);
    final cursorPosition = widget.controller.selection.base.offset;
    final painter = TextPainter(
      text: TextSpan(text: text,),
      textDirection: textDirection,
    );
    painter.layout();
    final cursorOffset = painter.getOffsetForCaret(
      TextPosition(offset: cursorPosition),
      Rect.zero,
    );
    print(items);
    return Positioned(
      left: cursorOffset.dx,
      top: cursorOffset.dy,
      child: Column(
        children: [
          SizedBox(
            height: 100, // 设置最大高度为200
            width: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true, // 关键点：将shrinkWrap属性设置为true
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
                        onTap: () {
                          // 处理列表项的点击事件
                          print('用户选择了 ${items[index]}');
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClickTextField(
          controller: widget.controller,
          focusNode: widget.focusNode ?? FocusNode(),
          regExp: widget.regExp,
          onTapText: widget.onTapText,
          decoration: widget.decoration ?? const InputDecoration(),
          enable: widget.enable,
          onChanged: (text) {
            matchListener(text);
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
          },
          textAlign: widget.textAlign ?? TextAlign.start,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: suggestNotifier,
          builder: (context, value, child) {
            return value
                ? ValueListenableBuilder<String>(
                    valueListenable: mtcStrNotifier,
                    builder: (context, value, child) {
                      return overlayWidget(_dawg.getPrefixMatches(value));
                    },
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
