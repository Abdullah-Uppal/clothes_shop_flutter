import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile_page.dart';
import 'clothes_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // shared preferences
  late SharedPreferences _prefs;
  Color _customColor = Color.fromRGBO(0x1e, 0x2e, 0x3d, 1);
  final List<Widget> _pages = [
    ClothesListPage(),
    Container(
      key: UniqueKey(),
      color: Colors.pink,
      child: Center(
        child: Text('Search'),
      ),
    ),
    Container(
      key: UniqueKey(),
      color: Colors.red,
      child: Center(
        child: Text('Cart'),
      ),
    ),
    ProfilePage(),
  ];
  int _tabIndex = 0;
  int _previousTabIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _tabIndex = _prefs.getInt('tabIndex') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _padding = MediaQuery.of(context).size.width * 0.05;
    _initPrefs();
    return Material(
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _pages[_tabIndex],
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: animation.drive(Tween(
                  // begin: Offset(_previousTabIndex < _tabIndex ? 1 : -1, 0),
                  begin: Offset(0, 1),
                  end: const Offset(0, 0),
                )),
                child: child,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 20.0,
                left: _padding,
                right: _padding,
              ),
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(100),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: GNav(
                    selectedIndex: _tabIndex,
                      onTabChange: (value) {
                        print(value);
                        _previousTabIndex = _tabIndex;
                        setState(() {
                          _tabIndex = value;
                        });
                        _prefs.setInt('tabIndex', value);
                      },
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      backgroundColor: _customColor,
                      rippleColor: Colors
                          .transparent, // tab button ripple color when pressed
                      curve: Curves.easeInOut, // tab animation curves
                      duration: const Duration(
                          milliseconds: 300), // tab animation duration
                      gap: 10, // the tab button gap between icon and text
                      color: Colors.grey[300], // unselected icon color
                      activeColor: Colors.white, // selected icon and text color
                      iconSize: 24, // tab button icon size
                      // tabBackgroundColor: Colors.white
                      //     .withOpacity(0.1), // selected tab background color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 15), // navigation bar padding
                      tabs: const [
                        GButton(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          icon: FontAwesomeIcons.house,
                          text: 'Home',
                        ),
                        GButton(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          icon: FontAwesomeIcons.solidHeart,
                          text: 'Liked',
                        ),
                        GButton(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          icon: FontAwesomeIcons.cartShopping,
                          text: 'Cart',
                        ),
                        GButton(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          icon: FontAwesomeIcons.userGear,
                          text: 'Profile',
                        )
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
