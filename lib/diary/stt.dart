import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

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
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initRecorder();
  }

  void _initSpeech() async {
    final serviceAccount = ServiceAccount.fromString(
      '${(await rootBundle.loadString('assets/psyched-era-430113-v1-7b2f431ade12.json'))}',
    );
    speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<bool> _requestPermissions() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('마이크 권한이 필요합니다.')),
      );
      return false;
    }
    return true;
  }

  void _listen() async {
    final hasPermission = await _requestPermissions();
    if (!hasPermission) return;

    if (!_isListening) {
      setState(() => _isListening = true);
      
      // Start recording
      _recordingPath = await _startRecording();
      
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

      final responseStream = speechToText.streamingRecognize(
        streamingConfig,
        audioStream,
      );

      responseStream.listen((data) {
        setState(() {
          _text = data.results
              .map((e) => e.alternatives.first.transcript)
              .join('\n');
        });
      }, onDone: () {
        setState(() => _isListening = false);
        _stopRecording();
        _uploadAudioAndSaveTranscript();
      });
    } else {
      setState(() => _isListening = false);
      _stopRecording();
    }
  }

  Future<String> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: path, codec: Codec.aacADTS);
    return path;
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
  }

  Future<Stream<List<int>>> _getAudioStream() async {
    if (_recordingPath == null) {
      throw Exception('Recording path is null');
    }
    return File(_recordingPath!).openRead();
  }

  Future<void> _uploadAudioAndSaveTranscript() async {
    if (_auth.currentUser != null && _recordingPath != null) {
      String userId = _auth.currentUser!.uid;
      String dateString = "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";
      
      // Upload audio file to Firebase Storage
      final audioFile = File(_recordingPath!);
      final audioRef = _storage.ref('audio/$userId/$dateString.aac');
      await audioRef.putFile(audioFile);

      // Save transcript to Firebase Realtime Database
      await _database.child('diaries').child(userId).child(dateString).set({
        'content': _text,
        'audioUrl': await audioRef.getDownloadURL(),
        'timestamp': ServerValue.timestamp,
      });

      Navigator.pop(context, _text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요하거나 녹음에 실패했습니다.')),
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
              child: Image.asset('assets/micbutton.png'),
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