import 'package:click_text_field/src/regexp_dawg.dart';
import 'package:flutter/material.dart';
import '../click_text_field.dart';


class SuggestClickTextField extends StatefulWidget {
  final RegExp regExp;
  final Function(String) onTapText;
  final ClickTextEditingController controller;
  final TextStyle? textStyle;
  final TextStyle? clickTextStyle;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  const SuggestClickTextField(
      { Key? key,
        required this.regExp,
        required this.onTapText,
        required this.controller,
        this.textStyle,
        this.clickTextStyle,
        this.focusNode,
        this.onChanged,
      }) : super(key: key);

  @override
  State<SuggestClickTextField> createState() => _SuggestClickTextFieldState();
}

class _SuggestClickTextFieldState extends State<SuggestClickTextField> {
  final GlobalKey _fieldKey = GlobalKey();
  final GlobalKey _overlayKey = GlobalKey();
  
  double maxWidth = 0.0;

  late FocusNode focusNode;

  final mtcStrNotifier = ValueNotifier<String>('');
  final suggestNotifier = ValueNotifier<bool>(false);

  final DAWG _dawg = DAWG();

  int _startIndex = -1;
  int _endIndex = -1;

  /// overLay Widget
  double overHeight = 150;
  double overWidth = 160;
  double lineHeight = 40.0;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode??FocusNode();
    widget.regExp.pattern.split('|').forEach((element) {
      _dawg.addString(element);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateMaxWidth();
    });
  }

  void updateMaxWidth() {
    final RenderBox? box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      maxWidth = box.size.width;
    }
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
          suggestNotifier.value = false;
          Future.delayed(Duration.zero, () {
            _startIndex = selection.baseOffset - 1;
            _endIndex = selection.baseOffset;
            mtcStrNotifier.value = beginChar;
            suggestNotifier.value = true;
          });
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

  Offset getPosition() {
    updateMaxWidth();

    final painter = TextPainter(
      text: widget.controller.buildTextSpan(context: _fieldKey.currentContext!, withComposing: false),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );

    painter.layout(maxWidth: maxWidth);

    lineHeight = painter.preferredLineHeight * 2.0;

    final cursorOffset = painter.getOffsetForCaret(
      TextPosition(offset: _startIndex),
      Rect.zero,
    );

    /// 屏幕全局的光标位置
    final textFieldRenderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final textFieldGlobalOffset = textFieldRenderBox.localToGlobal(Offset.zero);
    final textFieldLocalOffset = textFieldRenderBox.localToGlobal(cursorOffset);

    double offsetX = textFieldLocalOffset.dx > (maxWidth - overWidth) ? (maxWidth - overWidth) : textFieldLocalOffset.dx;
    double offsetY = textFieldLocalOffset.dy - textFieldGlobalOffset.dy + lineHeight;

    return Offset(offsetX, offsetY);
  }

  Widget overlayWidget(List<String> items, Offset offset) {
    final text = widget.controller.text;
    return Positioned(
      key: _overlayKey,
      left: offset.dx,
      top: offset.dy,
      child: Container(
        height: overHeight,
        width: overWidth,
        color: Theme.of(context).primaryColorDark,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      // 处理列表项的点击事件
                      focusNode.requestFocus();
                      widget.controller.text = text.replaceRange(_startIndex, _endIndex, items[index]);
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _startIndex + items[index].length),
                      );
                      _startIndex = -1;
                      _endIndex = -1;
                      mtcStrNotifier.value = '';
                      suggestNotifier.value = false;
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void tapOutside(Offset tapOffset) {
    if (!suggestNotifier.value) {
      return;
    }
    // 获取当前点击位置的相对位置信息
    final RenderBox overlayBox = _overlayKey.currentContext!.findRenderObject() as RenderBox;
    final Offset overlayOffset = overlayBox.localToGlobal(Offset.zero);
    final Size overlaySize = overlayBox.size;
    final Offset position = tapOffset;
    final Offset relativePosition = Offset(position.dx - overlayOffset.dx, position.dy - overlayOffset.dy);

    // 判断点击位置是否在 overlayWidget 上
    final bool isOnOverlay = relativePosition.dx >= 0 &&
        relativePosition.dx <= overlaySize.width &&
        relativePosition.dy >= 0 &&
        relativePosition.dy <= overlaySize.height;

    if (!isOnOverlay) {
      mtcStrNotifier.value = '';
      suggestNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Column(
              children: [
                ClickTextField(
                  key: _fieldKey,
                  controller: widget.controller,
                  focusNode: focusNode,
                  regExp: widget.regExp,
                  onTapText: widget.onTapText,
                  textStyle: widget.textStyle,
                  clickTextStyle: widget.clickTextStyle,
                  onChanged: (text) {
                    matchListener(text);
                    if (widget.onChanged != null) {
                      widget.onChanged!(text);
                    }
                  },
                  onTap: () {
                    if (widget.controller.selection.baseOffset != _endIndex) {
                      mtcStrNotifier.value = '';
                      suggestNotifier.value = false;
                    }
                  },
                  onTapOutside: (PointerDownEvent e) {
                    focusNode.unfocus();
                    tapOutside(e.position);
                  },
                ),
                SizedBox(height: overHeight + lineHeight,),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: suggestNotifier,
              builder: (context, value, child) {
                return value
                    ? ValueListenableBuilder<String>(
                  valueListenable: mtcStrNotifier,
                  builder: (context, value, child) {
                    return overlayWidget(_dawg.getPrefixMatches(value), getPosition());
                  },
                )
                    : const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }
}
