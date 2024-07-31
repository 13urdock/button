import 'package:flutter/material.dart';

class DanchuBanner extends StatefulWidget {
  final DateTime selectedDay;

  const DanchuBanner({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  _DanchuBannerState createState() => _DanchuBannerState();
}

class _DanchuBannerState extends State<DanchuBanner> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Hello ',
        style: DefaultTextStyle.of(context).style,
        children: const <TextSpan>[
          TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' world!'),
        ],
      ),
    );
  }
}
