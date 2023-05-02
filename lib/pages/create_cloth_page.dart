import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateClothPage extends StatefulWidget {
  const CreateClothPage({super.key});

  @override
  State<CreateClothPage> createState() => _CreateClothPageState();
}

class _CreateClothPageState extends State<CreateClothPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Cloth'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
}
