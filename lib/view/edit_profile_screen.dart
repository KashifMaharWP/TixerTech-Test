import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_project/controllers/edit_profile_controller.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = Get.find<ProfileController>();
  late TextEditingController nameController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: controller.name.value);
    bioController = TextEditingController(text: controller.bio.value);
  }

  Future<void> pickImage() async {
  if (!kIsWeb) {
    // Simplified approach - request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      // If storage is denied, try photos permission (for Android 13+)
      status = await Permission.photos.request();
      if (!status.isGranted) {
        Get.snackbar("Permission Denied", "Please allow access to gallery");
        return;
      }
    }
  }

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    final bytes = await pickedFile.readAsBytes();
    controller.updateProfileImageWeb(bytes);
  }
}
  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
           
            SizedBox(
              height: 240.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://picsum.photos/800/400?random=7',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                 
                  Positioned(
                    top: 40.h,
                    left: 20.w,
                    right: 20.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 26.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Positioned(
                    left: 20.w,
                    bottom: -50.h,
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Obx(() {
                        return Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: controller.profileImageWeb.value != null
                                  ? MemoryImage(
                                      controller.profileImageWeb.value!,
                                    )
                                  : const NetworkImage(
                                          "https://picsum.photos/200",
                                        )
                                        as ImageProvider,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  
                ],
              ),
            ),
            SizedBox(height: 70.h),

            
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white38),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name",
                    style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                  ),
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      controller.updateName(value);
                    },
                  ),
                ],
              ),
            ),

            
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white38),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bio",
                    style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                  ),
                  TextField(
                    controller: bioController,
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      controller.updateBio(value);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

           
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: GestureDetector(
                onTap: () async {
                  
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "UPDATE",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
