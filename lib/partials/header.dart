import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final Color customColor;
  final List<String> headings;
  final List<String> subheadings;

  const Header({
    super.key,
    required this.customColor,
    required this.headings,
    required this.subheadings,
  });
  final TextStyle headingStyle = const TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  final subheadingStyle = const TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: customColor,
        ),
        Positioned(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...headings.map(
                (heading) => Text(
                  heading,
                  style: headingStyle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ...subheadings.map(
                (subheading) => Text(
                  subheading,
                  style: subheadingStyle,
                ),
              ),
            ],
          ),
          bottom: 20,
          left: 20,
        ),
      ],
    );
  }
}
