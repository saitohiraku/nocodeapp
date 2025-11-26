import 'package:flutter/material.dart';
import 'pages/generate_page.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIアプリメーカー',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GeneratePage(),  // ← こっちを使う
      debugShowCheckedModeBanner: false,
    );
  }
}
