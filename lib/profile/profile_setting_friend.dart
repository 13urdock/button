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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: screenWidth,
              color: AppColors.danchuYellow,
              child: Column(
                children: [
                  SizedBox(height: topPadding + 64),
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
                        padding: EdgeInsets.fromLTRB(36, 50, 36, 20),
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
                            SizedBox(height: 30),
                            Container(
                              // '단추 친구 코드' 박스의 높이를 조정하는 부분
                              // 이 값을 변경하여 박스의 세로 크기를 조절할 수 있습니다.
                              height: 43,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: Color(0xFFB7B7B7)),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    // Expanded 위젯을 사용하여 TextField가 사용 가능한 모든 너비를 차지하도록 합니다.
                                    // 이렇게 하면 텍스트 입력 시 박스의 크기가 변하지 않습니다.
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
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                        isDense: true,
                                        alignLabelWithHint: true,
                                      ),
                                      textAlignVertical: TextAlignVertical.center,
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
                            SizedBox(height: 60),
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
                            // SizedBox(height: 50), 여기 들어갈 폭을 어떻게 더 줄일지 모르겠음..  아직 고민중임 0810 이거좀제발제발고치자제발 아 거슬려 중요
                            Expanded(
                              child: ListView.builder(
                                itemCount: friendList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    // ListTile 위젯은 기본적으로 일정한 높이를 가지고 있음
                                    // 리스트 아이템 사이의 간격을 조정하려면 다음과 같은 방법을 사용할 수 있음
                                    // 1. contentPadding을 조정하여 내부 여백을 변경
                                    // 2. visualDensity를 사용하여 타일의 전체적인 크기를 조정
                                    // 3. 사용자 정의 위젯을 만들어 더 세밀한 제어
                                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                    visualDensity: VisualDensity(vertical: 0), // 값을 조정하여 간격 변경
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