import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../src/color.dart';

class AccountLogIn extends StatefulWidget {
  const AccountLogIn({super.key});

  @override
  _AccountLogInState createState() => _AccountLogInState();
}

class _AccountLogInState extends State<AccountLogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _statusMessage = '';

  Future<void> _signUp() async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        setState(() {
          _statusMessage = '인증 이메일이 발송되었습니다. 이메일을 확인해주세요.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = e.message ?? '회원가입 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_statusMessage),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: AppColors.danchuYellow,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
