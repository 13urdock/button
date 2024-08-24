import 'package:flutter/material.dart';
import 'src/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import '/login/logout.dart';

class ProfileDeleteAccount extends StatelessWidget {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> _deleteAccount(BuildContext context) async {
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user != null) {
  //       await _firestore.collection('users').doc(user.uid).delete();
  //       await user.delete();
  //       Navigator.of(context).pushReplacementNamed('/login');
  //     }
  //   } catch (e) {
  //     print('계정 삭제 중 오류 발생: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('계정 삭제 중 오류가 발생했습니다.')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 400,
        height: 800,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: AppColors.danchuYellow),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 64,
              child: Container(
                width: 400,
                height: 736,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3FFFD76E),
                      blurRadius: 30,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 175,
              top: 250,
              child: Icon(
                Icons.warning_rounded,
                size: 50,
                color: Colors.black,
              ),
            ),
            Positioned(
              left: 123,
              top: 318,
              child: Text(
                '정말 탈퇴하시겠습니까?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.16,
                ),
              ),
            ),
            Positioned(
              left: 36,
              top: 372,
              child: SizedBox(
                width: 328,
                child: Text(
                  '계정을 탈퇴하시면\n이전 정보를 불러올 수 없습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    letterSpacing: 0.16,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 153,
              top: 116,
              child: Container(
                width: 94,
                height: 94,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/profile_image.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(84),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 654,
              child: GestureDetector(
                onTap: () => signOut(context),
                child: Container(
                  width: 175,
                  height: 38,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  child: Center(
                    child: Text(
                      '로그아웃하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 205,
              top: 654,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlertDialog(
                        title: '계정 탈퇴',
                        content: '정말로 계정을 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
                        onConfirm: () {
                          // _deleteAccount(context);
                        },
                        showCancelButton: true,
                      );
                    },
                  );
                },
                child: Container(
                  width: 175,
                  height: 38,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                  ),
                  child: Center(
                    child: Text(
                      '탈퇴하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.14,
                      ),
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

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final bool showCancelButton;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.showCancelButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (showCancelButton)
          TextButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        TextButton(
          child: Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
        ),
      ],
    );
  }
}
