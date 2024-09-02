import 'package:flutter/material.dart';
import 'profile_deleteAccount.dart';
import '../src/color.dart';
import 'profile_setting_account_resetPassward.dart'; // 오타 수정
import 'profile_page.dart';

class ProfileSettingAccount extends StatelessWidget {
  const ProfileSettingAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.danchuYellow,
        elevation: 0,
        title: Text('계정 설정', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: AppColors.danchuYellow,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
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
                child: Column(
                  children: [
                    _buildButton(context, Icons.person, '프로필', ProfilePage()),
                    _buildButton(context, Icons.lock, '비밀번호 설정',
                        ProfileSettingAccountResetPassword()),
                    _buildButton(context, Icons.exit_to_app, '탈퇴하기',
                        ProfileDeleteAccount()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, IconData icon, String text, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 38, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
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
    );
  }
}
