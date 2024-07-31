import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFFED049),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('닉네임 :'),
                      Text('모은 단추 갯수 :'),
                      Text('달성한 목표 :'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildButton(context, '프로필 설정', ProfileSettingsPage()),
              _buildButton(context, '테마 설정', ThemeSettingsPage()),
              _buildButton(context, '모은 단추 확인하기', CollectedButtonsPage()),
              _buildButton(context, '개발자에게 문의하기', ContactDeveloperPage()),
              _buildButton(context, '계정 탈퇴하기', AccountDeletePage(), isLastButton: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page, {bool isLastButton = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          child: Text(text),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: isLastButton ? Colors.blue : Color(0xFFFED049),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

// 각 페이지에 대한 플레이스홀더 클래스
class ProfileSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 설정')),
      body: Center(child: Text('프로필 설정 페이지')),
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

class CollectedButtonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모은 단추 확인하기')),
      body: Center(child: Text('모은 단추 확인 페이지')),
    );
  }
}

class ContactDeveloperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('개발자에게 문의하기')),
      body: Center(child: Text('개발자 문의 페이지')),
    );
  }
}

class AccountDeletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('계정 탈퇴하기')),
      body: Center(child: Text('계정 탈퇴 페이지')),
    );
  }
}