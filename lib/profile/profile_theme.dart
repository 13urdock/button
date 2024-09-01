import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/color.dart';

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
    AppColors.danchuYellow,
    AppColors.deepYellow,
    AppColors.saturdayblue,
    AppColors.sundayred,
    AppColors.white,
  ];

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedThemeIndex = prefs.getInt('selectedThemeIndex') ?? -1;
      _updateMainColor(selectedThemeIndex);
    });
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedThemeIndex', selectedThemeIndex);
  }

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

  void _updateMainColor(int index) {
    if (index == -1) {
      AppColors.setMainColor(AppColors.danchuYellow);
    } else {
      AppColors.setMainColor(themeColors[index]);
    }
    setState(() {});
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
                      color: AppColors.mainColor,
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
                              themeColors.length,
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
                                onPressed: () {
                                  _showMessage();
                                  _saveTheme();
                                },
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
              activeColor: Color(0xFF000080),
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            )
          else if (isCheckbox && checkboxIndex != null)
            Checkbox(
              value: selectedThemeIndex == checkboxIndex,
              activeColor: themeColors[checkboxIndex],
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedThemeIndex = checkboxIndex;
                    _updateMainColor(checkboxIndex);
                  } else {
                    selectedThemeIndex = -1;
                    _updateMainColor(-1);
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