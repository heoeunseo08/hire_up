import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hire_up/controller/auth_controller.dart';
import 'package:hire_up/screens/app_screen.dart';
import 'package:hire_up/utils/info.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await AuthController().loadTkn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.dho
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: AppScreen(),
      scaffoldMessengerKey: globalKey,
    );
  }
}
