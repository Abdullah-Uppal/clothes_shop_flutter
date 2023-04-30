import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Profile", style: Theme.of(context).textTheme.bodyLarge),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              "No Name",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser?.email ??
                              "No Email",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // logout button
                        CustomButton(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          text: "Logout",
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            context.pushReplacement('/login');
                          },
                          size: Size.fromWidth(
                              MediaQuery.of(context).size.width * 0.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      )),
    );
  }
}
