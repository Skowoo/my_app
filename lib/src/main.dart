import 'package:flutter/material.dart';
import 'package:my_app/src/logic/app_state.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(300, 80)),
              textStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
