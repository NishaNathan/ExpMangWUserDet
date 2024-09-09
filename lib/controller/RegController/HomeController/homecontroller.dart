import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:trainbookingapp/model/RegisterModel/HomeModel/UserDetModel.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<UserModel> usersList = <UserModel>[].obs;

  RxBool isError = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isError.value = false;
      errorMessage.value = '';

      QuerySnapshot snapshot =
          await _firestore.collection('registeruserdetails').get();
      if (snapshot.docs.isNotEmpty) {
        usersList.value = snapshot.docs.map((doc) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      } else {
        isError.value = true;
        errorMessage.value = "No users found in the database.";
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = "Failed to fetch user details: $e";
    }
  }
}
