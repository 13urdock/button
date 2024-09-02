import 'package:flutter/material.dart';
import '/login/logout.dart';
import '../src/color.dart';
import 'profile_contact.dart';
import 'profile_setting.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.danchuYellow, // 배경색 설정
        child: Column(
          children: [
            SizedBox(height: 98),
            // 프로필 이미지
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3FDDA000),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
                child: Icon(Icons.person, size: 80, color: Colors.grey),
              ),
            ),
            SizedBox(height: 38),
            // 닉네임 텍스트
            Text(
              '닉네임',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            // 하단 흰색 컨테이너
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
                      color: Color(0xFFBDBDBD),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      SizedBox(height: 20), // 상단 여백 추가
                      _buildButton(
                          context, Icons.settings, '설정', ProfileSetting()), //완료

                      // 나중에 버전 업데이트 때 추가 구현 및 수정 필요함

                      // SizedBox(height: 25), // 버튼 사이 간격
                      // _buildButton(
                      //     context,
                      //     Icons.settings_accessibility_outlined,
                      //     '모은 단추 확인하기',
                      //     ProfileSettingAccount()), //현 계정 세팅 페이지

                      SizedBox(height: 25), // 버튼 사이 간격
                      _buildButton(context, Icons.contact_support, '개발자에게 문의하기',
                          ProfileContact()),
                      SizedBox(height: 25), // 버튼 사이 간격
                      _buildButton(context, Icons.logout, '로그아웃', LogoutPage()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 위젯 생성 함수
  Widget _buildButton(
      BuildContext context, IconData icon, String text, Widget page) {
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Ink(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(width: 30), // 아이콘 왼쪽 여백
              Container(
                width: 24,
                height: 24,
                child: Icon(icon, size: 24, color: Colors.black),
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
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

class CollectedButtonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모은 단추 확인하기')),
      body: Center(child: Text('모은 단추 확인 페이지')),
    );
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 페이지가 로드되자마자 로그아웃 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      signOut(context);
    });

    // 로그아웃 중임을 나타내는 간단한 화면 표시
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('로그아웃 중... 잠시만 기다려주세요'),
          ],
        ),
      ),
    );
  }
}
