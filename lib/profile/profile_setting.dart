import 'package:flutter/material.dart';
import 'profile_setting_notificationSetting.dart';
import 'profile_setting_account.dart';
import 'profile_setting_friend.dart';
import 'src/color.dart';
import 'profile_theme.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({super.key});

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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
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
              top: 50,
              left: 20,
              child: Text(
                '설정',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildButton(context, Icons.person, '계정 설정', ProfileSettingAccount(), 120),
            _buildButton(context, Icons.notifications, '알림 설정', ProfileSettingNotification(), 180),
            _buildButton(context, Icons.people, '친구', ProfileSettingFriend(), 240),
            _buildButton(context, Icons.color_lens, '테마 설정', ProfileTheme(), 300),
            _buildButton(context, Icons.announcement, '공지', NoticePage(), 360),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String text, Widget page, double top) {
    return Positioned(
      left: 0,
      top: top,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                child: Icon(icon, size: 24, color: Colors.black),
              ),
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
      ),
    );
  }
}

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('친구')),
      body: Center(child: Text('친구 페이지')),
    );
  }
}

class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('테마 설정')),
      body: Center(child: Text('테마 설정 페이지')),
    );
  }
}

class NoticePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지')),
      body: Center(child: Text('공지 페이지')),
    );
  }
}