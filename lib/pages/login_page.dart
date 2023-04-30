import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../partials/header.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  Color _customColor = Color.fromRGBO(0x1e, 0x2e, 0x3d, 1);
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  StreamSubscription<User?>? _listener;
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text((error as FirebaseAuthException).code.split('-').join(' ')),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _listener = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        context.pushReplacement('/');
      }
    });
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Header(
                customColor: _customColor,
                headings: [
                  'Sign in to your',
                  'Account',
                ],
                subheadings: ['Sign in to your Account'],
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _emailController,
                      label: "Email",
                      onFieldSubmitted: (value) {
                        _submitForm();
                      },
                      validator: ValidationBuilder()
                          .email("Please enter valid email address")
                          .build(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      controller: _passwordController,
                      label: "Password",
                      onFieldSubmitted: (value) {
                        _submitForm();
                      },
                      validator: ValidationBuilder()
                          .minLength(
                              6, "Password must be at least 6 characters long")
                          .build(),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              backgroundColor: _customColor,
              text: "Login",
              onPressed: () {
                _submitForm();
              },
              size: Size.fromWidth(MediaQuery.of(context).size.width - 40),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 15.0),
                      child: Divider(
                        color: _customColor,
                        height: 50,
                      )),
                ),
                Text("Or continue with"),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 20.0),
                      child: Divider(
                        color: _customColor,
                        height: 50,
                      )),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _getSocialLoginButton(
                    FontAwesomeIcons.google,
                    () async {
                      final googleUser =
                          await GoogleSignIn(forceCodeForRefreshToken: true)
                              .signIn();
                      final googleAuth = await googleUser?.authentication;
                    },
                  ),
                  _getSocialLoginButton(FontAwesomeIcons.facebook, () async {}),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      context.push('/signup');
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.amber[700],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getSocialLoginButton(IconData icon, VoidCallback onPressed) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 30,
        ),
        fixedSize: Size.fromWidth(
          MediaQuery.of(context).size.width / 2 - 30,
        ),
      ),
      onPressed: onPressed,
      child: FaIcon(
        icon,
        color: _customColor,
      ),
    );
  }
}
