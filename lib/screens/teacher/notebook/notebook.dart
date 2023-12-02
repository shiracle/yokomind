import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yoko_mind/screens/teacher/notebook/studentDetail.dart';
import 'package:yoko_mind/theme/color.dart';
import 'package:yoko_mind/widgets/inputPass.dart';
import 'package:yoko_mind/widgets/inputs.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:yoko_mind/widgets/parentsInput.dart';

import '../../../main.dart';

class NoteBookView extends StatefulWidget {
  final id;
  final buleg;
  final name;
  final token;
  const NoteBookView(this.id, this.buleg, this.name, this.token, {super.key});
  static const route = "/teacher_note";

  @override
  State<NoteBookView> createState() => _NoteBookViewState();
}

class _NoteBookViewState extends State<NoteBookView> {
  @override
  void initState() {
    // TODO: ene nuguu query shuu
    getInfo(widget.id);
    super.initState();
  }

  bool loading = false;
  final ImagePicker picker = ImagePicker();

  XFile? image;

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
    });
  }

  Map<dynamic, dynamic>? contactInfo;

  List<String> get _listTextTabToggle => ["Ирсэн", "Чөлөөтэй", "Өвчтэй"];

  List<String> get _listTextSelectedToggle => ["Муу", "Дунд", "Сайн"];

  final formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  TextEditingController tailbarController = TextEditingController();
  TextEditingController physicalController = TextEditingController();

  TextEditingController parentsController = TextEditingController();
  // TODO: irsen datag contactinfo deer hadgalj baigaa tul null shalgaad door utguud deer nemj uguurei
  bool edited = false;
  int selectedValue = 0;
  bool sleep = false;
  bool food = false;
  int indexSelected = 0;
  String test = "";
  String test1 = "";
  String test2 = "";
  int noirSelect = 0;
  int foodSelect = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColor.background,
              )),
          elevation: 0,
          shadowColor: Colors.white,
          toolbarHeight: size.height * .13,
          title: SizedBox(
              width: size.width,
              height: size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    foregroundImage: AssetImage("assets/pro.png"),
                    radius: 45,
                  ),
                  SizedBox(
                    width: size.width * 0.1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.name}',
                            style: const TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          const Text(
                            '5 настай',
                            style: TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          Text(
                            "${widget.buleg}-н сурагч",
                            style: const TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => StudentDetail(
                                      widget.id,
                                      widget.name,
                                      widget.buleg,
                                      widget.token)));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 178,
                          height: 30,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFF1B1464)),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Сурагчийн мэдээлэл харах',
                            style: TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ))),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: RawScrollbar(
            thumbColor: AppColor.outLine.withOpacity(.5),
            radius: const Radius.circular(20),
            thickness: 4,
            controller: scrollController,
            interactive: true,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Here default theme colors are used for activeBgColor, activeFgColor, inactiveBgColor and inactiveFgColor
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          width: size.width * 0.8,
                          child: Text(
                            'Ирц бүртгэл',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.017,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.width * .1, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                color: Colors.white,
                              )),
                          child: FlutterToggleTab(
                            width: size.width * .193, // width in percent
                            borderRadius: 8,
                            height: size.height * 0.045,
                            selectedIndex: indexSelected,
                            unSelectedBackgroundColors: const [
                              AppColor.background,
                              AppColor.background
                            ],
                            selectedBackgroundColors: const [
                              Colors.white,
                              Colors.white
                            ],
                            selectedTextStyle: const TextStyle(
                                color: AppColor.background,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                            unSelectedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            labels: _listTextTabToggle,

                            selectedLabelIndex: (index) {
                              setState(() {
                                indexSelected = index;
                                switch (index) {
                                  case 0:
                                    test = "ARRIVED";
                                    break;
                                  case 1:
                                    test = "FREE";
                                    break;
                                  case 2:
                                    test = "SICK";
                                    break;
                                }
                              });
                            },
                            isScroll: false,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      height: size.height * 0.11,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.8,
                            child: Text(
                              'Биеийн байдал ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomInputField(
                            onChanged: (value) {},
                            inputController: physicalController,
                            validationText: "",
                            placeholder: "Тайлбар бичих",
                            // limitString: 200,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      height: size.height * .05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * .35,
                            child: Text(
                              'Бие зассан эсэх',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: size.height * 0.2,
                            width: size.width * 0.415,
                            child: CustomInputFieldPass(
                              onChanged: (value) {},
                              inputController: tailbarController,
                              validationText: "",
                              placeholder: "Тайлбар",
                              // limitString: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      height: size.height * .055,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * .25,
                            child: Text(
                              'Өдрийн нойр',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.white,
                                )),
                            child: FlutterToggleTab(
                              width: size.width * .1, // width in percent
                              borderRadius: 8,
                              height: size.height * 0.035,
                              selectedIndex: noirSelect,
                              unSelectedBackgroundColors: const [
                                AppColor.background,
                                AppColor.background
                              ],
                              selectedBackgroundColors: const [
                                Colors.white,
                                Colors.white
                              ],
                              selectedTextStyle: const TextStyle(
                                  color: AppColor.background,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                              unSelectedTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              labels: _listTextSelectedToggle,

                              selectedLabelIndex: (index) {
                                setState(() {
                                  noirSelect = index;
                                  switch (index) {
                                    case 0:
                                      test1 = "BAD";
                                      break;
                                    case 1:
                                      test1 = "MEDIUM";
                                      break;
                                    case 2:
                                      test1 = "GOOD";
                                      break;
                                  }
                                });
                              },
                              isScroll: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      height: size.height * .055,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * .28,
                            child: Text(
                              'Өглөөний цай',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.white,
                                )),
                            child: FlutterToggleTab(
                              width: size.width * .1, // width in percent
                              borderRadius: 8,
                              height: size.height * 0.035,
                              selectedIndex: foodSelect,
                              unSelectedBackgroundColors: const [
                                AppColor.background,
                                AppColor.background
                              ],
                              selectedBackgroundColors: const [
                                Colors.white,
                                Colors.white
                              ],
                              selectedTextStyle: const TextStyle(
                                  color: AppColor.background,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                              unSelectedTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                              labels: _listTextSelectedToggle,

                              selectedLabelIndex: (index) {
                                setState(() {
                                  foodSelect = index;
                                  switch (index) {
                                    case 0:
                                      test2 = "BAD";
                                      break;
                                    case 1:
                                      test2 = "MEDIUM";
                                      break;
                                    case 2:
                                      test2 = "GOOD";
                                      break;
                                  }
                                });
                              },
                              isScroll: false,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * .1),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * .8,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              "Эцэг эхэд хэлэх үг",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.018,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          ParentsInput(
                            onChanged: (value) {},
                            inputController: parentsController,
                            validationText: "",
                            placeholder: "Тайлбар",
                            // limitString: 200,
                          ),
                          InkWell(
                            onTap: image == null
                                ? () => getImage(ImageSource.gallery)
                                : null,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: AppColor.outLine,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: size.width * .8,
                              height: size.height * .15,
                              child: image != null
                                  ? Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : Text(
                                      "Зураг оруулах",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.018,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            vertical: size.height * .01, horizontal: size.width * .1),
        height: size.height * .08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (contactInfo != null) {
                  formKey.currentState?.save();
                  String physicalCondition = physicalController.text.trim();
                  String defecate = tailbarController.text.trim();
                  String morningFoodEat = test2.toString().trim();
                  String attandance = test.toString().trim();
                  String sleep = test1.toString().trim();
                  String wordToSay = parentsController.text.trim();
                  signUp(
                    physicalCondition,
                    defecate,
                    morningFoodEat,
                    sleep,
                    attandance,
                    wordToSay,
                    contactInfo!["id"],
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: "Алдаа гарсан тул хэсэг хугацааны дараа оролднуу!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .09,
                  vertical: size.height * .01,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColor.outLine,
                    ),
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  'Хадгалах',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: size.height * .02,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// TODO: ene boltson zarim neg loading yumuu tiimerhuu yum hiiheer bol dutuu baigaa shuu
  Future<void> signUp(
    String physicalCondition,
    String defecate,
    String morningFoodEat,
    String sleep,
    String attandance,
    String wordToSay,
    String contactID,
  ) async {
    Map<String, dynamic> resultdata;
    var response;
    print(widget.id);
    try {
      var url = '$UrlBase:8002/graphql';

      final operations = {
        'query': '''
          mutation(
            \$attandance: String!
            \$defecate: String!
            \$id: ID!
            \$file: Upload!
            \$morningFoodEat: String!
            \$physicalCondition: String!
            \$sleep: String!
            \$wordToSay: String!
          ) {
            updateStudentContactBook(
              attandance: \$attandance
              defecate: \$defecate
              id: \$id
              file: \$file
              morningFoodEat: \$morningFoodEat
              physicalCondition: \$physicalCondition
              sleep: \$sleep
              wordToSay: \$wordToSay
            ) {
              studentContactBook {
                id
              }
            }
          }
        ''',
        'variables': {
          "attandance": attandance,
          "defecate": defecate,
          "id": contactID,
          "file": null,
          "morningFoodEat": morningFoodEat,
          "physicalCondition": physicalCondition,
          "sleep": sleep,
          "wordToSay": wordToSay,
        }
      };

      final map = {
        '0': ['variables.file']
      };

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'JWT ${widget.token}'
        ..fields['operations'] = json.encode(operations)
        ..fields['map'] = json.encode(map)
        ..files.add(await http.MultipartFile.fromPath(
          '0',
          image!.path,
        ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        if (data["updateStudentContactBook"]["studentContactBook"] != null) {
          Fluttertoast.showToast(
            msg: "Амжилттай",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
        } else {
          Fluttertoast.showToast(
            msg: "Алдаа гарсан тул хэсэг хугацааны дараа оролднуу!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
    return response;
  }

  Future<void> getInfo(String studentID) async {
    var url = '$UrlBase:8002/graphql';

    final operations = {
      'query': '''
          query(\$studentID: ID!){
            todaysStudentContactBooks(student: \$studentID){
              id
              file
              attandance
              contactBook{
                id
              }
              physicalCondition
              sleep
              morningFoodEat
              defecate
              wordToSay
              date
            }
          }
        ''',
      'variables': {
        "studentID": studentID,
      }
    };

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = 'JWT ${widget.token}'
      ..fields['operations'] = json.encode(operations);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        contactInfo = data["todaysStudentContactBooks"];
      });
    } else {
      throw Exception('error');
    }
  }
}
