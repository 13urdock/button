import 'package:flutter/material.dart';
import 'authService.dart';
import 'emailService.dart';

class ProfileSettingAccountResetPassward extends StatefulWidget {
  const ProfileSettingAccountResetPassward({Key? key}) : super(key: key);

  @override
  _ProfileSettingAccountResetPasswardState createState() => _ProfileSettingAccountResetPasswardState();
}

class _ProfileSettingAccountResetPasswardState extends State<ProfileSettingAccountResetPassward> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  final AuthService _authService = AuthService();
  final EmailService _emailService = EmailService();

  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 66,
              color: Color(0xFFFFD66E),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3FFFD76E),
                      blurRadius: 30,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Container(
                            width: 94,
                            height: 94,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("asset/danchu_3Dlogo.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          _buildTextField("Email", _emailController),
                          SizedBox(height: 20),
                          _buildTextField("비밀번호 변경", _passwordController, isPassword: true),
                          SizedBox(height: 20),
                          _buildTextField("비밀번호 변경 확인", _confirmPasswordController, isPassword: true),
                          SizedBox(height: 20),
                          _buildTextField("인증번호", _verificationCodeController),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildButton("인증번호 받기", onPressed: _sendVerificationCode),
                              _buildButton("인증번호 확인", onPressed: _verifyCode),
                            ],
                          ),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _resetPassword,
                              child: Text("확인"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // TODO: Add navigation bar here
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: '내용',
            hintStyle: TextStyle(color: Color(0xFF757575)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: Color(0xFFB7B7B7)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '내용을 입력해주세요!';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildButton(String text, {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, backgroundColor: Color(0xFFD9D9D9),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일을 입력해주세요')),
      );
      return;
    }
    try {
      _verificationId = await _emailService.sendVerificationCode(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호가 전송되었습니다')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호 전송에 실패했습니다')),
      );
    }
  }

  void _verifyCode() async {
    if (_verificationId == null || _verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호를 입력해주세요')),
      );
      return;
    }
    bool isValid = await _authService.verifyCode(_verificationId!, _verificationCodeController.text);
    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증이 완료되었습니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('잘못된 인증번호입니다')),
      );
    }
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
        );
        return;
      }
      try {
        await _authService.resetPassword(_emailController.text, _passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다')),
        );
        // TODO: Navigate to login page or home page
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('비밀번호 변경에 실패했습니다')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}