import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClickTextField extends StatefulWidget {
  ClickTextField({
    Key? key,
    FocusNode? focusNode,
    bool readOnly = false,
    bool? showCursor,
    bool autofocus = false,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    void Function(String)? onChanged,
    void Function()? onEditingComplete,
    void Function(String)? onSubmitted,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),

    MouseCursor? mouseCursor,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
  }) : super(key: key);

  @override
  _ClickTextFieldState createState() => _ClickTextFieldState();
}

class _ClickTextFieldState extends State<ClickTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(

    );
  }
}
