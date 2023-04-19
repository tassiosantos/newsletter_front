import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeChanger(),
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: 'Aplicativo de Notícias',
      theme: theme.getTheme(),
      home: const Feed(),
    );
  }
}

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger() : _themeData = ThemeData.light();

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
