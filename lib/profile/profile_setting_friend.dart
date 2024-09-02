import 'package:flutter/material.dart';
import '../src/color.dart';

class ProfileSettingFriend extends StatefulWidget {
  final Widget? bottomWidget;

  const ProfileSettingFriend({Key? key, this.bottomWidget}) : super(key: key);

  @override
  _ProfileSettingFriendState createState() => _ProfileSettingFriendState();
}

class _ProfileSettingFriendState extends State<ProfileSettingFriend> {
  final TextEditingController _friendCodeController = TextEditingController();
  List<String> friendList = [];

  void _addFriend() {
    final friendCode = _friendCodeController.text.trim();
    if (friendCode.isNotEmpty) {
      if (!friendList.contains(friendCode)) {
        setState(() {
          friendList.add(friendCode);
          _friendCodeController.clear();
        });
      } else {
        _showAlreadyAddedDialog();
      }
    }
  }

  void _showAlreadyAddedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('이미 추가된 친구입니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구추가'),
        backgroundColor: AppColors.danchuYellow,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.danchuYellow,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3FFFD76E),
                            blurRadius: 30,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(36, 30, 36, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_add, size: 24),
                                SizedBox(width: 10),
                                Text(
                                  '친구 추가하기',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 43,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: Color(0xFFB7B7B7)),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _friendCodeController,
                                      decoration: InputDecoration(
                                        hintText: '단추 친구 코드',
                                        hintStyle: TextStyle(
                                          color: Color(0xFF757575),
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        isDense: true,
                                        alignLabelWithHint: true,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      onSubmitted: (_) => _addFriend(),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: _addFriend,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Icon(Icons.group, size: 26),
                                SizedBox(width: 10),
                                Text(
                                  '친구 목록',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: friendList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 16),
                                    visualDensity: VisualDensity(vertical: -4),
                                    title: Text(friendList[index]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          friendList.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.bottomWidget != null) widget.bottomWidget!,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _friendCodeController.dispose();
    super.dispose();
  }
}
