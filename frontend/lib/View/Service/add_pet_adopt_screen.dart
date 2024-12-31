import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostPetPage extends StatefulWidget {
  @override
  _PostPetPageState createState() => _PostPetPageState();
}

class _PostPetPageState extends State<PostPetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  String _selectedType = 'chó'; // Default type is Dog
  File? _image; // Variable to hold the selected image
  bool _isLoading = false; // Flag to track loading state

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Method to post pet data
  Future<void> _postPet() async {
    final String apiUrl = 'http://10.0.2.2:8888/api/adoption/create';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('JSESSIONID');


    if (_nameController.text.isEmpty || _weightController.text.isEmpty || _birthDateController.text.isEmpty) {
      // Show an error if mandatory fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Prepare multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..fields['petName'] = _nameController.text
      ..fields['type'] = _selectedType
      ..fields['weight'] = _weightController.text
      ..fields['birthDate'] = _birthDateController.text
      ..fields['description'] = _descriptionController.text
      ..fields['contactInfo'] = _contactInfoController.text;

    // Upload image if it's selected
    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Ensure this matches your backend field name
        _image!.path,
      ));
    }

    // Gửi session ID trong header Cookie
    request.headers['Cookie'] = '$sessionId';
    print('Request Headers: ${request.headers}');

    try {
      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pet posted successfully!")),
        );
        _clearForm();
      } else {
        print('Response body: ${await response.stream.bytesToString()}');
        print('Failed to load pet profiles: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to post pet, please try again")),
        );
      }
    } catch (e) {
      // Handle errors during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Method to clear the form fields
  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _contactInfoController.clear();
    _weightController.clear();
    _birthDateController.clear();
    setState(() {
      _selectedType = 'chó'; // Reset to default type
      _image = null; // Clear selected image
    });
  }

  // Method to pick birth date
  Future<void> _pickBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _birthDateController.text = '${picked.toLocal()}'.split(' ')[0]; // Format as YYYY-MM-DD
    }
  }

  // Method to select image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // You can also use ImageSource.camera for taking a picture
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image file
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Pet for Adoption"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pet Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Pet Name"),
              ),
              // Pet Type (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(labelText: "Pet Type"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
                items: <String>['chó', 'mèo', 'khác']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Pet Weight
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Weight (kg)"),
              ),
              // Birth Date
              TextField(
                controller: _birthDateController,
                readOnly: true,
                onTap: () => _pickBirthDate(context),
                decoration: InputDecoration(labelText: "Birth Date"),
              ),
              // Description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              // Contact Info
              TextField(
                controller: _contactInfoController,
                decoration: InputDecoration(labelText: "Contact Info"),
              ),
              SizedBox(height: 20),
              // Select Image Button
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(_image == null ? "Select Pet Image" : "Change Pet Image"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              // Display selected image (thumbnail)
              _image != null
                  ? Image.file(_image!, height: 150, width: 150, fit: BoxFit.cover)
                  : SizedBox(),
              SizedBox(height: 20),
              // Post Button
              _isLoading
                  ? CircularProgressIndicator() // Show loading indicator while posting
                  : ElevatedButton(
                onPressed: _postPet,
                child: Text("Post Pet"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
