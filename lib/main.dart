import 'package:convert_image_extension/png_to_jpg/png_to_jpg_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                color: Colors.red,
                centerTitle: true,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const PngTOJpgView());
  }
}
