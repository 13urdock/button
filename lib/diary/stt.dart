//STT

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
//import 'package:permission_handler/permission_handler.dart';//권한패키지 오류....

class STT extends StatefulWidget {
  @override
  _STTState createState() => _STTState();
}

class _STTState extends State<STT> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeechAndPermission();
  }

  void _initSpeechAndPermission() async {
    //await Permission.microphone.request();
    await _speech.initialize();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
          }),
          localeId: 'ko_KR',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      Navigator.pop(context, _text);
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
              child: Image.asset('assets/mic.png'),
            ),
            SizedBox(height: 20),
            Text(
              _isListening ? '당신의 이야기를 듣고있어요' : '오늘의 일정을 이야기해보세요.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'AI가 당신의 이야기를 요약해드려요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Text(_text),
          ],
        ),
      ),
    );
  }
}
