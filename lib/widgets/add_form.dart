import 'dart:io';
import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // For handling web image bytes
import 'package:provider/provider.dart'; // Import the provider
import 'package:adopt_app/providers/pets_provider.dart'; // Import the PetsProvider

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

  // Variables to hold the form data
  String _name = '';
  String _age = '';
  String _gender = '';

  // Image picker variables
  Uint8List? _imageBytes; // Store image bytes for web
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Pet Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a pet name';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Pet Age'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an age';
              }
              if (int.tryParse(value) == null) {
                return 'Age must be a number';
              }
              return null;
            },
            onSaved: (value) {
              _age = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Gender'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a gender';
              }
              if (value != 'male' && value != 'female') {
                return 'Gender must be either male or female';
              }
              return null;
            },
            onSaved: (value) {
              _gender = value!;
            },
          ),
          const SizedBox(height: 20),

          // Display CircleAvatar for image
          CircleAvatar(
            radius: 50,
            backgroundImage: _imageBytes != null
                ? MemoryImage(_imageBytes!) // Show selected image
                : const AssetImage('assets/images/default_profile.png')
                    as ImageProvider, // Default image
          ),
          const SizedBox(height: 20),

          // Image picker button
          ElevatedButton(
            onPressed: () async {
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                final bytes =
                    await pickedFile.readAsBytes(); // Read image as bytes
                setState(() {
                  _imageBytes = bytes; // Set image bytes to display
                });
              }
            },
            child: const Text('Select an Image'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Create a Pet object with the form data
                Pet newPet = Pet(
                  name: _name,
                  age: int.parse(_age),
                  gender: _gender,
                  image: "", // Image will be uploaded separately
                );

                // Call the provider to create the new pet with image bytes
                Provider.of<PetsProvider>(context, listen: false)
                    .createPetWithBytes(newPet, _imageBytes!);

                // Go back to the previous screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
