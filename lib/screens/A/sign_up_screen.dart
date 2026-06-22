import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hire_up/controller/auth_controller.dart';
import 'package:hire_up/controller/method_controller.dart';
import 'package:hire_up/screens/A/login_bottom_sheet.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthController authController = AuthController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController1 = TextEditingController();
  TextEditingController phoneController2 = TextEditingController();
  TextEditingController phoneController3 = TextEditingController();
  TextEditingController codeController = TextEditingController();

  bool isObscurePassword = true;
  bool isObscurePasswordCheck = true;
  bool sendCode = false;
  bool checkCode = false;

  @override
  void initState() {
    super.initState();
    MethodController().checkPermission();
    MethodController.smsChannel.setMethodCallHandler(
      (call) async {
        print('채널 호출됨: ${call.method}');
        if (call.method == 'smsRead') {
          print('인증번호: ${call.arguments}');
          setState(() {
            codeController.text = call.arguments as String;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            showLoginBottomSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            titleWidget(),
            SizedBox(height: 30),
            textFields(),
            SizedBox(height: 10),
            checkButton(),
            SizedBox(height: 20),
            if (sendCode) inputCode(),
            signUpButton(),
            SizedBox(height: 30),
            loginText(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget loginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "이미 계정이 있으신가요? ",
          style: TextStyle(
            color: subText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            showLoginBottomSheet(context);
          },
          child: Text(
            "로그인",
            style: TextStyle(
              color: mainColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget checkButton() {
    return GestureDetector(
      onTap: () async {
        final String phone =
            '${phoneController1.text}${phoneController2.text}${phoneController3.text}';
        final phoneError = authController.checkSignupNumber(
          phoneController1.text,
          phoneController2.text,
          phoneController3.text,
        );

        if (phoneError != null) {
          showMessage(context, phoneError);
          return;
        }
        final success = await authController.sendCode(phone: phone);
        if (success) {
          setState(() => sendCode = true);
        } else {
          showMessage(context, authController.error ?? "인증번호 발송에 실패하셨셨습니다.");
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.widthOf(context),
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: checkCode ? Color(0xffdfede4) : bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: checkCode ? Color(0xff69C463) : mainColor),
        ),
        alignment: Alignment.center,
        child: checkCode
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xff69C463),
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '인증완료',
                    style: TextStyle(
                      color: Color(0xff69C463),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : Text(
                sendCode ? "인증번호 재발송" : "인증번호 발송",
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () async {
        final emailError = authController.checkSignupEmail(
          emailController.text,
        );
        if (emailError != null) {
          showMessage(context, emailError);
          return;
        }

        final passwordError = authController.checkSignupPassword(
          passwordController.text,
          passwordCheckController.text,
        );
        if (passwordError != null) {
          showMessage(context, passwordError);
          return;
        }

        final nameError = authController.checkSignupName(nameController.text);
        if (nameError != null) {
          showMessage(context, nameError);
          return;
        }

        final numberError = authController.checkSignupNumber(
          phoneController1.text,
          phoneController2.text,
          phoneController3.text,
        );
        if (numberError != null) {
          showMessage(context, numberError);
          return;
        }
        if (!checkCode) {
          showMessage(context, '휴대폰 인증을 완료해주세요.');
          return;
        }

        final success = await authController.signup(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          phone:
              '${phoneController1.text}${phoneController2.text}${phoneController3.text}',
        );
        if (success) {
          showMessage(context, "회원가입에 성공하셨습니다.");
          await Future.delayed(Duration(seconds: 1));
          Navigator.pop(context);
          showLoginBottomSheet(context);
        } else {
          showMessage(context, authController.error ?? "회원가입에 실패하셨습니다.");
          log(authController.error??'');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.widthOf(context),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
          child: Text(
          "회원가입",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget inputCode() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "인증번호",
            style: TextStyle(
              color: titleText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (value) {
                    setState(() {});
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: border(Color(0xffE9E7E8)),
                    disabledBorder: border(Color(0xffE9E7E8)),
                    enabledBorder: border(Color(0xffE9E7E8)),
                    focusedBorder: border(mainColor),
                    fillColor: Color(0xffF7F8FA),
                    filled: true,
                    hint: Text(
                      textAlign: TextAlign.center,
                      "인증번호 6자리",
                      style: TextStyle(
                        color: subText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    focusColor: mainColor,
                    counterText: '',
                  ),
                  cursorColor: mainColor,
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () async {
                  final String phone =
                      '${phoneController1.text}${phoneController2.text}${phoneController3.text}';

                  final success = await authController.checkCode(
                    phone: phone,
                    code: codeController.text,
                  );
                  if (success) {
                    setState(
                      () {
                        checkCode = true;
                        sendCode = false;
                      },
                    );
                  } else {
                    showMessage(
                      context,
                      authController.error ?? "인증번호가 올바르지않습니다.",
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffEEF2FE),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget titleWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Image.asset(
                "assets/simbol/logo_vertical.png",
                width: 110,
              ),
              SizedBox(height: 16),
              Text(
                "회원가입",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 6),
              Text(
                textAlign: TextAlign.start,
                "HireHp 계정을 만들어\n취업 준비를 시작해보세요!",
                style: TextStyle(
                  color: titleText,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Image.asset(
            "assets/images/sign_up_main_img.png",
            width: 135,
          ),
        ],
      ),
    );
  }

  border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 1.5),
  );

  Widget textFieldWidget({required String text, required Widget textField}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: titleText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          textField,
        ],
      ),
    );
  }

  Widget textFields() {
    return Column(
      spacing: 20,
      children: [
        textFieldWidget(
          text: '이메일',
          textField: TextFormField(
            controller: emailController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: border(Color(0xffE9E7E8)),
              disabledBorder: border(Color(0xffE9E7E8)),
              enabledBorder: border(Color(0xffE9E7E8)),
              focusedBorder: border(mainColor),
              fillColor: Color(0xffF7F8FA),
              filled: true,

              prefixIcon: Icon(Icons.mail_outline_outlined, color: subText),

              hint: Text(
                "이메일을 입력해주세요",
                style: TextStyle(
                  color: subText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              focusColor: mainColor,
            ),
            cursorColor: mainColor,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textFieldWidget(
              text: '비밀번호',
              textField: TextFormField(
                controller: passwordController,
                obscureText: isObscurePassword,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: border(Color(0xffE9E7E8)),
                  disabledBorder: border(Color(0xffE9E7E8)),
                  enabledBorder: border(Color(0xffE9E7E8)),
                  focusedBorder: border(mainColor),
                  fillColor: Color(0xffF7F8FA),
                  filled: true,

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
                    onTap: () =>
                        setState(() => isObscurePassword = !isObscurePassword),
                    child: Icon(
                      color: subText,
                      isObscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),

                  hint: Text(
                    "비밀번호를 입력해주세요",
                    style: TextStyle(
                      color: subText,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  focusColor: mainColor,
                ),
                cursorColor: mainColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "8자 이상, 대소문자, 숫자, 특수문자 포함",
                style: TextStyle(
                  color: subText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        textFieldWidget(
          text: '비밀번호 확인',
          textField: TextFormField(
            controller: passwordCheckController,
            obscureText: isObscurePasswordCheck,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: border(Color(0xffE9E7E8)),
              disabledBorder: border(Color(0xffE9E7E8)),
              enabledBorder: border(Color(0xffE9E7E8)),
              focusedBorder: border(mainColor),
              fillColor: Color(0xffF7F8FA),
              filled: true,

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
                onTap: () => setState(
                  () => isObscurePasswordCheck = !isObscurePasswordCheck,
                ),
                child: Icon(
                  color: subText,
                  isObscurePasswordCheck
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),

              hint: Text(
                "비밀번호를 다시 입력해주세요",
                style: TextStyle(
                  color: subText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              focusColor: mainColor,
            ),
            cursorColor: mainColor,
          ),
        ),
        textFieldWidget(
          text: '이름',
          textField: TextFormField(
            controller: nameController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              border: border(Color(0xffE9E7E8)),
              disabledBorder: border(Color(0xffE9E7E8)),
              enabledBorder: border(Color(0xffE9E7E8)),
              focusedBorder: border(mainColor),
              fillColor: Color(0xffF7F8FA),
              filled: true,

              prefixIcon: Icon(Icons.person_outline, color: subText),

              hint: Text(
                "이름을 입력해주세요",
                style: TextStyle(
                  color: subText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              focusColor: mainColor,
            ),
            cursorColor: mainColor,
          ),
        ),
        textFieldWidget(
          text: '휴대폰 번호',
          textField: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: phoneController1,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  onChanged: (value) {
                    setState(() {});
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: border(Color(0xffE9E7E8)),
                    disabledBorder: border(Color(0xffE9E7E8)),
                    enabledBorder: border(Color(0xffE9E7E8)),
                    focusedBorder: border(mainColor),
                    fillColor: Color(0xffF7F8FA),
                    filled: true,
                    hint: Text(
                      textAlign: TextAlign.center,
                      "010",
                      style: TextStyle(
                        color: subText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    focusColor: mainColor,
                    counterText: '',
                  ),
                  cursorColor: mainColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "-",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: titleText,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: phoneController2,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onChanged: (value) {
                    setState(() {});
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: border(Color(0xffE9E7E8)),
                    disabledBorder: border(Color(0xffE9E7E8)),
                    enabledBorder: border(Color(0xffE9E7E8)),
                    focusedBorder: border(mainColor),
                    fillColor: Color(0xffF7F8FA),
                    filled: true,
                    hint: Text(
                      textAlign: TextAlign.center,
                      "0000",
                      style: TextStyle(
                        color: subText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    focusColor: mainColor,
                    counterText: '',
                  ),
                  cursorColor: mainColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "-",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: titleText,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: phoneController3,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onChanged: (value) {
                    setState(() {});
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: border(Color(0xffE9E7E8)),
                    disabledBorder: border(Color(0xffE9E7E8)),
                    enabledBorder: border(Color(0xffE9E7E8)),
                    focusedBorder: border(mainColor),
                    fillColor: Color(0xffF7F8FA),
                    filled: true,
                    hint: Text(
                      textAlign: TextAlign.center,
                      "0000",
                      style: TextStyle(
                        color: subText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    focusColor: mainColor,
                    counterText: '',
                  ),
                  cursorColor: mainColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
