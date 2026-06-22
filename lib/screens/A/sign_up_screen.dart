import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hire_up/controller/auth_controller.dart';
import 'package:hire_up/controller/method_controller.dart';
import 'package:hire_up/utils/info.dart';
import 'package:hire_up/utils/utils.dart';
import 'package:hire_up/utils/widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authController = AuthController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordCheckController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController1 = TextEditingController();
  final phoneController2 = TextEditingController();
  final phoneController3 = TextEditingController();
  final codeController = TextEditingController();

  bool isObscurePassword = true;
  bool isObscurePasswordCheck = true;
  bool sendCode = false;
  bool checkCode = false;

  String get _phone =>
      '${phoneController1.text}${phoneController2.text}${phoneController3.text}';

  @override
  void initState() {
    super.initState();
    MethodController().checkPermission();
    MethodController.smsChannel.setMethodCallHandler((call) async {
      if (call.method == 'smsRead') {
        setState(() => codeController.text = call.arguments as String);
      }
    });
  }

  @override
  void dispose() {
    for (final c in [
      emailController, passwordController, passwordCheckController,
      nameController, phoneController1, phoneController2,
      phoneController3, codeController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── 공통 헬퍼 ──────────────────────────────────────

  InputDecoration _fieldDecoration({
    required String hint,
    Widget? prefix,
    Widget? suffix,
    String? counter,
  }) => InputDecoration(
    border: inputBorder(Color(0xffE9E7E8)),
    disabledBorder: inputBorder(Color(0xffE9E7E8)),
    enabledBorder: inputBorder(Color(0xffE9E7E8)),
    focusedBorder: inputBorder(mainColor),
    fillColor: Color(0xffF7F8FA),
    filled: true,
    focusColor: mainColor,
    counterText: counter,
    prefixIcon: prefix,
    suffixIcon: suffix,
    hintText: hint,
    hintStyle: TextStyle(color: subText, fontWeight: FontWeight.w600, fontSize: 16),
  );

  Widget _lockIcon() => Stack(
    alignment: Alignment.center,
    children: [
      Icon(Icons.lock_outline_rounded, color: subText),
      Positioned(bottom: 18, child: Container(color: Colors.white, width: 4, height: 5)),
    ],
  );

  Widget _visibilityToggle(bool isObscure, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Icon(
      isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      color: subText,
    ),
  );

  Widget _labeledField(String label, Widget field, {Widget? hint}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: titleText, fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          field,
          if (hint != null) ...[SizedBox(height: 6), hint],
        ],
      ),
    );
  }

  Widget _phoneField(TextEditingController ctrl, int maxLen, String placeholder) =>
    TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      maxLength: maxLen,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      cursorColor: mainColor,
      onChanged: (_) => setState(() {}),
      decoration: _fieldDecoration(hint: placeholder, counter: ''),
    );

  // ── 빌드 ───────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
        leading: GestureDetector(
          onTap: () { Navigator.pop(context); showLoginBottomSheet(context); },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _titleWidget(),
            SizedBox(height: 30),
            _textFields(),
            SizedBox(height: 10),
            _sendCodeButton(),
            SizedBox(height: 20),
            if (sendCode) _inputCode(),
            _signUpButton(),
            SizedBox(height: 30),
            _loginText(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
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
              Image.asset("assets/simbol/logo_vertical.png", width: 110),
              SizedBox(height: 16),
              Text("회원가입", style: TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text(
                "HireHp 계정을 만들어\n취업 준비를 시작해보세요!",
                style: TextStyle(color: titleText, fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Image.asset("assets/images/sign_up_main_img.png", width: 135),
        ],
      ),
    );
  }

  Widget _textFields() {
    return Column(
      spacing: 20,
      children: [
        _labeledField('이메일',
          TextFormField(
            controller: emailController,
            onChanged: (_) => setState(() {}),
            cursorColor: mainColor,
            decoration: _fieldDecoration(hint: '이메일을 입력해주세요', prefix: Icon(Icons.mail_outline_outlined, color: subText)),
          ),
        ),
        _labeledField('비밀번호',
          TextFormField(
            controller: passwordController,
            obscureText: isObscurePassword,
            onChanged: (_) => setState(() {}),
            cursorColor: mainColor,
            decoration: _fieldDecoration(
              hint: '비밀번호를 입력해주세요',
              prefix: _lockIcon(),
              suffix: _visibilityToggle(isObscurePassword, () => setState(() => isObscurePassword = !isObscurePassword)),
            ),
          ),
          hint: Text("8자 이상, 대소문자, 숫자, 특수문자 포함",
            style: TextStyle(color: subText, fontSize: 14, fontWeight: FontWeight.w400)),
        ),
        _labeledField('비밀번호 확인',
          TextFormField(
            controller: passwordCheckController,
            obscureText: isObscurePasswordCheck,
            onChanged: (_) => setState(() {}),
            cursorColor: mainColor,
            decoration: _fieldDecoration(
              hint: '비밀번호를 다시 입력해주세요',
              prefix: _lockIcon(),
              suffix: _visibilityToggle(isObscurePasswordCheck, () => setState(() => isObscurePasswordCheck = !isObscurePasswordCheck)),
            ),
          ),
        ),
        _labeledField('이름',
          TextFormField(
            controller: nameController,
            onChanged: (_) => setState(() {}),
            cursorColor: mainColor,
            decoration: _fieldDecoration(hint: '이름을 입력해주세요', prefix: Icon(Icons.person_outline, color: subText)),
          ),
        ),
        _labeledField('휴대폰 번호',
          Row(
            children: [
              Expanded(child: _phoneField(phoneController1, 3, '010')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("-", style: TextStyle(fontWeight: FontWeight.w700, color: titleText, fontSize: 14))),
              Expanded(child: _phoneField(phoneController2, 4, '0000')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("-", style: TextStyle(fontWeight: FontWeight.w700, color: titleText, fontSize: 14))),
              Expanded(child: _phoneField(phoneController3, 4, '0000')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sendCodeButton() {
    return GestureDetector(
      onTap: () async {
        final err = authController.checkSignupNumber(phoneController1.text, phoneController2.text, phoneController3.text);
        if (err != null) { showMessage(err); return; }
        final ok = await authController.sendCode(phone: _phone);
        if (ok) setState(() => sendCode = true);
        else showMessage(authController.error ?? "인증번호 발송에 실패했습니다.");
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: checkCode ? Color(0xffdfede4) : bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: checkCode ? Color(0xff69C463) : mainColor),
        ),
        child: checkCode
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle, color: Color(0xff69C463), size: 20),
              SizedBox(width: 4),
              Text('인증완료', style: TextStyle(color: Color(0xff69C463), fontWeight: FontWeight.w600, fontSize: 16)),
            ])
          : Text(sendCode ? "인증번호 재발송" : "인증번호 발송",
              style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 16)),
      ),
    );
  }

  Widget _inputCode() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("인증번호", style: TextStyle(color: titleText, fontSize: 14, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  cursorColor: mainColor,
                  onChanged: (_) => setState(() {}),
                  decoration: _fieldDecoration(hint: '인증번호 6자리', counter: ''),
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () async {
                  final ok = await authController.checkCode(phone: _phone, code: codeController.text);
                  if (ok) setState(() { checkCode = true; sendCode = false; });
                  else showMessage(authController.error ?? "인증번호가 올바르지 않습니다.");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xffEEF2FE)),
                  child: Text("확인", style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _signUpButton() {
    return GestureDetector(
      onTap: () async {
        final checks = [
          authController.checkSignupEmail(emailController.text),
          authController.checkSignupPassword(passwordController.text, passwordCheckController.text),
          authController.checkSignupName(nameController.text),
          authController.checkSignupNumber(phoneController1.text, phoneController2.text, phoneController3.text),
        ];
        for (final err in checks) {
          if (err != null) { showMessage(err); return; }
        }
        if (!checkCode) { showMessage('휴대폰 인증을 완료해주세요.'); return; }

        final ok = await authController.signup(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          phone: _phone,
        );
        if (ok) {
          showMessage("회원가입에 성공하셨습니다.");
          await Future.delayed(Duration(seconds: 1));
          Navigator.pop(context);
          showLoginBottomSheet(context);
        } else {
          showMessage(authController.error ?? "회원가입에 실패하셨습니다.");
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: mainColor, borderRadius: BorderRadius.circular(12)),
        child: Text("회원가입", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17)),
      ),
    );
  }

  Widget _loginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("이미 계정이 있으신가요? ", style: TextStyle(color: subText, fontWeight: FontWeight.w600, fontSize: 16)),
        GestureDetector(
          onTap: () { Navigator.pop(context); showLoginBottomSheet(context); },
          child: Text("로그인", style: TextStyle(color: mainColor, fontWeight: FontWeight.w600, fontSize: 16)),
        ),
      ],
    );
  }
}
