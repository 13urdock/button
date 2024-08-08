import 'package:flutter/material.dart';
import 'src/color.dart';

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
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: 400,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(color: AppColors.danchuYellow),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 64,
                    right: 0,
                    bottom: 0,
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
                    ),
                  ),
                  Positioned(
                    left: 36,
                    top: 114,
                    child: Row(
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
                  ),
                  Positioned(
                    left: 35,
                    top: 173,
                    right: 35,
                    child: Row(
                      children: [
                        Icon(Icons.person_add, size: 26),
                        SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            height: 38,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: Color(0xFFB7B7B7)),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                  suffixIcon: Positioned(
                                    top: 0, 
                                    right: 0, 
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: _addFriend,
                                    ),
                                  ),
                                ),
                                onSubmitted: (_) => _addFriend(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 36,
                    top: 249,
                    child: Row(
                      children: [
                        Icon(Icons.group, size: 26),
                        SizedBox(width: 26),
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
                  ),
                  Positioned(
                    left: 36,
                    top: 250,
                    right: 36,
                    bottom: 20,
                    child: ListView.builder(
                      itemCount: friendList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
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
          if (widget.bottomWidget != null) widget.bottomWidget!,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _friendCodeController.dispose();
    super.dispose();
  }
}