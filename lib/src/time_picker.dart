import 'package:flutter/material.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:danchu/src/color.dart';

class TimePicker extends StatelessWidget {
  final String title;
  final DateTime time;
  final Function(DateTime) onChanged;

  const TimePicker({
    Key? key,
    required this.title,
    required this.time,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showTimePicker(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFFF5F5F5),
              ),
              child: Text(
                DateFormat('HH:mm').format(time),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime tempTime = time;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              content: Container(
                height: 200,
                width: 300,
                child: ScrollDateTimePicker(
                  itemExtent: 50,
                  infiniteScroll: true,
                  onChange: (DateTime newDateTime) {
                    setState(() {
                      tempTime = newDateTime;
                    });
                  },
                  dateOption: DateTimePickerOption(
                    dateFormat: DateFormat('HH:mm'),
                    minDate: DateTime(2024, 1, 1, 0, 0),
                    maxDate: DateTime(2024, 1, 1, 23, 59),
                    initialDate: tempTime,
                  ),
                  style: DateTimePickerStyle(
                    activeStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danchuYellow,
                    ),
                    inactiveStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  wheelOption: const DateTimePickerWheelOption(
                    perspective: 0.01,
                    diameterRatio: 1.2,
                    squeeze: 1.0,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('취소', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('확인', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    onChanged(tempTime);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
