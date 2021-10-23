import 'package:calculator/pages/calculator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.jostTextTheme(),
      backgroundColor: Colors.white,
    ),
    routes: {
      '/': (_) => Calculator(),
    },
    initialRoute: '/',
  ));
}