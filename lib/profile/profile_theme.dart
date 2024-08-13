import 'package:flutter/material.dart';

class ProfileTheme extends StatefulWidget {
  const ProfileTheme({Key? key}) : super(key: key);

  @override
  _ProfileThemeState createState() => _ProfileThemeState();
}

class _ProfileThemeState extends State<ProfileTheme> {
  bool isDarkMode = false;
  int selectedThemeIndex = -1;
  String message = '';
  List<Color> themeColors = [
    Color(0xFFFFD66E), // Default yellow
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
  ];

  void _showMessage() {
    setState(() {
      message = '테마가 변경되었습니다!';
    });
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          message = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 64,
                      color: selectedThemeIndex == -1 ? themeColors[0] : themeColors[selectedThemeIndex],
                    ),
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
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              icon: Icons.dark_mode,
                              title: '다크 모드',
                              isSwitch: true,
                            ),
                            ...List.generate(
                              themeColors.length - 1,
                              (index) => _buildSettingsItem(
                                icon: Icons.palette,
                                title: '테마 ${index + 1}',
                                isCheckbox: true,
                                checkboxIndex: index,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (message.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: ElevatedButton(
                                onPressed: _showMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  minimumSize: const Size(double.infinity, 38),
                                ),
                                child: const Text(
                                  '확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    // Navigation bar widget would go here
                    // Remove this comment and add the navigation bar widget
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    bool isSwitch = false,
    bool isCheckbox = false,
    int? checkboxIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (isSwitch)
            Switch(
              value: isDarkMode,
              activeColor: Color(0xFF000080), // 남색
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            )
          else if (isCheckbox && checkboxIndex != null)
            Checkbox(
              value: selectedThemeIndex == checkboxIndex,
              activeColor: themeColors[checkboxIndex + 1],
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedThemeIndex = checkboxIndex;
                  } else {
                    selectedThemeIndex = -1;
                  }
                });
              },
            )
          else
            const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}