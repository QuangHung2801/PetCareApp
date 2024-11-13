import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerProfilePage extends StatefulWidget {
  @override
  _PartnerProfilePageState createState() => _PartnerProfilePageState();
}

class _PartnerProfilePageState extends State<PartnerProfilePage> {
  bool isEditingPersonalInfo = false;
  bool isEditingServices = false;
  bool isAddingService = false;

  final TextEditingController nameController = TextEditingController(text: "Partner Name");
  final TextEditingController addressController = TextEditingController(text: "Partner Address");
  final TextEditingController phoneController = TextEditingController(text: "Partner Phone");
  final TextEditingController emailController = TextEditingController(text: "Partner Email");

  List<String> allServices = ["Service 1", "Service 2", "Service 3", "Service 4"];
  List<String> selectedServices = [];
  TextEditingController newServiceController = TextEditingController();

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear session data
    Navigator.pushReplacementNamed(context, '/LoginScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Partner Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildPersonalInfoSection(),
          SizedBox(height: 20),
          _buildServicesSection(),
          SizedBox(height: 20),
          _buildOptionsSection(context),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (isEditingPersonalInfo)
            Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone"),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isEditingPersonalInfo = false;
                        });
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditingPersonalInfo = false;
                        });
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${nameController.text}"),
                Text("Address: ${addressController.text}"),
                Text("Phone: ${phoneController.text}"),
                Text("Email: ${emailController.text}"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isEditingPersonalInfo = true;
                    });
                  },
                  child: Text("Edit Personal Information"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Registered Services",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          if (isEditingServices)
            Column(
              children: allServices.map((service) {
                return CheckboxListTile(
                  title: Text(service),
                  value: selectedServices.contains(service),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedServices.add(service);
                      } else {
                        selectedServices.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
            )
          else
            Column(
              children: selectedServices.map((service) => Text(service)).toList(),
            ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditingServices = !isEditingServices;
              });
            },
            child: Text(isEditingServices ? "Save Services" : "Edit Services"),
          ),
          if (isEditingServices)
            Column(
              children: [
                SizedBox(height: 20),
                if (isAddingService)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newServiceController,
                          decoration: InputDecoration(
                            labelText: "Add New Service",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          setState(() {
                            if (newServiceController.text.isNotEmpty) {
                              allServices.add(newServiceController.text);
                              isAddingService = false;
                              newServiceController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAddingService = true;
                      });
                    },
                    child: Text("Add New Service"),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Handle contact admin
          },
          child: Text("Contact Admin"),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _logout(context); // Call the logout function
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Log Out"),
        ),
      ],
    );
  }
}
