import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_diary_firebase/common/cnt_etx.dart';
import 'package:photo_diary_firebase/constants/app_assets.dart';
import 'package:photo_diary_firebase/constants/app_colors.dart';
import 'package:photo_diary_firebase/constants/custom_button.dart';
import 'package:photo_diary_firebase/constants/height_spacer.dart';
import 'package:photo_diary_firebase/modules/auth/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  File? _imageFile;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void deleteImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void validateAndProceed() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        context.showSnackBar("Please upload a profile picture.", isError: true);
        pickImage();
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.uploadProfileImage(
          imageFile: _imageFile!,
          userName: nameController.text,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile?.path ?? ""))
                      : const NetworkImage(
                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                ),
                _imageFile == null
                    ? Positioned(
                        right: 40,
                        bottom: 20,
                        child: InkWell(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              color: AppColor.kPrimaryColor,
                              image: DecorationImage(
                                image: AssetImage(
                                  AppAssets.cameraIcon,
                                ),
                                scale: 4,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        right: 20,
                        top: 10,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: AppColor.kPrimaryColor,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),
            const HeightSpacer(height: 20),
            const Text("Your Name"),
            const HeightSpacer(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }

                return null;
              },
            ),
            const HeightSpacer(height: 20),
            CustomButton(
              text: 'Submit',
              color: AppColor.kPrimaryColor,
              onTap: validateAndProceed,
            )
          ],
        ),
      ),
    ));
  }
}
