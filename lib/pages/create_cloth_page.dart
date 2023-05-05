import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last_assignment/app_state.dart';
import 'package:last_assignment/models/cloth.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_button.dart';
import 'package:form_validator/form_validator.dart';

class CreateClothPage extends StatefulWidget {
  const CreateClothPage({super.key});

  @override
  State<CreateClothPage> createState() => _CreateClothPageState();
}

class _CreateClothPageState extends State<CreateClothPage> {
  // form key
  final _formKey = GlobalKey<FormState>();
  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String _gender = "Male";

  List<XFile> pickedImages = [];
  Future<bool>? _isUploading;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Cloth'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
        shadowColor: Colors.transparent,
        actions: [
          FutureBuilder(
            future: _isUploading,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: "Name",
                      controller: _nameController,
                      validator: ValidationBuilder().minLength(3).build(),
                      onFieldSubmitted: (_) => _submitForm(),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      label: "Description",
                      controller: _descriptionController,
                      maxLines: 3,
                      maxCharacters: 200,
                      validator: ValidationBuilder().minLength(3).build(),
                      onFieldSubmitted: (_) => _submitForm(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // ask for price
                        Expanded(
                          child: CustomTextFormField(
                            label: "\$ Price",
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Price is required"),
                                  ),
                                );
                              }
                            },
                            onFieldSubmitted: (_) => _submitForm(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // gender selection
                        Expanded(
                          child: SizedBox(
                            height: 59,
                            child: GenderSelectionWidget(
                              onSaved: (p0) {
                                _gender = p0;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ...pickedImages.map((e) {
                    return FutureBuilder(
                        future: e.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PickedImage(
                              onClose: () {
                                setState(() {
                                  pickedImages.remove(e);
                                });
                              },
                              image: Image.memory(
                                snapshot.data!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return const SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        });
                  }).toList(),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo_rounded),
                      onPressed: () {
                        ImagePicker().pickMultiImage().then((value) {
                          pickedImages.addAll(value);
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Consumer<AppState>(builder: (context, state, _) {
                return CustomButton(
                  backgroundColor: const Color.fromRGBO(0x1e, 0x2e, 0x3d, 1),
                  text: "Create Cloth",
                  onPressed: () {
                    _submitForm();
                    setState(() {
                      _isUploading = state
                          .createCloth(
                              Cloth(
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  images: [],
                                  price:
                                      double.tryParse(_priceController.text) ??
                                          0.0,
                                  sex: _gender),
                              pickedImages)
                          .then((status) {
                        if (status) {
                          // show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cloth created successfully"),
                            ),
                          );
                          _descriptionController.clear();
                          _nameController.clear();
                          _priceController.clear();
                          pickedImages.clear();
                          setState(() {
                            
                          });
                        }
                        // failure snackbar
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cloth creation failed"),
                            ),
                          );
                        }
                        return status;
                      });
                    });
                  },
                  size: Size.fromWidth(MediaQuery.of(context).size.width),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

enum Gender { male, female }

class GenderSelectionWidget extends StatefulWidget {
  final Function(String) onSaved;
  const GenderSelectionWidget({Key? key, required this.onSaved})
      : super(key: key);

  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  Gender? _selectedGender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Gender>(
      borderRadius: BorderRadius.circular(15),
      onSaved: (value) {
        widget.onSaved(value == Gender.male ? "Male" : "Female");
      },
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: _selectedGender,
      items: const [
        DropdownMenuItem(
          value: Gender.male,
          child: Text('Male'),
        ),
        DropdownMenuItem(
          value: Gender.female,
          child: Text('Female'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
        widget.onSaved(value == Gender.male ? "Male" : "Female");
      },
    );
  }
}

class PickedImage extends StatefulWidget {
  final VoidCallback onClose;
  final Image image;
  const PickedImage({
    super.key,
    required this.onClose,
    required this.image,
  });

  @override
  State<PickedImage> createState() => _PickedImageState();
}

class _PickedImageState extends State<PickedImage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  widget.image,
                  Positioned(
                    right: -10,
                    top: -10,
                    child: IconButton(
                      onPressed: () {
                        widget.onClose();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
