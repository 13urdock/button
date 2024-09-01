import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../src/color.dart';
import 'account_login.dart';
import 'join_membership.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

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
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/danchu_3Dlogo.png'),
            const SizedBox(height: 32),
            Container(
              width: 328,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  UserCredential? result = await signInWithGoogle();
                  if (result != null) {
                    print('로그인 성공: ${result.user?.displayName}');
                  } else {
                    print('로그인 실패');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해주세요.')),
                    );
                  }
                },
                child: Text('간편로그인', style: textStyle),
                style: buttonStyle,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 324,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountLogIn()),
                  );
                },
                child: Text('로그인', style: textStyle),
                style: buttonStyle,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(right: 32), // 오른쪽에 16픽셀의 여백을 줍니다
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => join_membership()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('회원가입', style: textStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
