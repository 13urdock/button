import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../src/color.dart';

class find_Id extends StatefulWidget {
  const find_Id({Key? key}) : super(key: key);

  @override
  _FindIdState createState() => _FindIdState();
}

class _FindIdState extends State<find_Id> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String _statusMessage = '';
  String _foundId = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _findId() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firestore에서 입력된 이메일로 사용자 검색
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // 사용자를 찾았을 경우
          var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
          String id = userDoc['id'] ?? userDoc['Id'] ?? userDoc['ID'] ?? '';
          if (id.isNotEmpty) {
            setState(() {
              _foundId = id;
              _statusMessage = '귀하의 아이디는 $id 입니다.';
            });
          } else {
            setState(() {
              _statusMessage = '사용자 정보에서 아이디를 찾을 수 없습니다.';
            });
          }
        } else {
          // 사용자를 찾지 못했을 경우
          setState(() {
            _statusMessage = '입력하신 이메일로 등록된 계정이 없습니다.';
          });
        }
      } catch (e) {
        setState(() {
          _statusMessage = '오류가 발생했습니다: $e';
        });
      }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('아이디 찾기'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 328,
                    height: 52,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: '이메일',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: 328,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _findId,
                      child: Text('아이디 찾기', style: textStyle),
                      style: buttonStyle,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(_statusMessage, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
