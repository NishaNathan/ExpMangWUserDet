import 'package:get/get.dart';
import 'package:trainbookingapp/common/network/baseclient.dart';
import 'dart:convert';

import 'package:trainbookingapp/model/RegisterModel/GalleryModel/GalleryDetModel.dart';

class GalleryController extends GetxController {
  var photos = <GalleryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
  }

  void fetchPhotos() async {
    try {
      isLoading(true);
      var response = await BaseClient()
          .get('https://api.slingacademy.com/v1/sample-data/photos');
      if (response != null) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        var photosList = jsonData['photos'] as List<dynamic>;
        photos.value = photosList
            .map((item) => GalleryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error fetching photos: $e');
    } finally {
      isLoading(false);
    }
  }
}
