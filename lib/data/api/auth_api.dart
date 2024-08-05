import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_diary_firebase/models/profile_model.dart';

abstract class IAuthApi {
  Future<ProfileModel> saveUserData(ProfileModel profile, String uid);
  Future<String> uploadProfileImage(File imageFile, String uid);
  Future<ProfileModel> getUserData(String phone);
}

class AuthApi extends IAuthApi {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthApi(
      {required FirebaseStorage storage, required FirebaseFirestore firestore})
      : _firestore = firestore,
        _storage = storage;

  @override
  Future<ProfileModel> saveUserData(ProfileModel profile, String uid) async {
    try {
      await _firestore.collection("users").doc(uid).set(profile.toMap());
      return profile;
    } catch (e) {
      print("Error saving user data: $e");

      throw Exception("Failed to save user data: $e");
    }
  }

  @override
  Future<ProfileModel> getUserData(String phone) async {
    try {
      final userDoc = await _firestore
          .collection("users")
          .where('phone', isEqualTo: phone)
          .get();

      if (userDoc.docs.isEmpty) {
        throw Exception("User not found! Sign up First.");
      }
      return ProfileModel.fromMap(
        userDoc.docs.first.data(),
      );
    } catch (e) {
      print("Failed to retrieve user data: $e");
      throw Exception("Failed to retrieve user data: $e");
    }
  }

  @override
  Future<ProfileModel?> getUserDataById(String uid) async {
    try {
      if (uid.isEmpty) {
        return null;
      }
      final userDoc = await _firestore.collection("users").doc(uid).get();

      if (!userDoc.exists) {
        throw Exception("User not found! Sign up first.");
      }
      return ProfileModel.fromMap(userDoc.data()!);
    } catch (e) {
      print("Failed to retrieve user data by uid: $e");
      throw Exception("Failed to retrieve user data by uid: $e");
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile, String uid) async {
    try {
      final ref = _storage.ref().child("profiles/$uid.png");
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload profile image");
    }
  }
}
