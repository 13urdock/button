import 'package:danchu/src/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar/calendar_style.dart';


class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailValid = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    setState(() {
      _isEmailValid = emailRegExp.hasMatch(_emailController.text);
    });
  }

  bool _validateInputs() {
    if (_nicknameController.text.isEmpty) {
      _showSnackBar('닉네임을 입력해주세요.');
      return false;
    }
    
    if (!_isEmailValid) {
      _showSnackBar('유효한 이메일 주소를 입력해주세요.');
      return false;
    }
    
    if (_messageController.text.isEmpty) {
      _showSnackBar('메시지를 입력해주세요.');
      return false;
    }
    
    return true;
  }

  Future<void> _sendDataToServer() async {
    final url = Uri.parse('https://your-api-endpoint.com/contact');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nickname': _nicknameController.text,
        'email': _emailController.text,
        'message': _messageController.text,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to submit contact form');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _sendDataToServer();
        _showSnackBar('문의가 성공적으로 제출되었습니다.');
        _nicknameController.clear();
        _emailController.clear();
        _messageController.clear();
      } catch (e) {
        _showErrorDialog('문의 제출 중 오류가 발생했습니다: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.danchuYellow,  // 여기에 배경색을 지정합니다.
      appBar: AppBar(
        title: Text('문의화면'),
        backgroundColor: AppColors.danchuYellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 80),  // 상단 여백
              Container(
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3FFFD76E),
                      blurRadius: 30,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('닉네임', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Email', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        errorText: _isEmailValid ? null : "유효하지 않은 이메일입니다.",
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Message', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('제출'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Colors.black,
                              minimumSize: Size(260, 38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}