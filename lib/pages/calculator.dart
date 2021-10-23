import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Calculator extends StatelessWidget {
  const Calculator({Key? key}) : super(key: key);

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextField(
              textDirection: TextDirection.rtl,
              readOnly: true,
              showCursor: true,
              style: const TextStyle(
                fontSize: 48,
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(child: generateKeyboard()),
          ],
        ),
      ),
    );
  }

  Widget generateKeyboard() {
    List<Widget> columnChildren = [];
    for (int i = 0; i < keyboardLayout.length; i++) {
      List<Widget> rowChildren =
          keyboardLayout[i].map((e) => CalcButton(e)).toList();
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
}

class CalcButton extends StatelessWidget {
  final ButtonData data;

  const CalcButton(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Material(
        shape: const CircleBorder(),
        color: data.backgroundColor,
        child: InkWell(
          onTap: () => {},
          customBorder: const CircleBorder(),
          splashColor: data.splashColor,
          highlightColor: data.highlightColor,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              data.text,
              style: TextStyle(
                color: data.textColor,
                fontSize: 24,
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

  const ButtonData({
    this.backgroundColor,
    this.textColor,
    this.splashColor,
    this.highlightColor,
    required this.text,
  });

  ButtonData.fromMaterialColor({
    required MaterialColor color,
    required this.text,
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
    ButtonData.fromMaterialColor(color: Colors.red, text: 'C'),
    ButtonData.fromMaterialColor(color: Colors.green, text: '('),
    ButtonData.fromMaterialColor(color: Colors.green, text: ')'),
    ButtonData.fromMaterialColor(color: Colors.green, text: '/'),
  ],
  [
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '7'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '8'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '9'),
    ButtonData.fromMaterialColor(color: Colors.green, text: '*'),
  ],
  [
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '4'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '5'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '6'),
    ButtonData.fromMaterialColor(color: Colors.green, text: '-'),
  ],
  [
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '1'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '2'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '3'),
    ButtonData.fromMaterialColor(color: Colors.green, text: '+'),
  ],
  [
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '0'),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: ','),
    ButtonData.fromMaterialColor(color: Colors.lightBlue, text: '<='),
    ButtonData.fromMaterialColor(color: Colors.deepPurple, text: '='),
  ],
];
