import 'package:cryptomoeda/pages/home_page.dart';

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          brightness: Brightness.dark,
        ),
        primaryColor: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}
