import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Color backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;
  final String text;
  final Size size;
  const CustomButton({
    super.key,
    required this.backgroundColor,
    this.foregroundColor,
    required this.text,
    required this.onPressed,
    required this.size,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: widget.foregroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 30,
        ),
        backgroundColor: widget.backgroundColor,
        fixedSize: widget.size,
      ),
      onPressed: widget.onPressed,
      child: Text(widget.text),
    );
  }
}
