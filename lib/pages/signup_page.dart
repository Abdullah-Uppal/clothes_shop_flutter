import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../partials/header.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import 'package:form_validator/form_validator.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  Color _customColor = Color.fromRGBO(0x1e, 0x2e, 0x3d, 1);
  // controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((value) async {
      // set display name
      await value.user!.updateDisplayName(_nameController.text);
      // show simple snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created successfully!'),
        ),
      );
      context.pushReplacement('/');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text((error as FirebaseAuthException).code.split('-').join(' ')),
        ),
      );
    });
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
                  'Register',
                ],
                subheadings: ['Create your Account'],
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
                      controller: _nameController,
                      label: "Full Name",
                      onFieldSubmitted: (value) {
                        _submitForm();
                      },
                      validator: ValidationBuilder()
                          .minLength(3, "Name must be at least 3 characters")
                          .build(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      controller: _emailController,
                      label: "Email",
                      onFieldSubmitted: (value) {
                        _submitForm();
                      },
                      validator: ValidationBuilder()
                          .email("Please enter a valid email")
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
                              6, "Password must be at least 6 characters")
                          .build(),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              backgroundColor: _customColor,
              text: "Register",
              onPressed: () {
                _submitForm();
              },
              size: Size.fromWidth(MediaQuery.of(context).size.width - 40),
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              backgroundColor: Colors.white,
              foregroundColor: _customColor,
              text: "Back to Login",
              onPressed: () {
                context.pop();
              },
              size: Size.fromWidth(MediaQuery.of(context).size.width - 40),
            ),
          ],
        ),
      ),
    );
  }
}
