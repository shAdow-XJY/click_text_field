## INTRODUCE
 ![example](https://github.com/shAdow-XJY/click_text_field/blob/master/asset/example.png)
 A flutter TextField which is able to click the highlight text part.
 * set the regex
 * set the textStyle
 * set a string callBack function
 * suggestClickTextField (!!!Beta)

---

### INSTALL

```
    dev_dependencies:
        click_text_field: ^last_version
```

### USAGE
##### use ClickTextField
```
    ClickTextField(
        controller: ClickTextEditingController(),
        regExp: RegExp(r'people c'),
        clickTextStyle: TextStyle(
           background: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.cyanAccent,
        ),
        onTapText: (clickCallBack) => {
           debugPrint('U click the highlight text $clickCallBack'),
        }
    )
```
##### use suggestClickTextField (!!Beta)
```
    SuggestClickTextField(
      controller: ClickTextEditingController(),
      regExp: RegExp(r'people a|people b|people c|embed c|building d|人物一'),
      textStyle: const TextStyle(
        color: Colors.deepPurple
      ),
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
```

### Warning
When running in different SDK version, it maybe reports a error:
```
 rendering/editable.dart': Failed assertion: line 1336 pos 14: 'readOnly && !obscureText': is not true.
```
delete the check code or change use new SDK version to avoid.
```
if (_semanticsInfo!.any((InlineSpanSemanticsInformation info) => info.recognizer != null) &&
defaultTargetPlatform != TargetPlatform.macOS) {
// the next code to delete
// assert(readOnly && !obscureText);
```

### link
1. source code: [https://github.com/shAdow-XJY/click_text_field](https://github.com/shAdow-XJY/click_text_field)

2. pub: [https://pub.dev/packages/click_text_field](https://pub.dev/packages/click_text_field)