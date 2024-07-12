import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
  Colors.amber,
  Colors.cyan,
  Colors.lime,
  Colors.indigo,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.yellow,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.deepOrange,
  Colors.limeAccent,
  Colors.tealAccent,
  Colors.greenAccent,
  Colors.blueAccent,
];

const colorNames = <String>[
  'Blue',
  'Teal',
  'Green',
  'Red',
  'Purple',
  'Deep Purple',
  'Orange',
  'Pink',
  'Pink Accent',
  'Amber',
  'Cyan',
  'Lime',
  'Indigo',
  'Light Blue',
  'Light Green',
  'Yellow',
  'Brown',
  'Grey',
  'Blue Grey',
  'Deep Orange',
  'Lime Accent',
  'Teal Accent',
  'Green Accent',
  'Blue Accent',
];

class AppTheme {

  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = false,
  }): assert( selectedColor >= 0, 'Selected color must be greater than or equal to 0' ),  
      assert( selectedColor < colorList.length, 
        'Selected color must be less than ${ colorList.length }');

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: isDarkmode ? Brightness.dark : Brightness.light, // cambia el tema entre claro y oscuro
    colorSchemeSeed: colorList[ selectedColor ],
    appBarTheme: const AppBarTheme(
      centerTitle: false
    ),
    //* Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 20 ),
      displayLarge: GoogleFonts.openSans()
      .copyWith( fontSize: 18, fontWeight: FontWeight.w500,  ),
      displayMedium: GoogleFonts.openSans()
      .copyWith( fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700] ),
    ),
  );


  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkmode
  }) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    isDarkmode: isDarkmode ?? this.isDarkmode,
  );

}
