import 'package:flutter/material.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'src/color.dart';

class ProfileSettingNotification extends StatefulWidget {
  const ProfileSettingNotification({super.key});

  @override
  _ProfileSettingNotificationState createState() =>
      _ProfileSettingNotificationState();
}

class _ProfileSettingNotificationState
    extends State<ProfileSettingNotification> {
  bool isScheduleNotificationOn = true;
  bool isSoundOn = true;
  bool isVibrationOn = true;
  bool isFriendAddNotificationOn = true;
  bool isDoNotDisturbOn = true;
  DateTime doNotDisturbStartTime = DateTime(2024, 1, 1, 22, 0);
  DateTime doNotDisturbEndTime = DateTime(2024, 1, 1, 7, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.danchuYellow,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 64,
              child: Container(
                width: 400,
                height: 721,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3FFFD76E),
                      blurRadius: 30,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: _buildSettingItem(
                          '일정 알림', isScheduleNotificationOn, (value) {
                        setState(() => isScheduleNotificationOn = value);
                      }, icon: Icons.event_note),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          _buildSettingItem('소리', isSoundOn, (value) {
                            setState(() => isSoundOn = value);
                          }, hasLeadingSpace: true),
                          _buildSettingItem('진동', isVibrationOn, (value) {
                            setState(() => isVibrationOn = value);
                          }, hasLeadingSpace: true),
                        ],
                      ),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: _buildSettingItem(
                          '친구 추가 푸시 알림', isFriendAddNotificationOn, (value) {
                        setState(() => isFriendAddNotificationOn = value);
                      }, icon: Icons.person_add),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          _buildSettingItem('방해 금지 모드', isDoNotDisturbOn,
                              (value) {
                            setState(() => isDoNotDisturbOn = value);
                          }, icon: Icons.do_not_disturb_on),
                          _buildDoNotDisturbTimeSettings(),
                        ],
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

  Widget _buildDivider() {
    return Container(
      width: 400,
      height: 1,
      color: Color(0xFFB7B7B7),
    );
  }

  Widget _buildSettingItem(String title, bool value, Function(bool) onChanged,
      {IconData? icon, bool hasLeadingSpace = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.black, size: 24),
            SizedBox(width: 16),
          ] else if (hasLeadingSpace) ...[
            SizedBox(width: 40),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFFFFD66E),
          ),
        ],
      ),
    );
  }

  Widget _buildDoNotDisturbTimeSettings() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimePickerItem('방해 금지 시간 시작', doNotDisturbStartTime, (time) {
            setState(() => doNotDisturbStartTime = time);
          }),
          SizedBox(height: 8),
          _buildTimePickerItem('방해 금지 시간 끝', doNotDisturbEndTime, (time) {
            setState(() => doNotDisturbEndTime = time);
          }),
        ],
      ),
    );
  }

  Widget _buildTimePickerItem(
      String title, DateTime time, Function(DateTime) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 40),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  DateTime tempTime = time;
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      content: Container(
                        height: 200,
                        width: 300,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ScrollDateTimePicker(
                                itemExtent: 50,
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFD66E),
                                  ),
                                  inactiveStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                wheelOption: const DateTimePickerWheelOption(
                                  perspective: 0.01,
                                  diameterRatio: 1.2,
                                  squeeze: 1.0,
                                ),
                                itemBuilder: (context, pattern, text, isActive,
                                    isDisabled) {
                                  return Center(
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        fontSize: isActive ? 20 : 16,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isActive
                                            ? Color(0xFFFFD66E)
                                            : Colors.black54,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: ListWheelScrollView(
                                itemExtent: 50,
                                physics: FixedExtentScrollPhysics(),
                                children: ['AM', 'PM']
                                    .map((e) => Center(
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: (e == 'AM' &&
                                                          tempTime.hour < 12) ||
                                                      (e == 'PM' &&
                                                          tempTime.hour >= 12)
                                                  ? Color(0xFFFFD66E)
                                                  : Colors.black54,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    if (index == 0 && tempTime.hour >= 12) {
                                      tempTime = tempTime
                                          .subtract(Duration(hours: 12));
                                    } else if (index == 1 &&
                                        tempTime.hour < 12) {
                                      tempTime =
                                          tempTime.add(Duration(hours: 12));
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
                          child: Text('취소',
                              style: TextStyle(color: Colors.black54)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('확인',
                              style: TextStyle(color: Color(0xFFFFD66E))),
                          onPressed: () {
                            onChanged(tempTime);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    DateFormat('h:mm ').format(time),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    DateFormat('a  ').format(time),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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

  // Widget _buildDivider() { // 이렇게 하니까 magin에 영향을 받음.
  // 각 설정항목을 개별적으로 padding위젯으로 감싸고 divider를 column의 child로 추가하는 방식을 넣음
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           height: 1,
  //           color: Color(0xFFB7B7B7),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
