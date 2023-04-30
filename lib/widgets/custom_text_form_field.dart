import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextFormField extends StatefulWidget {
  String? Function(String?)? validator;
  final String label;
  bool? obscureText;
  TextEditingController? controller;
  void Function(String)? onFieldSubmitted;
  CustomTextFormField({
    super.key,
    required this.label,
    this.obscureText,
    this.validator,
    this.controller,
    this.onFieldSubmitted
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      obscureText: isObscure,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: widget.obscureText != null
            ? IconButton(
                // if password field
                icon: isObscure
                    ? const FaIcon(FontAwesomeIcons.eye)
                    : const FaIcon(FontAwesomeIcons.eyeSlash),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : null,
        label: Text(widget.label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
