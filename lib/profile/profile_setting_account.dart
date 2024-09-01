import 'package:flutter/material.dart';
import 'profile_deleteAccount.dart';
import '../src/color.dart';
import 'profile_setting_account_resetPassward.dart';
// 각 페이지에 대한 import 문을 추가해야함. 할 예정
// import 'profile_page.dart';
// import 'password_setting_page.dart';
// import 'account_delete_page.dart';

class ProfileSettingAccount extends StatelessWidget {
  const ProfileSettingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.danchuYellow,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 100,
              child: Container(
                width: 400,
                height: 721,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
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
              left: 44,
              top: 54,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Text(
                      '프로필',                   //나중에 수정하기! 프로필이 아니고 설정이다
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    ' > 설정',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            _buildButton(context, Icons.person, '프로필', 114, ProfilePage()),
            _buildButton(context, Icons.lock, '비밀번호 설정', 182, ProfileSettingAccountResetPassward()),
            _buildButton(context, Icons.exit_to_app, '탈퇴하기', 250, ProfileDeleteAccount()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String text, double top, Widget page) {
    return Positioned(
      left: 38,
      top: top,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          width: 300,
          height: 50,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,

                child: Icon(icon, size: 24, color: Colors.black),
              ),
              SizedBox(width: 24),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 각 페이지에 대한 placeholder 클래스를 만듭니다.
// 실제 구현 시 이 부분을 별도의 파일로 분리하고 import 해야 합니다.

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필')),
      body: Center(child: Text('프로필 페이지')),
    );
  }
}

class PasswordSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('비밀번호 설정')),
      body: Center(child: Text('비밀번호 설정 페이지')),
    );
  }
}

class AccountDeletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('탈퇴하기')),
      body: Center(child: Text('계정 탈퇴 페이지')),
    );
  }
}