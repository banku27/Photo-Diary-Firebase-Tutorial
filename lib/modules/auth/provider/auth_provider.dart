import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_diary_firebase/common/cnt_etx.dart';
import 'package:photo_diary_firebase/data/api/auth_api.dart';
import 'package:photo_diary_firebase/data/prefs.dart';
import 'package:photo_diary_firebase/models/profile_model.dart';
import 'package:photo_diary_firebase/modules/home/views/home_view.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;

  final AuthApi _authApi;
//final authProvider = Provider.of<AuthProvider>(context,listen:false);
  ProfileModel _signUpProfileModel = ProfileModel(
    name: "",
    uid: "",
    phone: "",
    profileUrl: "",
    createdAt: DateTime.now(),
  );

  AuthProvider(this._authApi);

  ProfileModel get signUpProfileModel => _signUpProfileModel;

  void updateNameAndPhone(String name, String phoneNumber, String uid) async {
    _signUpProfileModel = _signUpProfileModel.copyWith(
      name: name,
      uid: uid,
      phone: phoneNumber,
    );
    await Prefs.setUserName(name);
    await _authApi.saveUserData(_signUpProfileModel, uid);
  }

  Future<ProfileModel> getUserData(String phoneNumber) async {
    return await _authApi.getUserData(phoneNumber);
  }

  Future<void> uploadProfileImage({
    required File imageFile,
    required String userName,
    required BuildContext context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final imageUrl =
          await _authApi.uploadProfileImage(imageFile, Prefs.getUserId!);
      _signUpProfileModel =
          _signUpProfileModel.copyWith(profileUrl: imageUrl, name: userName);

      await _authApi.saveUserData(_signUpProfileModel, Prefs.getUserId!);
      await Prefs.setProfilePhoto(imageUrl);
      // ignore: use_build_context_synchronously
      context.showSnackBar("Profile created successfully");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
    } catch (e) {
      context.showSnackBar(e.toString(), isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isUserRegistered() async {
    final uid = Prefs.getUserId;
    if (uid != null && uid.isNotEmpty) {
      final profile = await _authApi.getUserDataById(uid);
      if (profile?.profileUrl != "") {
        _signUpProfileModel = profile!;
        return true;
      }
    }
    return false;
  }
}
