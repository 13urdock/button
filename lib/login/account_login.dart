import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/color.dart';
import 'find_id_password.dart';

class AccountLogIn extends StatefulWidget {
  const AccountLogIn({super.key});

  @override
  _AccountLogInState createState() => _AccountLogInState();
}

class _AccountLogInState extends State<AccountLogIn> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _statusMessage = '';

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

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _statusMessage = '로그인 중...');
      try {
        // 1. Firestore에서 입력된 ID에 해당하는 사용자 문서 찾기
        final querySnapshot = await _firestore
            .collection('users')
            .where('id', isEqualTo: _idController.text)
            .limit(1)
            .get();

        if (querySnapshot.docs.isEmpty) {
          setState(() => _statusMessage = '해당 ID로 등록된 사용자가 없습니다.');
          return;
        }

        final userDoc = querySnapshot.docs.first;
        final userEmail = userDoc.data()['email'] as String;

        // 2. 찾은 이메일로 Firebase Authentication을 사용하여 로그인
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: _passwordController.text,
        );

        // 로그인 성공 처리
        if (userCredential.user != null) {
          print('로그인 성공: ${userCredential.user!.uid}');

          // 상태 메시지 업데이트
          setState(() => _statusMessage = '로그인 성공!');

          // 잠시 대기 후 이전 화면으로 돌아가기
          await Future.delayed(Duration(seconds: 2));

          if (mounted) {
            Navigator.of(context).pop(); // 현재 화면을 종료하고 이전 화면으로 돌아갑니다.
            print('이전 화면으로 돌아가기 성공');
          } else {
            print('위젯이 더 이상 트리에 없습니다.');
          }
        }
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException: ${e.code}');
        setState(() {
          if (e.code == 'user-not-found') {
            _statusMessage = '해당 사용자를 찾을 수 없습니다.';
          } else if (e.code == 'wrong-password') {
            _statusMessage = '잘못된 비밀번호입니다.';
          } else {
            _statusMessage = '로그인 실패: ${e.message}';
          }
        });
      } catch (e) {
        print('예상치 못한 오류: $e');
        setState(() {
          _statusMessage = '로그인 중 오류가 발생했습니다.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('로그인'),
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
                  controller: _passwordController,
                  decoration: _inputDecoration("비밀번호"),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(_statusMessage, style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  child: Text("로그인하기"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: AppColors.danchuYellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(right: 32), // 오른쪽에 16픽셀의 여백을 줍니다
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FindIdPassword()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          '계정 찾기',
                          style: TextStyle(
                            color: Colors.black, // 텍스트 색상을 검은색으로 변경
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
