import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

class TimePickerItem extends StatefulWidget {
  final String title;
  final DateTime initialTime;
  final Function(DateTime) onTimeChanged;

  const TimePickerItem({
    Key? key,
    required this.title,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

  @override
  _TimePickerItemState createState() => _TimePickerItemState();
}

class _TimePickerItemState extends State<TimePickerItem> {
  late DateTime _time;

  @override
  void initState() {
    super.initState();
    _time = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 화면 크기 정보를 얻습니다.
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
      child: Row(
        children: [
          SizedBox(width: screenSize.width * 0.05),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: isSmallScreen ? 14 : 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showTimePicker,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width * 0.02),
                  child: Text(
                    DateFormat('h:mm ').format(_time),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width * 0.02),
                  child: Text(
                    DateFormat('a  ').format(_time),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker() async {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    final DateTime? result = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempTime = _time;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Container(
                height: screenSize.height * 0.3,
                width: screenSize.width * (isSmallScreen ? 0.8 : 0.5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ScrollDateTimePicker(
                        itemExtent: screenSize.height * 0.06,
                        infiniteScroll: true,
                        onChange: (DateTime newDateTime) {
                          setState(() {
                            tempTime = DateTime(
                              tempTime.year,
                              tempTime.month,
                              tempTime.day,
                              newDateTime.hour % 12 == 0
                                  ? 12
                                  : newDateTime.hour % 12,
                              newDateTime.minute,
                            );
                          });
                        },
                        dateOption: DateTimePickerOption(
                          dateFormat: DateFormat('h:mm'),
                          minDate: DateTime(2024, 1, 1, 1, 0),
                          maxDate: DateTime(2024, 1, 1, 12, 59),
                          initialDate: tempTime,
                        ),
                        style: DateTimePickerStyle(
                          activeStyle: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD66E),
                          ),
                          inactiveStyle: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.black54,
                          ),
                        ),
                        wheelOption: DateTimePickerWheelOption(
                          perspective: 0.01,
                          diameterRatio: isSmallScreen ? 1.4 : 1.2,
                          squeeze: 1.0,
                        ),
                        itemBuilder: (context, pattern, text, isActive, isDisabled) {
                          return Center(
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: isActive ? (isSmallScreen ? 18 : 20) : (isSmallScreen ? 14 : 16),
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                color: isActive ? Color(0xFFFFD66E) : Colors.black54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView(
                        itemExtent: screenSize.height * 0.06,
                        physics: FixedExtentScrollPhysics(),
                        children: ['AM', 'PM']
                            .map((e) => Center(
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: (e == 'AM' && tempTime.hour < 12) ||
                                              (e == 'PM' && tempTime.hour >= 12)
                                          ? Color(0xFFFFD66E)
                                          : Colors.black54,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            if (index == 0 && tempTime.hour >= 12) {
                              tempTime = tempTime.subtract(Duration(hours: 12));
                            } else if (index == 1 && tempTime.hour < 12) {
                              tempTime = tempTime.add(Duration(hours: 12));
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('취소', style: TextStyle(color: Colors.black54, fontSize: isSmallScreen ? 14 : 16)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('확인', style: TextStyle(color: Color(0xFFFFD66E), fontSize: isSmallScreen ? 14 : 16)),
                  onPressed: () {
                    Navigator.of(context).pop(tempTime);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _time = result;
      });
      widget.onTimeChanged(_time);
    }
  }
}