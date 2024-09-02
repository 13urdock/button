import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum RecurrenceType { Daily, Weekly, Monthly }

class RoutineWidget extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(List<DateTime>) onRoutineSet;

  RoutineWidget({
    Key? key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onRoutineSet,
  }) : super(key: key);

  @override
  _RoutineWidgetState createState() => _RoutineWidgetState();
}

class _RoutineWidgetState extends State<RoutineWidget> {
  late DateTime _startDate;
  late DateTime _endDate;
  List<String> _selectedDays = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  RecurrenceType _recurrenceType = RecurrenceType.Weekly;
  int _monthlyDay = 1;

  final List<String> _daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDatePicker(
            '시작 날짜', _startDate, (date) => setState(() => _startDate = date)),
        SizedBox(height: screenSize.height * 0.02),
        _buildDatePicker(
            '종료 날짜', _endDate, (date) => setState(() => _endDate = date)),
        SizedBox(height: screenSize.height * 0.02),
        _buildRecurrenceTypePicker(),
        SizedBox(height: screenSize.height * 0.02),
        if (_recurrenceType == RecurrenceType.Weekly) _buildDaySelector(),
        if (_recurrenceType == RecurrenceType.Monthly)
          _buildMonthlyRecurrencePicker(),
        SizedBox(height: screenSize.height * 0.02),
        _buildTimePicker(),
      ],
    );
  }

  Widget _buildRecurrenceTypePicker() {
    return DropdownButton<RecurrenceType>(
      value: _recurrenceType,
      onChanged: (RecurrenceType? newValue) {
        setState(() {
          _recurrenceType = newValue!;
        });
      },
      items: RecurrenceType.values
          .map<DropdownMenuItem<RecurrenceType>>((RecurrenceType value) {
        return DropdownMenuItem<RecurrenceType>(
          value: value,
          child: Text(_getRecurrenceTypeString(value)),
        );
      }).toList(),
    );
  }

  String _getRecurrenceTypeString(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.Daily:
        return '매일';
      case RecurrenceType.Weekly:
        return '매주';
      case RecurrenceType.Monthly:
        return '매월';
    }
  }

  Widget _buildDaySelector() {
    return Wrap(
      spacing: 8.0,
      children: _daysOfWeek.map((day) {
        return ChoiceChip(
          label: Text(day),
          selected: _selectedDays.contains(day),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedDays.add(day);
              } else {
                _selectedDays.remove(day);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildMonthlyRecurrencePicker() {
    return Row(
      children: [
        Text('매월 '),
        SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _monthlyDay = int.tryParse(value) ?? 1;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Text(' 일'),
      ],
    );
  }

  Widget _buildDatePicker(
      String label, DateTime date, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () => _selectDate(context, date, onDateSelected),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${date.year}-${date.month}-${date.day}'),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '시간',
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${_selectedTime.format(context)}'),
            Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveRoutine() {
    List<DateTime> routineDates = [];
    DateTime current = _startDate;

    while (current.isBefore(_endDate) || current.isAtSameMomentAs(_endDate)) {
      bool shouldAdd = false;

      switch (_recurrenceType) {
        case RecurrenceType.Daily:
          shouldAdd = true; // 매일 추가
          break;
        case RecurrenceType.Weekly:
          shouldAdd = _selectedDays.contains(_daysOfWeek[current.weekday - 1]);
          break;
        case RecurrenceType.Monthly:
          shouldAdd = (current.day == _monthlyDay);
          break;
      }

      if (shouldAdd) {
        routineDates.add(DateTime(
          current.year,
          current.month,
          current.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ));
      }

      current = current.add(Duration(days: 1));
    }

    if (routineDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('루틴 날짜를 선택해주세요.')),
      );
    }
  }
}
