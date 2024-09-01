import 'package:flutter/material.dart';

class FindIdPassword extends StatelessWidget {
  const FindIdPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow, // AppColors.danchuYellow 대신 사용
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
      backgroundColor: Colors.white, // AppColors.white 대신 사용
      appBar: AppBar(
        title: Text('계정 찾기'),
        backgroundColor: Colors.yellow, // AppColors.danchuYellow 대신 사용
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 328,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // 아이디 찾기 로직 구현
                },
                child: Text('아이디 찾기', style: textStyle),
                style: buttonStyle,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 328,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // 비밀번호 찾기 로직 구현
                },
                child: Text('비밀번호 찾기', style: textStyle),
                style: buttonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
