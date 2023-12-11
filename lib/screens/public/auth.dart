import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/main.dart';
import 'package:yoko_mind/screens/public/appState.dart';
import 'package:yoko_mind/screens/student/student_home.dart';
import 'package:yoko_mind/screens/teacher/home/home.dart';
import 'package:yoko_mind/theme/color.dart';
import 'package:yoko_mind/widgets/inputs.dart';
import 'package:yoko_mind/widgets/round_button.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  static const route = "/";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final appState = Provider.of<AppState>(context);
    return Scaffold(
        backgroundColor: AppColor.background,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.19,
                width: size.width,
                child: SizedBox(
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.4,
                width: size.width * 0.8,
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomInputField(
                        hintText: "Нэр",
                        onChanged: (string) {},
                        inputController: usernameController,
                        next: true,
                        validationText: "",
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomInputField(
                        hintText: "Нууц үг",
                        onChanged: (string) {},
                        inputController: passwordController,
                        isSecure: true,
                        validationText: "",
                      ),
                      const SizedBox(height: 35),
                      RoundedButton(
                        onTap: () => _login(appState),
                        label: "Нэвтрэх",
                        height: size.height * 0.06,
                        width: size.width * 0.6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // Future<void> _dialogBuilder(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         actionsAlignment: MainAxisAlignment.center,
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('teacher'),
  //             onPressed: () {
  //               Navigator.of(context).popAndPushNamed(TeacherHomeView.route);
  //             },
  //           ),
  //           TextButton(
  //             style: TextButton.styleFrom(
  //               textStyle: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             child: const Text('student'),
  //             onPressed: () {
  //               Navigator.of(context).popAndPushNamed(StudentView.route);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _login(AppState appState) async {
    Map<String, dynamic> resultdata;
    var response;
    var u1 = usernameController.text;
    var u2 = passwordController.text;
    try {
      var url = '$UrlBase:8002/graphql';
      Map data = {
        'query': '''mutation {
  tokenAuth (username:"$u1", password:"$u2") {
    token
    success
    user {
    firstName
    lastName
    isTeacher
    isStudent
    student{
        id
        birthdate
        section{
          section
        }
      }
      teacher {
        sectionSet {
          section
        }
      }
      
    }
  }
}''', // 'password': passwordController.text,
      };

      //encode Map to JSON
      var body = (data);

      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body);
      // ignore: unnecessary_null_comparison
      if (response.body != null) {
        resultdata = json.decode(response.body);
        if (resultdata['data']['tokenAuth']['success'] == true) {
          // if (resultdata['data']['tokenAuth']["user"]["student"]["isPaid"] ==
          //     true) {
          var token = resultdata['data']['tokenAuth']['token'];

          if (resultdata['data']['tokenAuth']['user']['isTeacher'] == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherHomeView(token)));
          } else {
            saveInfo(
                resultdata['data']['tokenAuth']['token'],
                resultdata['data']['tokenAuth']['user']['student']['id'],
                resultdata['data']['tokenAuth']['user']['firstName'],
                resultdata['data']['tokenAuth']['user']['lastName'],
                resultdata['data']['tokenAuth']['user']['student']['section']
                    ['section'],
                resultdata['data']['tokenAuth']['user']['student']
                    ['birthdate']);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StudentView(token)));
          }
        } else {
          Fluttertoast.showToast(
            msg: "Нэвтрэх нэр эсвэл нууц үг буруу",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red, //Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Нэвтрэх үйлдэл амжилтгүй та дахин оролдоно уу.",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red, //Colors.red,
          textColor: Colors.white,
        );
      }
    } on SocketException {
      Fluttertoast.showToast(
          msg: "Та интернет холболтоо шалгана уу.",
          toastLength: Toast.LENGTH_LONG);
    }
    return response;
  }

  Future<void> saveInfo(
    String token,
    String studentId,
    String firstName,
    String lastName,
    String buleg,
    String birthdate,
    // String photo
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("token", token);
      prefs.setString("studentId", studentId);
      prefs.setString("firstName", firstName);
      prefs.setString("lastName", lastName);
      prefs.setString("buleg", buleg);
      prefs.setString("birthDate", birthdate);

      // prefs.setString("name", name);
      prefs.setBool("isLogin", true);
    });
  }
}



// 
