import 'package:http/http.dart' as http;
import 'dart:convert';

class AISentimentAnalyzer {
  static const String _apiUrl =
      'https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze';
  static const String _apiKeyId = '9wp8wipdid';
  static const String _apiKey = 'o5vsHbrMJuBMKlrDPToDO2dBRtO5TXZqAFaGggLP';

  static Future<Map<String, dynamic>> analyzeSentiment(String content) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'X-NCP-APIGW-API-KEY-ID': _apiKeyId,
          'X-NCP-APIGW-API-KEY': _apiKey,
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

  static String determineEmotionDanchu(Map<String, dynamic> sentimentResult) {
    String sentiment = sentimentResult['document']?['sentiment'] ?? 'unknown';
    Map<String, dynamic> confidence =
        sentimentResult['document']?['confidence'] ?? {};

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

    switch (highestSentiment) {
      case 'positive':
        return '기쁨';
      case 'negative':
        return negativeScore > 0.7 ? '화남' : '슬픔';
      case 'neutral':
        return '귀찮';
      default:
        return '미정';
    }
  }

  static String createSummary(Map<String, dynamic> sentimentResult) {
    String sentiment = sentimentResult['document']?['sentiment'] ?? 'unknown';
    Map<String, dynamic> confidence =
        sentimentResult['document']?['confidence'] ?? {};

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

    String message;
    switch (sentiment) {
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

    return '$message\n\n'
        '감정 분석 결과:\n'
        '긍정: ${_createTextGraph(positiveScore)} ${(positiveScore * 100).toStringAsFixed(1)}%\n'
        '중립: ${_createTextGraph(neutralScore)} ${(neutralScore * 100).toStringAsFixed(1)}%\n'
        '부정: ${_createTextGraph(negativeScore)} ${(negativeScore * 100).toStringAsFixed(1)}%';
  }

  static String _createTextGraph(double percentage) {
    int filledSquares = (percentage * 10).round().clamp(0, 10);
    return '${List.filled(filledSquares, '■').join()}${List.filled(10 - filledSquares, '□').join()}';
  }
}
