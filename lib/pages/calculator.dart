import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:function_tree/function_tree.dart';

class Calculator extends StatelessWidget {
  final TextEditingController _controller;

  Calculator({Key? key})
      : _controller = TextEditingController(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: GoogleFonts.jost(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _controller,
              readOnly: true,
              showCursor: true,
              style: const TextStyle(
                fontSize: 48,
              ),
              autofocus: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              cursorRadius: Radius.circular(3.0),
              cursorWidth: 3,
            ),
            const SizedBox(height: 48.0),
            Expanded(child: generateKeyboard()),
          ],
        ),
      ),
    );
  }

  Widget generateKeyboard() {
    List<Widget> columnChildren = [];
    for (int i = 0; i < keyboardLayout.length; i++) {
      List<Widget> rowChildren = keyboardLayout[i].map((data) {
        VoidCallback onTap;
        switch (data.action) {
          case Action.insert:
            onTap = () {
              String expression = _controller.text;
              TextSelection selection = _controller.selection;

              if (selection.start == -1) {
                expression += data.text;
                selection = TextSelection.fromPosition(TextPosition(offset: data.text.length));
              } else {
                expression = expression.replaceRange(
                    selection.start, selection.end, data.text);
                selection = TextSelection.collapsed(
                    offset: selection.baseOffset + data.text.length);
              }

              _controller.value = TextEditingValue(
                text: expression,
                selection: selection,
              );
            };
            break;
          case Action.backspace:
            onTap = () {
              String expression = _controller.text;
              TextSelection selection = _controller.selection;

              if (expression == '') {
                return;
              } else if (selection.end != selection.start) {
                // there is a selection
                expression =
                    expression.replaceRange(selection.start, selection.end, '');
              } else if (selection.start == -1) {
                expression = expression.substring(0, expression.length - 1);
              } else if (selection.start == 0) {
                return;
              } else {
                expression = expression.replaceRange(
                    selection.start - 1, selection.start, '');
              }
              selection = selection.copyWith(
                baseOffset: selection.start - 1,
                extentOffset: selection.start - 1,
              );

              _controller.value = TextEditingValue(
                text: expression,
                selection: selection,
              );
            };
            break;
          case Action.clearAll:
            onTap = () {
              String expression = _controller.text;
              TextSelection selection = _controller.selection;

              expression = '';
              selection = TextSelection.fromPosition(TextPosition(offset: 0));

              _controller.value = TextEditingValue(
                text: expression,
                selection: selection,
              );
            };
            break;
          case Action.evaluate:
            onTap = () {
              String expression = _controller.text;
              TextSelection selection = _controller.selection;

              final result;
              try {
                result = _evaluate(expression);
                expression = '$result';
              } catch (e) {
                expression = 'Error';
              } finally {
                selection = TextSelection.fromPosition(
                    TextPosition(offset: expression.length));

                _controller.value = TextEditingValue(
                  text: expression,
                  selection: selection,
                );
              }
            };
            break;
        }
        return CalcButton(
          data: data,
          onTap: onTap,
        );
      }).toList();
      columnChildren.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ));
    }
    Column grid = Column(
      children: columnChildren,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
    return grid;
  }

  num _evaluate(String expression) {
    return expression.interpret();
  }
}

class CalcButton extends StatelessWidget {
  final ButtonData data;
  final VoidCallback onTap;

  const CalcButton({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Material(
        shape: const CircleBorder(),
        color: data.backgroundColor,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: data.splashColor,
          highlightColor: data.highlightColor,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              data.text,
              style: TextStyle(
                color: data.textColor,
                fontSize: 36,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonData {
  final Color? backgroundColor;
  final Color? textColor;
  final Color? splashColor;
  final Color? highlightColor;
  final String text;
  final Action action;

  const ButtonData({
    this.backgroundColor,
    this.textColor,
    this.splashColor,
    this.highlightColor,
    required this.text,
    required this.action,
  });

  ButtonData.fromMaterialColor({
    required MaterialColor color,
    required this.text,
    required this.action,
  })  : backgroundColor = color.shade50,
        textColor = color,
        splashColor = color.shade200,
        highlightColor = color.shade100;
}

/*
C  (  )  /
7  8  9  *
4  5  6  -
1  2  3  +
0  ,  <= =
*/
List<List<ButtonData>> keyboardLayout = [
  [
    ButtonData.fromMaterialColor(
        color: Colors.red, text: 'C', action: Action.clearAll),
    ButtonData.fromMaterialColor(
        color: Colors.green, text: '(', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.green, text: ')', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.green, text: '/', action: Action.insert),
  ],
  [
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '7', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '8', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '9', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.green, text: '*', action: Action.insert),
  ],
  [
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '4', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '5', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '6', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.green, text: '-', action: Action.insert),
  ],
  [
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '1', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '2', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '3', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.green, text: '+', action: Action.insert),
  ],
  [
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '0', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.lightBlue, text: '.', action: Action.insert),
    ButtonData.fromMaterialColor(
        color: Colors.orange, text: '<=', action: Action.backspace),
    ButtonData.fromMaterialColor(
        color: Colors.deepPurple, text: '=', action: Action.evaluate),
  ],
];

enum Action {
  insert,
  backspace,
  clearAll,
  evaluate,
}
