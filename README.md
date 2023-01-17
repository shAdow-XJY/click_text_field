## INTRODUCE

 A flutter TextField which is able to click the highlight text part, by setting the regex.
 Also a string callBack function can be set.

### INSTALL

```
    dev_dependencies:
        click_text_field: ^last_version
```

### USAGE

1. use ClickTextEditingController
```
    import 'package:click_text_field/click_text_field.dart';
    
    class _MyHomePageState extends State<MyHomePage> {
    
      final ClickTextEditingController textEditingController = ClickTextEditingController();
    
      @override
      void initState() {
        ······
        textEditingController.setRegExp(RegExp(r'people'));
        textEditingController.setOnTapEvent((strCallBack) => {
          debugPrint('U click the highlight text $strCallBack'),
        });
      }
    
      @override
      Widget build(BuildContext context) {
        return 
            ······
            TextField(
              controller: textEditingController,
              maxLines: null,
            ),
            ······
      }
    }

```
2. use ClickTextField
```
    ClickTextField(
        controller: ClickTextEditingController(),
        regExp: RegExp(r'people c'),
        onTapText: (clickCallBack) => {
           debugPrint('U click the highlight text $clickCallBack'),
        }
    )
```
### link
1. source code: [https://github.com/shAdow-XJY/click_text_field](https://github.com/shAdow-XJY/click_text_field)

2. pub: [https://pub.dev/packages/click_text_field](https://pub.dev/packages/click_text_field)