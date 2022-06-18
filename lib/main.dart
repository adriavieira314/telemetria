import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemetria/pages/configuracoes/configuracoes_screen.dart';
import 'package:telemetria/pages/servidor/servidor_screen.dart';
import 'package:telemetria/utils/constants.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  getServer();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: prefs.getString('server') == null
          ? const ServidorScreen()
          : const ConfiguracoesScreen(),
    );
  }
}
