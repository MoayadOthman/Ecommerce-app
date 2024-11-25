import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker for selecting images
import 'dart:io';

import 'package:last/utils/appconstant.dart'; // Import dart:io for File handling

class ProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic>? userData; // User data passed to prefill form fields

  const ProfileEditScreen({Key? key, this.userData}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
  final FirebaseStorage _storage = FirebaseStorage.instance; // Firebase Storage instance

  final _formKey = GlobalKey<FormState>(); // Form key for form validation

  late TextEditingController _usernameController; // Controller for username
  late TextEditingController _addressController; // Controller for address
  late TextEditingController _phoneController; // Controller for phone number

  File? _profileImage; // Variable to store selected profile image
  bool _isUploading = false; // Upload state indicator

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user data if available
    _usernameController = TextEditingController(text: widget.userData?['username']);
    _addressController = TextEditingController(text: widget.userData?['city']);
    _phoneController = TextEditingController(text: widget.userData?['phone']);
  }

  // Method to select an image using ImagePicker
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path); // Store selected image file
      });
    }
  }

  // Method to upload profile picture to Firebase Storage and get its URL
  Future<String?> _uploadProfileImage() async {
    if (_profileImage == null) return null;

    try {
      setState(() => _isUploading = true); // Show loading indicator

      // Create a storage reference for the user's profile picture
      String filePath = 'user_images/${_auth.currentUser!.uid}/profile.jpg';
      Reference storageRef = _storage.ref().child(filePath);

      // Upload file to Firebase Storage
      await storageRef.putFile(_profileImage!);

      // Get the download URL for the uploaded image
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    } finally {
      setState(() => _isUploading = false); // Hide loading indicator
    }
  }

  // Method to update user data in Firestore, including the profile image URL
  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          String? imageUrl = await _uploadProfileImage(); // Upload image and get URL if a new image was selected

          // Update Firestore document with new data
          await _firestore.collection('users').doc(currentUser.uid).update({
            'username': _usernameController.text,
            'city': _addressController.text,
            'phone': _phoneController.text,
            if (imageUrl != null) 'userImg': imageUrl, // Update image URL if a new one is provided
          });

          Get.snackbar('نجاح العملية', 'تم تعديل الملف الشخصي بنجاح!'); // Show success message
        }
      } catch (e) {
        print("Error updating user data: $e");
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose(); // Dispose username controller
    _addressController.dispose(); // Dispose address controller
    _phoneController.dispose(); // Dispose phone controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
          title: const Text("تعديل الملف الشخصي",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),)), // App bar title
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign form key for validation
          child:
          Stack(
            children: [
              ClipPath(
                clipper: SShapeClipper(),
                child: Container(
                  width: Get.width,
                  height: Get.height / 4,
                  color: AppConstant.appMainColor,
                ),
              ),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height:100),
        
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!) // Show selected image if any
                        : (widget.userData?['userImg'] != null
                        ? NetworkImage(widget.userData!['userImg']) // Show existing image if any
                        : null) as ImageProvider?, // Placeholder if no image available
                    child: _profileImage == null && widget.userData?['userImg'] == null
                        ? const Icon(Icons.camera_alt, size: 50) // Camera icon if no image
                        : null,
                  ),
                  const SizedBox(height: 20),
        
                  // Username field
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'اسم المستخدم'),
                        validator: (value) => value!.isEmpty ? "ادخل اسم المستخدم" : null,
                      ),
        
                      // City (address) field
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'المدينة'),
                        validator: (value) => value!.isEmpty ? "ادخل المدينة" : null,
                      ),
        
                      // Phone number field
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                        validator: (value) => value!.isEmpty ? "ادخل رقم الهاتف" : null,
                      ),
                    ],
                  ),
                ),
        
                  const SizedBox(height: 20),
        
                  // Save Changes button
                  ElevatedButton(
                    onPressed: _isUploading ? null : _updateUserData, // Disable button if uploading
                    child: _isUploading
                        ? const CircularProgressIndicator() // Show loading indicator while uploading
                        : const Text("حفظ التعديل"), // Button text
                  ),
                ],
              ),
              Positioned(
                    right:160,
                    top:210,
                  child: IconButton(onPressed:_pickImage, icon:const Icon(Icons.add_circle,color:AppConstant.appMainColor,size: 30,)))
            ],
        
          ),
        ),
      ),
    );
  }
}
class SShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 50,
    );

    path.quadraticBezierTo(
      size.width * 0.75, size.height - 100,
      size.width, size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
