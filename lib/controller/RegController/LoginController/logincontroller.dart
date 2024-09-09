import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trainbookingapp/common/commonwidgets/dialoghelper.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordSelected = true.obs;

  RxBool isLoading = false.obs;

  RxString firstname = ''.obs;
  RxString lastname = ''.obs;
  RxString mobilenum = ''.obs;
  RxString email = ''.obs;

  Future<void> loginuser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      String errormesssage = '';
      if (emailController.text.isEmpty && passwordController.text.isEmpty) {
        errormesssage = 'Please enter Email Id and Password';
      } else if (emailController.text.isEmpty) {
        errormesssage = 'Please enter Email Id';
      } else {
        errormesssage = 'Please enter Password';
      }
      DialogHelper.showErrorDialog(title: "Error", description: errormesssage);
      return;
    }

    isLoading.value = true;
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('registeruserdetails');

      
      QuerySnapshot querySnapshot = await users
          .where('email', isEqualTo: emailController.text.trim())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs[0].data() as Map<String, dynamic>;
        if (userData['password'] == passwordController.text) {
          firstname.value = userData['firstName'] ?? '';
          lastname.value = userData['lastName'] ?? '';
          mobilenum.value = userData['mobileNumber'] ?? '';
          email.value = userData['email'] ?? '';
          emailController.clear();
          passwordController.clear();
        } else {
          DialogHelper.showErrorDialog(
              title: "Error", description: "Invalid Password");
        }
      } else {
        DialogHelper.showErrorDialog(
            title: "Error", description: "User not found");
      }
    } catch (e) {
      DialogHelper.showErrorDialog(
          title: "Error", description: "Login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
