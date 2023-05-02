import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final List<Widget> _listItems = [
    _getListTile(
      leading: FontAwesomeIcons.circlePlus,
      title: "Create Cloth",
      onTap: () {
        context.push('/create');
      },
    ),
    _getListTile(
      leading: FontAwesomeIcons.video,
      title: "Demo Video",
      onTap: () {
        context.push('/video');
      },
    ),
    _getListTile(
      leading: FontAwesomeIcons.arrowRightFromBracket,
      title: "Logout",
      onTap: () {
        FirebaseAuth.instance
            .signOut()
            .then((value) => context.pushReplacement('/login'));
        GoogleSignIn().disconnect();
      },
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? Image.network(
                          FirebaseAuth.instance.currentUser?.photoURL ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: const Color.fromRGBO(0x1e, 0x2e, 0x3d, 0.7),
                          width: 100,
                          height: 100,
                          child: Center(
                            child: Text(
                              FirebaseAuth
                                      .instance.currentUser?.displayName?[0] ??
                                  '',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 20),
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
                // other settings below
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ListView.separated(
                      itemCount: _listItems.length,
                      itemBuilder: (BuildContext context, int index) =>
                          _listItems[index],
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile _getListTile({
    required IconData leading,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Icon(
        leading,
        color: const Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
