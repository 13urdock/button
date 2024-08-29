import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/color.dart';
import 'dart:math';
import 'dart:async';

class join_membership extends StatefulWidget {
  const join_membership({Key? key}) : super(key: key);

  @override
  _Join_membership createState() => _Join_membership();
}

class _Join_membership extends State<join_membership> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _statusMessage = '';
  bool _isEmailVerified = false;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.danchuYellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  Future<void> _sendVerificationEmail() async {
    if (_emailController.text.isNotEmpty) {
      try {
        // 임시 사용자 생성
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // 이메일 인증 보내기
        await userCredential.user!.sendEmailVerification();

        setState(() {
          _statusMessage = '인증 이메일이 전송되었습니다. 이메일을 확인해주세요.';
        });

        // 이메일 인증 상태 확인
        _checkEmailVerification(userCredential.user!);
      } catch (e) {
        setState(() {
          _statusMessage = '이메일 전송 중 오류가 발생했습니다: $e';
        });
      }
    } else {
      setState(() {
        _statusMessage = '유효한 이메일 주소를 입력해주세요.';
      });
    }
  }

  Future<void> _checkEmailVerification(User user) async {
    // 주기적으로 이메일 인증 상태 확인
    Timer.periodic(Duration(seconds: 5), (timer) async {
      await user.reload();
      user = _auth.currentUser!;
      if (user.emailVerified) {
        setState(() {
          _isEmailVerified = true;
          _statusMessage = '이메일이 인증되었습니다.';
        });
        timer.cancel();
      }
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _isEmailVerified) {
      try {
        // 이미 인증된 사용자가 있으므로, 추가 정보만 업데이트
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': _emailController.text,
            'nickname': _nicknameController.text,
            'id': _idController.text,
          });

          // 비밀번호 업데이트 (필요한 경우)
          if (_passwordController.text.isNotEmpty) {
            await user.updatePassword(_passwordController.text);
          }

          setState(() {
            _statusMessage = '회원가입이 완료되었습니다.';
          });

          // 잠시 대기 후 이전 화면으로 돌아가기
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _statusMessage = '회원가입 중 오류가 발생했습니다: $e';
        });
      }
    } else if (!_isEmailVerified) {
      setState(() {
        _statusMessage = '이메일 인증을 완료해주세요.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('회원가입'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nicknameController,
                  decoration: _inputDecoration("닉네임"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _idController,
                  decoration: _inputDecoration("아이디"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '아이디를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration("비밀번호"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    if (value.length < 6) {
                      return '비밀번호는 6자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: _inputDecoration("비밀번호 확인"),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration("이메일"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요.';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return '올바른 이메일 형식이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed:
                          _isEmailVerified ? null : _sendVerificationEmail,
                      child: Text("인증하기"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danchuYellow,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(_statusMessage, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text("가입하기"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppColors.danchuYellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
