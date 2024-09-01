import 'package:flutter/material.dart';

class Danchu {
  static List<Map<String, dynamic>> danchuList = [
    {
      "danchu": "기쁨",
      "imgUrl": "assets/joy.png",
      "color": "FFC56E",
    },
    {
      "danchu": "슬픔",
      "imgUrl": "assets/sadness.png",
      "color": "6EA8FF",
    },
    {
      "danchu": "화남",
      "imgUrl": "assets/anger.png",
      "color": "FF6E6E",
    },
    {
      "danchu": "귀찮",
      "imgUrl": "assets/gloomy.png",
      "color": "A56EFF",
    },
    {
      "danchu": "미정",
      "imgUrl": "assets/blacnky.png",
      "color": "B7B7B7",
    },
  ];

  String getDanchu(String emotion) {
    for (var danchu in danchuList) {
      if (danchu["danchu"] == emotion) {
        return danchu["imgUrl"];
      }
    }
    return "assets/danchu_3Dlogo.png";
  }

  static Color getDanchuColor(String emotion) {
    for (var danchu in danchuList) {
      if (danchu["danchu"] == emotion) {
        return Color(int.parse("0xFF${danchu["color"]}"));
      }
    }
    return Color(0xFFB7B7B7);
  }
}
