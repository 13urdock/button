// login.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../src/color.dart';
import '../danchu/danchu_page.dart';
import './account_signup.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DanchuPage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? '로그인에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google 로그인 중 오류 발생: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.danchuYellow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.zero,
    );
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/danchu_3Dlogo.png'),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 328,
                height: 52,
                child: ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  child: Text('로그인', style: textStyle),
                  style: buttonStyle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 328,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    UserCredential? result = await signInWithGoogle();
                    if (result != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => DanchuPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('구글 로그인에 실패했습니다. 다시 시도해주세요.')),
                      );
                    }
                  },
                  child: Text('구글로 로그인', style: textStyle),
                  style: buttonStyle,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 328,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountSignUp()),
                    );
                  },
                  child: Text('회원가입', style: textStyle),
                  style: buttonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}