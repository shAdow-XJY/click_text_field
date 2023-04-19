## INTRODUCE
 [example]()
 A flutter TextField which is able to click the highlight text part, by setting the regex.
 Also a string callBack function can be set.

### INSTALL

```
    dev_dependencies:
        click_text_field: ^last_version
```

### USAGE
use ClickTextField
```
    ClickTextField(
        controller: ClickTextEditingController(),
        regExp: RegExp(r'people c'),
        onTapText: (clickCallBack) => {
           debugPrint('U click the highlight text $clickCallBack'),
        }
    )
```

### Mobile Warning
Constructor Function
```
const ClickTextField({
      Key? key,
      required this.regExp,
      required this.onTapText,
      required this.controller,
      this.clickTextStyle,
      this.focusNode,
      this.decoration,
      this.enable,
      this.onChanged,
      this.textAlign
 }) : super(key: key);
```

### Mobile Warning
When running in Mobile, it maybe reports a error:
```
 rendering/editable.dart': Failed assertion: line 1336 pos 14: 'readOnly && !obscureText': is not true.
```
I don't have some good idea now, I choose to delete the check code to avoid.
```
if (_semanticsInfo!.any((InlineSpanSemanticsInformation info) => info.recognizer != null) &&
defaultTargetPlatform != TargetPlatform.macOS) {
// the next code to delete
// assert(readOnly && !obscureText);
```

### link
1. source code: [https://github.com/shAdow-XJY/click_text_field](https://github.com/shAdow-XJY/click_text_field)

2. pub: [https://pub.dev/packages/click_text_field](https://pub.dev/packages/click_text_field)