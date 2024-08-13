
class EmailService {
  Future<String> sendVerificationCode(String email) async {
    // TODO: Implement actual email sending logic
    await Future.delayed(Duration(seconds: 1)); // Simulating network request
    return 'verification_id_12345'; // 나중에 여기에 고유한 인증 ID를 반환해야함
  }
}