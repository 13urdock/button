import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/color.dart';
import 'dart:async';
import 'dart:math';

class join_membership extends StatefulWidget {
  const join_membership({Key? key}) : super(key: key);

  @override
  _JoinMembershipState createState() => _JoinMembershipState();
}

class _JoinMembershipState extends State<join_membership> {
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
  User? _tempUser;

  @override
  void dispose() {
    _nicknameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600]), // 기본 라벨 색상
      floatingLabelStyle: TextStyle(color: Colors.black), // 포커스 시 라벨 색상
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
    if (_emailController.text.isEmpty) {
      setState(() {
        _statusMessage = '이메일을 입력해주세요.';
      });
      return;
    }

    try {
      // 임의의 비밀번호 생성
      String randomPassword = _generateRandomPassword();

      // 임시 회원가입
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: randomPassword,
      );

      _tempUser = userCredential.user;

      if (_tempUser != null) {
        // 이메일 인증 메일 발송
        await _tempUser!.sendEmailVerification();
        setState(() {
          _statusMessage = '인증 이메일이 전송되었습니다. 이메일을 확인해주세요.';
        });

        // 이메일 인증 상태 확인 시작
        _startCheckingEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _statusMessage = _getErrorMessage(e);
      });
    } catch (e) {
      setState(() {
        _statusMessage = '오류가 발생했습니다: $e';
      });
    }
  }

  void _startCheckingEmailVerification() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      if (_tempUser != null) {
        await _tempUser!.reload();
        _tempUser = _auth.currentUser;
        if (_tempUser!.emailVerified) {
          timer.cancel();
          setState(() {
            _isEmailVerified = true;
            _statusMessage = '이메일 인증이 완료되었습니다.';
          });
          // 임시 계정 삭제
          await _deleteTempAccount();
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _deleteTempAccount() async {
    if (_tempUser != null) {
      await _tempUser!.delete();
      _tempUser = null;
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _isEmailVerified) {
      try {
        // 실제 회원가입
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // 현재 시간을 가져옵니다
        DateTime now = DateTime.now();

        // Firestore에 사용자 정보 저장
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text,
          'nickname': _nicknameController.text,
          'id': _idController.text,
          'passwordLastChanged': _passwordController.text, // 비밀번호 설정/변경 날짜
          'createdAt': now.toIso8601String(), // 계정 생성 날짜
        });

        setState(() {
          _statusMessage = '회원가입이 완료되었습니다.';
        });

        // 잠시 대기 후 이전 화면으로 돌아가기
        await Future.delayed(Duration(seconds: 2));
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        setState(() {
          _statusMessage = _getErrorMessage(e);
        });
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

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '유효하지 않은 이메일 주소입니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'operation-not-allowed':
        return '이메일/비밀번호 계정이 비활성화되어 있습니다.';
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      default:
        return '알 수 없는 오류가 발생했습니다: ${e.message}';
    }
  }

  String _generateRandomPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    Random rnd = Random.secure();
    return List.generate(20, (index) => chars[rnd.nextInt(chars.length)])
        .join();
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
                      onPressed: _sendVerificationEmail,
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
