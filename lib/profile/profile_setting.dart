import 'package:flutter/material.dart';
import 'profile_setting_notificationSetting.dart';
import 'profile_setting_account.dart';
import 'profile_setting_friend.dart';
import '../src/color.dart';
import 'profile_theme.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.danchuYellow,
        title: Text('설정', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Container(
        color: AppColors.danchuYellow,
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3FFFD76E),
                      blurRadius: 30,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: ListView(
                  children: [
                    _buildButton(context, Icons.person, '계정 설정',
                        ProfileSettingAccount()),
                    _buildButton(context, Icons.notifications, '알림 설정',
                        ProfileSettingNotification()),
                    _buildButton(
                        context, Icons.people, '친구', ProfileSettingFriend()),
                    _buildButton(
                        context, Icons.color_lens, '테마 설정', ProfileTheme()),
                    _buildButton(
                        context, Icons.announcement, '공지', NoticePage()),
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
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Center(child: Text('친구 페이지')),
    );
  }
}

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테마 설정'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Center(child: Text('테마 설정 페이지')),
    );
  }
}

class NoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: Center(child: Text('공지 페이지')),
    );
  }
}
