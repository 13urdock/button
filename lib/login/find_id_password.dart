import '../src/color.dart';
import 'package:flutter/material.dart';
import 'find_id.dart';
import 'find_password.dart';

class FindIdPassword extends StatelessWidget {
  const FindIdPassword({Key? key}) : super(key: key);

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
        title: Text('계정 찾기'),
        backgroundColor: AppColors.danchuYellow,
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
                  // 아이디 찾기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => find_Id()),
                  );
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
                  // 비밀번호 찾기 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetPassword()),
                  );
                },
                child: Text('비밀번호 재설정하기', style: textStyle),
                style: buttonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
