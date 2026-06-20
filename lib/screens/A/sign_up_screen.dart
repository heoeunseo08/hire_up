import 'package:flutter/material.dart';
import 'package:hire_up/utils/info.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Column(
        children: [

        ],
      )
    );
  }

  Widget titleWidget(){
    return Row(
      children: [
        Column(
          children: [
            Text(""),
          ],
        )
      ],
    );
}
}
