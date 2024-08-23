import 'package:flutter/material.dart';
import '/src/color.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String pagename;

  MainAppbar({required this.pagename});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.danchuYellow,
      elevation: 0.0,
      leading: InkWell(
        onTap: () {},
        child: Image.asset('assets/White_logo.png'),
      ),
      title: Text(pagename),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () {
              Scaffold.of(context).openEndDrawer();
            },
            child: Image.asset('assets/menu.png'),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
