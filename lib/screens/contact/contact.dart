import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/main.dart';
import 'package:yoko_mind/theme/color.dart';

import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String token = "";
  String id = "";
  String firstName = "";
  String lastName = '';
  String buleg = "";

  TextEditingController econtrol = TextEditingController();
  bool col = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _tokens());

    super.initState();
  }

  Future<void> _tokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      id = prefs.getString('studentId') ?? '';
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      buleg = prefs.getString("buleg") ?? '';
    });
    print(DateFormat('y-M-d').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColor.background,
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: size.height * .15,
            child: Image.asset("assets/logo.png"),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            height: size.height * .25,
            width: size.width * .895,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: size.height * .045,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  child: Text(
                    "Холбоо барих",
                    style: TextStyle(
                      color: AppColor.background,
                      fontSize: size.height * .02,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "Нэгж",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "Утасны дугаар",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      alignment: Alignment.center,
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16)),
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16)),
                          border: Border.all(color: Colors.white)),
                      height: size.height * .04,
                      width: size.width * .447,
                      child: Text(
                        "",
                        style: TextStyle(
                          color: AppColor.background,
                          fontSize: size.height * .02,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: size.height * .025, vertical: size.height * .025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: size.height * .04,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  child: Text(
                    "Удирдлагад хэлэх үг",
                    style: TextStyle(
                      color: AppColor.background,
                      fontSize: size.height * .02,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16))),
                  height: size.height * .3,
                  width: size.width * .9,
                  child: TextField(
                    controller: econtrol,
                    decoration: const InputDecoration(
                      hintText: "Text",
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 25, color: Colors.white),
                    maxLines: 20,
                    minLines: 2,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (econtrol.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: "Хэлэх зүйлээ бичнэ үү!",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );
              } else {
                ilgeeh();
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.white),
              height: size.height * .04,
              width: size.width * .5,
              child: Text(
                "Илгээх",
                style: TextStyle(
                  color: AppColor.background,
                  fontSize: size.height * .02,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ),
        ])));
  }

  Future<void> ilgeeh() async {
    Map<String, dynamic> resultdata;
    var response;
    var u1 = econtrol.text;
    print(u1);
    try {
      var url = '$UrlBase:8002/graphql';
      Map data = {
        'query': '''
 mutation {
  createContactRequest (body:"$u1") {
    contactRequest {
      body
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
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          Fluttertoast.showToast(
            msg: "Амжилттай",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          print(data);
          Fluttertoast.showToast(
            msg: "Алдаа гарсан тул хэсэг хугацааны дараа оролднуу!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          // if (context.mounted) {
          //   Navigator.pop(context);
          // }
        }
        // print('UnSuccessfully' + response.body);
      }
    } on SocketException {
      Fluttertoast.showToast(
          msg: "Та интернет холболтоо шалгана уу.",
          toastLength: Toast.LENGTH_LONG);
      // print(ex);
    }
    return response;
  }
}
