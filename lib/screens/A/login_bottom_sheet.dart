import 'package:flutter/material.dart';
import 'package:hire_up/controller/auth_controller.dart';
import 'package:hire_up/screens/A/sign_up_screen.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart' show inputBorder;

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isObscureText = true;
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
              color: titleColor,
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

  OutlineInputBorder _border() => inputBorder(Color(0xffE8E8E8));

  textFields() {
    return Column(
      children: [
        TextFormField(
          key: const Key('login_email_field'),
          controller: emailController,
          decoration: InputDecoration(
            fillColor: Color(0xffF7F8FA),
            filled: true,
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(),
            hint: Text(
              "이메일을 입력해주세요",
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            prefixIcon: Icon(Icons.email_outlined, color: subColor),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          key: const Key('login_password_field'),
          controller: passwordController,
          obscureText: isObscureText,
          decoration: InputDecoration(
            fillColor: Color(0xffF7F8FA),
            filled: true,
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(),
            hint: Text(
              "비밀번호를 입력해주세요",
              style: TextStyle(color: subColor, fontSize: 16),
            ),
            prefixIcon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, color: subColor),
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
                color: subColor,
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

  loginButton() {
    final authController = AuthController();
    return GestureDetector(
      onTap: () async {
        final emailError = authController.checkLoginEmail(emailController.text);
        if (emailError != null) {
          showMessage(emailError);
          return;
        }
        final passwordError = authController.checkLoginPassword(
          passwordController.text,
        );
        if (passwordError != null) {
          showMessage(passwordError);
          return;
        }

        final success = await authController.login(
          email: emailController.text,
          password: passwordController.text,
          keepLogin: keepLogin,
        );

        if (success) {
          Navigator.pop(context);
          showMessage("로그인 되었습니다.");
        } else {
          showMessage(authController.error ?? '로그인에 실패했습니다.');
        }
      },
      child: Container(
        key: const Key('login_submit_btn'),
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
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        GestureDetector(
          onTap: () => showMessage("비밀번호 찾기 기능 아직 준비중입니다."),
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

  signUpWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(
                color: subColor,
                height: 1,
              ),
            ),
            Padding(
              padding: .symmetric(horizontal: 12),
              child: Text(
                "또는",
                style: TextStyle(
                  color: subColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: subColor,
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
                color: subColor,
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
