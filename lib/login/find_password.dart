import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/color.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _statusMessage = '';
  bool _isResetLinkSent = false;

  @override
  void dispose() {
    _idController.dispose();
    _emailController.dispose();
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

  Future<void> _sendPasswordResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firestore에서 아이디와 이메일이 일치하는 사용자 확인
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('id', isEqualTo: _idController.text)
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // 아이디와 이메일이 일치하는 사용자가 있으면 비밀번호 재설정 이메일 전송
          await _auth.sendPasswordResetEmail(email: _emailController.text);
          setState(() {
            _isResetLinkSent = true;
            _statusMessage = '비밀번호 재설정 링크가 이메일로 전송되었습니다. 이메일을 확인해주세요.';
          });
        } else {
          setState(() {
            _statusMessage = '입력한 아이디와 이메일이 일치하는 계정을 찾을 수 없습니다.';
          });
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
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '유효하지 않은 이메일 주소입니다.';
      case 'user-not-found':
        return '해당 이메일로 등록된 사용자를 찾을 수 없습니다.';
      default:
        return '알 수 없는 오류가 발생했습니다: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('비밀번호 재설정하기'),
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isResetLinkSent ? null : _sendPasswordResetEmail,
                  child:
                      Text(_isResetLinkSent ? "재설정 링크 전송됨" : "비밀번호 재설정 링크 전송"),
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
                Text(_statusMessage,
                    style: TextStyle(
                        color: _isResetLinkSent ? Colors.green : Colors.red)),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
