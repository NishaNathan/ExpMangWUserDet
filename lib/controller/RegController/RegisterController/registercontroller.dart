import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterDetController extends GetxController {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();

  var acceptedTerms = false.obs;

  
  RxString selectedState = RxString('Select');
  RxString selectedCountry = RxString('Select');

  var isLoading = false.obs;

  RxString mobilenum = ''.obs;
  RxString email = ''.obs;

  
  String? validateAllFields() {
    if (firstNameController.text.isEmpty) {
      return "Please enter First Name";
    } else if (lastNameController.text.isEmpty) {
      return "Please enter Last Name";
    } else if (emailController.text.isEmpty) {
      return "Please select email";
    } else if (mobileNumberController.text.isEmpty) {
      return "Please enter Mobile Number";
    } else if (passwordController.text.isEmpty) {
      return "Please enter Password";
    } else if (dobController.text.isEmpty) {
      return "Please select Date of Birth";
    } else if (selectedState.value == 'Select') {
      return "Please select State";
    } else if (selectedCountry.value == 'Select') {
      return "Please select State";
    }
    return null;
  }

  
  String? validateTermsAndConditions() {
    if (!acceptedTerms.value) {
      return 'Please accept the terms and conditions';
    }
    return null;
  }

  Future<void> saveregisteruser(BuildContext context) async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await _firestore
          .collection('registeruserdetails')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'mobileNumber': mobileNumberController.text.trim(),
        'password': passwordController.text.trim(),
        'dob': dobController.text.trim(),
        'state': selectedState.value,
        'country': selectedCountry.value,
      }).then((value) {
        mobilenum.value = firstNameController.text;
        email.value = emailController.text;
        emailController.clear();
        mobileNumberController.clear();
        firstNameController.clear();
        passwordController.clear();
        lastNameController.clear();
        dobController.clear();
        selectedState.value = 'Select';
        selectedCountry.value = 'Select';
        acceptedTerms.value = false;
        isLoading.value = false;
      }).catchError((error) {
        debugPrint(error.toString());
      });
    } catch (error) {
      showDialog(
        
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepOrange),
            ),
            content: Text('Registration Failed: $error'),
            actions: [
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
