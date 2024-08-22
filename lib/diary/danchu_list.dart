class Danchu {
  static List<Map<String, dynamic>> danchuList = [
    {
      "numbers": "기쁨",
      "imgUrl": "assets/joy.png",
    },
    {
      "numbers": "슬픔",
      "imgUrl": "assets/sadness.png",
    },
    {
      "numbers": "화남",
      "imgUrl": "assets/anger.png",
    },
    {
      "numbers": "우울",
      "imgUrl": "assets/sadness.png",
    },
    {
      "numbers": "귀찮",
      "imgUrl": "assets/gloomy.png",
    },
    {
      "numbers": "미정",
      "imgUrl": "assets/blacnky.png",
    },
  ];

  String getDanchu(String emotion) {
    for (var danchu in danchuList) {
      if (danchu["numbers"] == emotion) {
        return danchu["imgUrl"];
      }
    }
    return "assets/danchu_3Dlogo.png";
  }
}
