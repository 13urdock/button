import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../src/color.dart';
import '/src/time_picker.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ProfileSettingNotification extends StatefulWidget {
  const ProfileSettingNotification({Key? key}) : super(key: key);

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _loadSettings();
    _initializeNotifications();
    _requestNotificationPermissions();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isScheduleNotificationOn =
            prefs.getBool('isScheduleNotificationOn') ?? true;
        isSoundOn = prefs.getBool('isSoundOn') ?? true;
        isVibrationOn = prefs.getBool('isVibrationOn') ?? true;
        isFriendAddNotificationOn =
            prefs.getBool('isFriendAddNotificationOn') ?? true;
        isDoNotDisturbOn = prefs.getBool('isDoNotDisturbOn') ?? true;
        doNotDisturbStartTime = DateTime.parse(
            prefs.getString('doNotDisturbStartTime') ??
                DateTime(2024, 1, 1, 22, 0).toIso8601String());
        doNotDisturbEndTime = DateTime.parse(
            prefs.getString('doNotDisturbEndTime') ??
                DateTime(2024, 1, 1, 7, 0).toIso8601String());
      });
    } catch (e) {
      print('Error loading settings: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isScheduleNotificationOn', isScheduleNotificationOn);
      await prefs.setBool('isSoundOn', isSoundOn);
      await prefs.setBool('isVibrationOn', isVibrationOn);
      await prefs.setBool(
          'isFriendAddNotificationOn', isFriendAddNotificationOn);
      await prefs.setBool('isDoNotDisturbOn', isDoNotDisturbOn);
      await prefs.setString(
          'doNotDisturbStartTime', doNotDisturbStartTime.toIso8601String());
      await prefs.setString(
          'doNotDisturbEndTime', doNotDisturbEndTime.toIso8601String());
    } catch (e) {
      print('Error saving settings: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          description: 'This channel is used for important notifications.',
          importance: Importance.high,
        ));
  }

  Future<void> _requestNotificationPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification permission granted');
      } else if (status.isDenied) {
        print('Notification permission denied');
        // You might want to show a dialog explaining why notifications are important
      }
    }
  }

  Future<void> _updateNotificationSettings() async {
    try {
      if (!isScheduleNotificationOn) {
        await flutterLocalNotificationsPlugin.cancelAll();
      } else {
        // Re-schedule all notifications here
        await _scheduleNotifications();
      }

      // Update sound and vibration settings
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id',
        'Your Channel Name',
        channelDescription: 'Your Channel Description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: isSoundOn,
        enableVibration: isVibrationOn,
      );
      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Apply Do Not Disturb settings
      if (isDoNotDisturbOn) {
        // Implement Do Not Disturb logic in _scheduleNotifications method
      }

      // Update system settings (this requires platform-specific implementation)
      await _updateSystemSettings();
    } catch (e) {
      print('Error updating notification settings: $e');
      // Optionally, show an error message to the user
    }
  }

  Future<void> _scheduleNotifications() async {
    // This is a placeholder for your app's notification scheduling logic
    // You should implement this based on your app's specific requirements

    // Example: Schedule a daily notification
    final now = DateTime.now();
    var scheduledNotificationDateTime =
        DateTime(now.year, now.month, now.day, 9, 0); // 9:00 AM

    if (scheduledNotificationDateTime.isBefore(now)) {
      scheduledNotificationDateTime =
          scheduledNotificationDateTime.add(Duration(days: 1));
    }

    if (!_isInDoNotDisturbPeriod(scheduledNotificationDateTime)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Daily Reminder',
        'This is your daily reminder!',
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_notification_channel',
            'Daily Notifications',
            channelDescription: 'This channel is used for daily notifications',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  bool _isInDoNotDisturbPeriod(DateTime dateTime) {
    if (!isDoNotDisturbOn) return false;

    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day,
        doNotDisturbStartTime.hour, doNotDisturbStartTime.minute);
    final endTime = DateTime(now.year, now.month, now.day,
        doNotDisturbEndTime.hour, doNotDisturbEndTime.minute);

    if (endTime.isBefore(startTime)) {
      // If end time is before start time, it means the period crosses midnight
      return dateTime.isAfter(startTime) || dateTime.isBefore(endTime);
    } else {
      return dateTime.isAfter(startTime) && dateTime.isBefore(endTime);
    }
  }

  Future<void> _updateSystemSettings() async {
    if (Platform.isAndroid) {
      const platform = MethodChannel('com.yourcompany.yourapp/system_settings');
      try {
        await platform.invokeMethod('updateSystemSettings', {
          'sound': isSoundOn,
          'vibration': isVibrationOn,
        });
      } on PlatformException catch (e) {
        print("Failed to update system settings: '${e.message}'.");
      }
    } else if (Platform.isIOS) {
      // iOS doesn't allow changing system settings programmatically
      // You might want to show a dialog instructing the user to change settings manually
    }
  }

  void _onSettingChanged(String setting, bool value) {
    setState(() {
      switch (setting) {
        case 'scheduleNotification':
          isScheduleNotificationOn = value;
          break;
        case 'sound':
          isSoundOn = value;
          break;
        case 'vibration':
          isVibrationOn = value;
          break;
        case 'friendAddNotification':
          isFriendAddNotificationOn = value;
          break;
        case 'doNotDisturb':
          isDoNotDisturbOn = value;
          break;
      }
    });
    _saveSettings();
    _updateNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알람설정', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.danchuYellow,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: AppColors.danchuYellow,
        child: Stack(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
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
                          '일정 알림',
                          isScheduleNotificationOn,
                          (value) =>
                              _onSettingChanged('scheduleNotification', value),
                          icon: Icons.event_note),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          _buildSettingItem('소리', isSoundOn,
                              (value) => _onSettingChanged('sound', value),
                              hasLeadingSpace: true),
                          _buildSettingItem('진동', isVibrationOn,
                              (value) => _onSettingChanged('vibration', value),
                              hasLeadingSpace: true),
                        ],
                      ),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: _buildSettingItem(
                          '친구 추가 푸시 알림',
                          isFriendAddNotificationOn,
                          (value) =>
                              _onSettingChanged('friendAddNotification', value),
                          icon: Icons.person_add),
                    ),
                    _buildDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          _buildSettingItem(
                              '방해 금지 모드',
                              isDoNotDisturbOn,
                              (value) =>
                                  _onSettingChanged('doNotDisturb', value),
                              icon: Icons.do_not_disturb_on),
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
          TimePicker(
            title: '방해 금지 시간 시작',
            time: doNotDisturbStartTime,
            onChanged: (time) {
              setState(() => doNotDisturbStartTime = time);
              _saveSettings();
              _updateNotificationSettings();
            },
          ),
          SizedBox(height: 8),
          TimePicker(
              title: '방해 금지 시간 끝',
              time: doNotDisturbEndTime,
              onChanged: (time) {
                setState(() => doNotDisturbEndTime = time);
                _saveSettings();
                _updateNotificationSettings();
              }),
        ],
      ),
    );
  }
}
