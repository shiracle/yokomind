import 'package:flutter/material.dart';

// ignore: slash_for_doc_comments
/**
 * Global State 
 * Accent 
 */
class AppState with ChangeNotifier {
  late bool isLogin = false;
  late String token;
  late String profile;
  late String name;
  late String familyName;
  late String photo;
  late String username;
  late int subjectId;
  late String id;

  // AppState() {
  //   getAppState();
  // }

  getLogin() => isLogin;
  setLogin(bool value) {
    isLogin = value;
    notifyListeners();
  }

  getSubjectId() => subjectId;
  setSubjectId(int value) {
    subjectId = value;
    notifyListeners();
  }

  getId() => id;
  setId(String value) {
    id = value;
    // notifyListeners();
  }

  getToken() => token;
  setToken(String value) {
    token = value;
    notifyListeners();
  }

  getProfile() => profile;
  setProfile(String value) {
    profile = value;
    notifyListeners();
  }

  getName() => name;
  setName(String value) {
    name = value;
    notifyListeners();
  }

  getUsername() => username;
  setUsername(String value) {
    username = value;
    notifyListeners();
  }

  getPhoto() => photo;
  setPhoto(String value) {
    photo = value;
    notifyListeners();
  }

  getFamilyName() => familyName;
  setFamilyName(String value) {
    familyName = value;
    notifyListeners();
  }

  // Future<void> getAppState() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   // isLogin = pref.getBool("isLogin")!;

  //   setLogin(isLogin);
  //   setToken(token);
  //   setId(id);
  //   setSubjectId(subjectId);
  //   setProfile(profile);
  //   setFamilyName(familyName);
  //   setName(name);
  //   setPhoto(photo);
  //   setUsername(username);
  // }
}
