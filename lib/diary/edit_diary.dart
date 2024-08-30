import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/src/color.dart';
import 'diary_entry.dart';
import '/diary/danchu_list.dart';

class EditDiary extends StatefulWidget {
  final DateTime selectedDay;

  const EditDiary({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _EditDiaryState createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController _diaryController = TextEditingController();
  TextEditingController _aiController = TextEditingController(text: '분석 중...');
  String _selectedDanchu = '미정';
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _loadDiaryData();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  Future<void> _loadDiaryData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('danchu')
        .doc(formattedDate)
        .get();

    if (doc.exists) {
      var diary = doc.data() as Map<String, dynamic>;
      setState(() {
        _diaryController.text = diary['content'] ?? '';
        _aiController.text = diary['aiSummary'] ?? '분석 중...';
        _selectedDanchu = diary['danchu'] ?? '미정';
      });
    }
  }

  Future<Map<String, dynamic>> analyzeSentiment(String content) async {
    try {
      final url = Uri.parse('https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze');

      final response = await http.post(
        url,
        headers: {
          'X-NCP-APIGW-API-KEY-ID': '9wp8wipdid',
          'X-NCP-APIGW-API-KEY': 'o5vsHbrMJuBMKlrDPToDO2dBRtO5TXZqAFaGggLP',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('API error: ${response.statusCode} - ${response.body}');
        return {'error': 'API error: ${response.statusCode}'};
      }
    } catch (e) {
      print('Network error: $e');
      return {'error': 'Network error'};
    }
  }

  Future<void> _analyzeAndUpdateSummary() async {
    setState(() {
      _isAnalyzing = true;
      _aiController.text = '분석 중...';
    });

    try {
      Map<String, dynamic> result = await analyzeSentiment(_diaryController.text);

      if (result.containsKey('error')) {
        throw Exception(result['error']);
      }

      String sentiment = result['document']?['sentiment'] ?? 'unknown';
      Map<String, dynamic> confidence = result['document']?['confidence'] ?? {};

      // confidence 값을 0과 1 사이의 값으로 정규화
      double positiveScore = (confidence['positive'] ?? 0).toDouble();
      double neutralScore = (confidence['neutral'] ?? 0).toDouble();
      double negativeScore = (confidence['negative'] ?? 0).toDouble();

      double total = positiveScore + neutralScore + negativeScore;
      if (total > 0) {
        positiveScore /= total;
        neutralScore /= total;
        negativeScore /= total;
      } else {
        positiveScore = neutralScore = negativeScore = 0;
      }

      String highestSentiment = 'neutral';
      double highestScore = neutralScore;
      if (positiveScore > highestScore) {
        highestSentiment = 'positive';
        highestScore = positiveScore;
      }
      if (negativeScore > highestScore) {
        highestSentiment = 'negative';
        highestScore = negativeScore;
      }

      // 단추 선택 로직
      setState(() {
        switch (highestSentiment) {
          case 'positive':
            _selectedDanchu = '기쁨';
            break;
          case 'negative':
            _selectedDanchu = negativeScore > 0.7 ? '화남' : '슬픔'; // 부정 점수가 높으면 '화남', 아니면 '슬픔'
            break;
          case 'neutral':
            _selectedDanchu = '귀찮';
            break;
          default:
            _selectedDanchu = '미정';
        }
      });

      String message;
      switch (highestSentiment) {
        case 'positive':
          message = '오늘은 좋은 날이네요! 긍정적인 에너지가 가득한 하루였군요.';
          break;
        case 'neutral':
          message = '오늘 하루도 이렇게 지나가네요~ 평온한 하루를 보내셨군요.';
          break;
        case 'negative':
          message = '힘든 하루를 보내셨군요. 내일은 좀 더 괜찮아질 거예요.';
          break;
        default:
          message = '오늘 하루는 어떠셨나요?';
      }

      String summary = '$message\n\n'
          '감정 분석 결과:\n'
          '긍정: ${createTextGraph(positiveScore)} ${(positiveScore * 100).toStringAsFixed(1)}%\n'
          '중립: ${createTextGraph(neutralScore)} ${(neutralScore * 100).toStringAsFixed(1)}%\n'
          '부정: ${createTextGraph(negativeScore)} ${(negativeScore * 100).toStringAsFixed(1)}%';

      setState(() {
        _aiController.text = summary;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _aiController.text = '분석 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
        _isAnalyzing = false;
      });
      print('Error analyzing sentiment: $e');
    }
  }

  String createTextGraph(double percentage) {
    int filledSquares = (percentage * 10).round().clamp(0, 10);
    return '${List.filled(filledSquares, '■').join()}${List.filled(10 - filledSquares, '□').join()}';
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
        backgroundColor: AppColors.white,
        actions: [
          TextButton(
            onPressed: _isAnalyzing ? null : () => _saveDiary(context),
            child: Text('저장', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset(Danchu().getDanchu(_selectedDanchu)),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.danchuYellow,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildSectionTitle('AI 감정 분석'),
                    _buildAiSummaryBox(context),
                    SizedBox(height: 16),
                    _buildSectionTitle('일기'),
                    _buildDiaryInputBox(context),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isAnalyzing ? null : _analyzeAndUpdateSummary,
                      child: Text(_isAnalyzing ? '분석 중...' : '감정 분석하기'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: Color(0xFFFFFACD), // 텍스트 색상
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAiSummaryBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _aiController.text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDiaryInputBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _diaryController,
        maxLines: null,
        minLines: 5,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
          hintText: '오늘의 일기를 작성해주세요...',
        ),
      ),
    );
  }

  void _saveDiary(BuildContext context) {
    if (_diaryController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('danchu')
          .doc(DateFormat('yyyy-MM-dd').format(widget.selectedDay))
          .set({
        'date': widget.selectedDay,
        'content': _diaryController.text,
        'aiSummary': _aiController.text,
        'danchu': _selectedDanchu,
      }).then((_) {
        Navigator.pop(
          context,
          DiaryEntry(
            content: _diaryController.text,
            date: widget.selectedDay,
            danchu: _selectedDanchu,
          ),
        );
      }).catchError((error) {
        print("Error writing document: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일기 저장 중 오류가 발생했습니다.')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 내용을 입력해주세요.')),
      );
    }
  }
}