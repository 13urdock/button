import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class STT extends StatefulWidget {
  final DateTime selectedDate;

  const STT({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _STTState createState() => _STTState();
}

class _STTState extends State<STT> {
  bool _isListening = false;
  String _text = '';
  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech recognition status: $status'),
      onError: (errorNotification) => print('Speech recognition error: $errorNotification'),
    );
    if (available) {
      print('Speech recognition initialized successfully');
    } else {
      print('Speech recognition is not available');
    }
  }

  Future<bool> _requestPermissions() async {
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      print('Microphone permission not granted');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('마이크 권한이 필요합니다.')),
      );
      return false;
    }
    print('Microphone permission granted');
    return true;
  }

  Future<void> _listen() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) return;

    if (_isListening) {
      await _stopListening();
      return;
    }

    setState(() => _isListening = true);

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      },
      localeId: 'ko-KR',
    );

    print('Listening started');
  }

  Future<void> _stopListening() async {
    if (!_isListening) return;

    setState(() => _isListening = false);
    await _speech.stop();
    await _saveTranscript();

    print('Listening stopped');
  }

  Future<void> _saveTranscript() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String dateString = DateFormat('yyyy-MM-dd').format(widget.selectedDate);

      try {
        await FirebaseFirestore.instance
            .collection('danchu')
            .doc(dateString)
            .set({
          'content': _text,
          'aiSummary': _text, // STT 결과를 AI 요약으로 사용
          'danchu': '미정', // 기본값 설정
          'date': widget.selectedDate,
        }, SetOptions(merge: true));

        print('Transcript saved successfully: $_text');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('일기가 저장되었습니다.')),
        );
        Navigator.pop(context, _text);
      } catch (e) {
        print('Error saving transcript: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
        );
      }
    } else {
      print('User not logged in');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _listen,
              child: Image.asset(_isListening
                  ? 'assets/micbutton_recording.png'
                  : 'assets/micbutton.png'),
            ),
            const SizedBox(height: 20),
            Text(
              _isListening ? '당신의 이야기를 듣고있어요' : '오늘의 일정을 이야기해보세요.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'AI가 당신의 이야기를 요약해드려요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Text(_text),
          ],
        ),
      ),
    );
  }
}