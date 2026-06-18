import 'package:flutter/material.dart';
import 'package:hire_up/screens/A/sign_up_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscureText = false;
  bool keepLogin = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      decoration: BoxDecoration(
        color: Color(0xfffdfdfd),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              color: Color(0xffE7E7E7),
            ),
            height: 4,
            width: 40,
          ),
          SizedBox(height: 30),
          Text(
            "로그인",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "HireUp에 오신 것을 환영합니다",
            style: TextStyle(
              color: titleText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 40),
          textFields(),
          SizedBox(height: 20),
          keepLoginWidget(),
          SizedBox(height: 30),
          loginButton(),
          SizedBox(height: 25),
          signUpWidget(),
        ],
      ),
    );
  }

  OutlineInputBorder border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xffE8E8E8)),
  );

  textFields() {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            fillColor: Color(0xffF7F8FA),
            filled: true,
            border: border(),
            enabledBorder: border(),
            focusedBorder: border(),
            hint: Text(
              "이메일을 입력해주세요",
              style: TextStyle(color: subText, fontSize: 16),
            ),
            prefixIcon: Icon(Icons.email_outlined, color: subText),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: passwordController,
          obscureText: isObscureText,
          decoration: InputDecoration(
            fillColor: Color(0xffF7F8FA),
            filled: true,
            border: border(),
            enabledBorder: border(),
            focusedBorder: border(),
            hint: Text(
              "비밀번호를 입력해주세요",
              style: TextStyle(color: subText, fontSize: 16),
            ),
            prefixIcon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, color: subText),
                Positioned(
                  bottom: 18,
                  child: Container(
                    color: Colors.white,
                    width: 4,
                    height: 5,
                  ),
                ),
              ],
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => isObscureText = !isObscureText),
              child: Icon(
                color: subText,
                isObscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }

  keepLoginWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(2),
                side: BorderSide(width: 1.5, color: Colors.black),
              ),
              value: keepLogin,
              activeColor: mainColor,
              onChanged: (value) => setState(() {
                keepLogin = !keepLogin;
              }),
            ),
            Text(
              "로그인 상태 유지",
              style: TextStyle(
                color: titleText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: () => showMessage(context, "비밀번호 찾기 기능 아직 준비중입니다."),
          child: Text(
            "비밀번호 찾기",
            style: TextStyle(
              color: mainColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  loginButton() {
    return GestureDetector(
      onTap: () => showMessage(context, "로그이"),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14),
        width: MediaQuery.widthOf(context),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "로그인",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  signUpWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: subText,
                height: 1,
              ),
            ),
            Padding(
              padding: .symmetric(horizontal: 12),
              child: Text(
                "또는",
                style: TextStyle(
                  color: subText,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: subText,
                height: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "계정이 없으신가요? ",
              style: TextStyle(
                color: subText,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              child: Text(
                "회원가입",
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
