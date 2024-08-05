import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  factory Prefs() {
    return _singleton;
  }

  Prefs._internal() {
    init();
  }

  static late SharedPreferences _prefs;

  static final _singleton = Prefs._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(String userId) async {
    await _prefs.setString(_userId, userId);
  }

  static Future<void> setUserName(String userName) async {
    await _prefs.setString(_userName, userName);
  }

  static Future<void> setUserPhone(String userPhone) async {
    await _prefs.setString(_userPhone, userPhone);
  }

  static Future<void> setProfilePhoto(String userProfile) async {
    await _prefs.setString(_userProfilePhoto, userProfile);
  }

  static String? get getUserId {
    return _prefs.getString(_userId);
  }

  static String? get getProfilePhoto {
    return _prefs.getString(_userProfilePhoto);
  }

  static String? get getUserPhone {
    return _prefs.getString(_userPhone);
  }

  static String? get getUserName {
    return _prefs.getString(_userName);
  }
}

const _userId = "_userId";
const _userPhone = "_userPhone";
const _userName = "_userName";
const _userProfilePhoto = "_userProfilePhotos";
