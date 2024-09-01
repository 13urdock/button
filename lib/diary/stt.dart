import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_speech/google_speech.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
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
  late SpeechToText speechToText;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initRecorder();
  }

  void _initSpeech() async {
    try {
      final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/psyched-era-430113-v1-7b2f431ade12.json'))}',
      );
      speechToText = SpeechToText.viaServiceAccount(serviceAccount);
      print('Speech initialized successfully');
    } catch (e) {
      print('Error initializing speech: $e');
    }
  }

  Future<void> _initRecorder() async {
    try {
      await _recorder.openRecorder();
      print('Recorder initialized successfully');
    } catch (e) {
      print('Error initializing recorder: $e');
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

  void _listen() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) return;

    if (!_isListening) {
      try {
        setState(() => _isListening = true);

        _recordingPath = await _startRecording();
        print('Recording started at: $_recordingPath');

        final config = RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          model: RecognitionModel.basic,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 16000,
          languageCode: 'ko-KR',
        );

        final audioStream = await _getAudioStream();

        final streamingConfig = StreamingRecognitionConfig(
          config: config,
          interimResults: true,
        );

        print('Starting speech recognition...');
        final responseStream = speechToText.streamingRecognize(
          streamingConfig,
          audioStream,
        );

        responseStream.listen((data) {
          print('Received speech recognition data: $data');
          for (var result in data.results) {
            setState(() {
              if (result.alternatives.isNotEmpty) {
                String transcript = result.alternatives.first.transcript;
                bool isFinal = result.isFinal;
                print(
                    'Recognized text (${isFinal ? 'final' : 'interim'}): $transcript');
                _text = transcript;
              } else {
                print('No alternatives found in the result');
              }
            });
          }
        }, onDone: () {
          print('Speech recognition completed');
          setState(() => _isListening = false);
          _stopRecording();
          _saveTranscript();
        }, onError: (error) {
          print('Error during speech recognition: $error');
          setState(() => _isListening = false);
          _stopRecording();
        });
      } catch (e) {
        print('Error in _listen method: $e');
        setState(() => _isListening = false);
        _stopRecording();
      }
    } else {
      setState(() => _isListening = false);
      _stopRecording();
    }
  }

  Future<Stream<List<int>>> _getAudioStream() async {
    if (_recordingPath == null) {
      throw Exception('Recording path is null');
    }
    final file = File(_recordingPath!);
    if (!await file.exists()) {
      throw Exception('Audio file does not exist: $_recordingPath');
    }
    print('Audio file size: ${await file.length()} bytes');
    return file.openRead();
  }

  Future<String> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';
    try {
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
        sampleRate: 16000,
        numChannels: 1,
      );
      print('Recording started successfully');
      return path;
    } catch (e) {
      print('Error starting recording: $e');
      rethrow;
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      print('Recording stopped');
    } catch (e) {
      print('Error stopping recording: $e');
    }
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
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
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
