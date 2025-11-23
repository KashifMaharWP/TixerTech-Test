import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = "Kashif".obs;
  var username = "@kashif".obs;
  var bio = "Flutter Developer".obs;
   Rx<Uint8List?> profileImageWeb = Rx<Uint8List?>(null);

 

  void updateName(String value) => name.value = value;
  void updateBio(String value) => bio.value = value;
   void updateProfileImageWeb(Uint8List imageBytes) {
    profileImageWeb.value = imageBytes;
  }
}

