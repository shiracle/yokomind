import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/api/api.dart';
import 'package:yoko_mind/main.dart';

import 'package:yoko_mind/theme/color.dart';

class HandToHandView extends StatefulWidget {
  const HandToHandView({super.key});

  @override
  State<HandToHandView> createState() => _HandToHandViewState();
}

class _HandToHandViewState extends State<HandToHandView> {
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    ThemeData theme = Theme.of(context);
    final HttpLink httpLink = HttpLink("$UrlBase:8002/graphql");
    final AuthLink authLink = AuthLink(getToken: () => 'JWT $token');
    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ));
    return GraphQLProvider(
        client: client,
        child: Scaffold(
          backgroundColor: AppColor.outLine,
          body: id.isNotEmpty
              ? Query(
                  options: QueryOptions(
                    document: gql('''
                    query studentHandoverByDate {
                      studentHandoverByDate (student:${id}){
                        date
                        isSuccessed
                        isNotified
                        code
                      }
                    }'''),
                  ),
                  builder: (QueryResult result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final list = result.data!['studentHandoverByDate'];

                    return Column(
                      children: [
                        Container(
                          height: size.height * .2,
                          padding: EdgeInsets.only(bottom: size.height * .05),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'QR кодоо уншуулна уу',
                                style: TextStyle(
                                  color: AppColor.outLine,
                                  fontSize: size.height * .02,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height * .015),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * .1),
                                child: Text(
                                  'Гараас гарт үйлчилгээг баталгаажуулан доорх кодыг уншуулна. Мөн нэг удаа ашиглах боломжтой нууц код үүсгэн ашиглах боломжтой.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColor.outLine,
                                    fontSize: size.height * .016,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomPaint(
                                foregroundPainter: BorderPainter(theme: theme),
                                child: Container(
                                  padding: EdgeInsets.all(size.height * .02),
                                  height: size.height * .3,
                                  child: PrettyQrView.data(
                                    data: list['code'],
                                  ),
                                ),
                              ),
                              CodeButton(code: list['code']),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(
                                          size.width * .5, size.height * .06)),
                                  onPressed: () =>
                                      notifyTeacher(token, list['code']),
                                  child: Text(
                                    'Багшид мэдэгдэх',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .02,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  })
              : Container(),
        ));
  }
}

class BorderPainter extends CustomPainter {
  final ThemeData theme;
  BorderPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = theme.colorScheme.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}

class BorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Future<void> notifyTeacher(String token, String userCode) async {
  bool result = await SendRequests.studentHandoverByDate(token, userCode);
  if (result) {
    Fluttertoast.showToast(
      msg: "Амжилттай",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  } else {
    Fluttertoast.showToast(
      msg: "Амжилтгүй",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}

class CodeButton extends StatefulWidget {
  final String code;
  const CodeButton({
    super.key,
    required this.code,
  });

  @override
  State<CodeButton> createState() => _CodeButtonState();
}

class _CodeButtonState extends State<CodeButton> {
  bool handoverCodeShow = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          fixedSize: Size(size.width * .5, size.height * .06)),
      onPressed: () {
        setState(() {
          handoverCodeShow = !handoverCodeShow;
        });
      },
      child: Text(
        handoverCodeShow ? 'Нууц код үүсгэх' : widget.code,
        style: TextStyle(
          fontSize: size.height * .02,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
