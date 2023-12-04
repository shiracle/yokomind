import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:yoko_mind/screens/contact/contact.dart';
import 'package:yoko_mind/screens/student/handtohand/hand_to_hand.dart';
import 'package:yoko_mind/screens/student/home/home.dart';
import 'package:yoko_mind/screens/student/notebook/notebook.dart';
import 'package:yoko_mind/theme/color.dart';

import 'everyday/everyday.dart';

class StudentView extends StatefulWidget {
  final token;
  const StudentView(this.token, {super.key});
  static const route = "/student_home";

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    HandToHandView(),
    NotebookStudent(),
    NestedTabBar(),
    Contact()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   backgroundColor: switchColorBar(context, _selectedIndex),
      //   // actions: switchActionButton(context, _selectedIndex),
      //   title: switchTitle(context, _selectedIndex),
      // ),
      bottomNavigationBar: StyleProvider(
        style: Style(size: size.height * 0.014),
        child: ConvexAppBar(
          color: theme.colorScheme.primary,
          activeColor: theme.colorScheme.primary,
          backgroundColor: AppColor.outLine,
          style: TabStyle.react,
          initialActiveIndex: 0,
          height: 70,
          top: -15,
          items: [
            const TabItem(
              icon: Icons.home,
              title: 'Нүүр\n    ',
            ),
            TabItem(
              icon: Image.asset("assets/family.png"),
              title: 'Гараас \n  гарт',
            ),
            TabItem(
              icon: Image.asset("assets/Vector.png"),
              title: 'Харилцах \n  дэвтэр',
            ),
            TabItem(
              icon: Icons.event,
              title: ' Өдөр \nтутам',
            ),
            TabItem(
              icon: Image.asset("assets/phone.png"),
              title: ' Холбоо \n  барих',
            ),
          ],
          onTap: (int i) => _onItemTapped(i),
        ),
      ),
      backgroundColor: switchColorBg(context, _selectedIndex),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Color switchColorBg(BuildContext context, int index) {
    ThemeData theme = Theme.of(context);
    switch (index) {
      case 1:
        return AppColor.outLine;
      default:
        return theme.colorScheme.primary;
    }
  }

  List<Widget>? switchActionButton(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;

    switch (index) {
      case 2:
        return [
          Container(
            alignment: Alignment.centerLeft,
            width: size.width * .2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.date_range_outlined,
                  size: 25,
                  color: AppColor.outLine,
                ),
                Text(
                  'Огноо',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * .018,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
          )
        ];
      default:
        return null;
    }
  }

  Widget? switchTitle(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    switch (index) {
      case 2:
        return Padding(
          padding: EdgeInsets.only(left: size.width * .08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015, horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 1,
                    color: AppColor.outLine,
                  ),
                ),
                child: Text(
                  'Харилцах дэвтэр',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * .018,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }

  Color switchColorBar(BuildContext context, int index) {
    ThemeData theme = Theme.of(context);
    switch (index) {
      case 1:
        return theme.colorScheme.primary;
      default:
        return Colors.transparent;
    }
  }
}

class Style extends StyleHook {
  double size;
  Style({required this.size});

  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 30;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      fontSize: size,
      color: color,
      leadingDistribution: TextLeadingDistribution.even,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.visible,
      height: 0,
    );
  }
}
