import 'package:flutter/material.dart';
import 'package:loginlogoutpage/screens/product_list_screens.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductListScreens(),
    );
  }
}
