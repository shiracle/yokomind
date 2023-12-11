import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../main.dart';

class StudentDetail extends StatefulWidget {
  final id;
  final buleg;
  final name;
  final token;
  const StudentDetail(this.id, this.name, this.buleg, this.token, {super.key});

  @override
  State<StudentDetail> createState() => _StudentDetailState();
}

class _StudentDetailState extends State<StudentDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final HttpLink httpLink = HttpLink("$UrlBase:8002/graphql");
    final AuthLink authLink = AuthLink(getToken: () => 'JWT ${widget.token}');
    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ));
    return GraphQLProvider(
        client: client,
        child: Scaffold(
            body: Query(
                options: QueryOptions(document: gql('''
query studentById {
  studentById (id: ${widget.id}) {
    familyName
    name
    registerNo
    bloodType
    birthdate
    photo
    phone
    address
    bodyIndex
    vaccine
    drug
    allergies
    underlyingDisease
    etc
    section {
      section
    }
  }
}''')),
                builder: (QueryResult result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final list = result.data!['studentById'];
                  return Column(
                    children: [
                      SizedBox(
                        width: size.width * .99,
                        height: size.height * .22,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: size.width * .99,
                                height: size.height * .152,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                              ),
                            ),
                            Positioned(
                              left: 18,
                              top: 32,
                              child: Container(
                                width: 339,
                                height: 160,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 160,
                                        height: 160,
                                        decoration: const ShapeDecoration(
                                          image: DecorationImage(
                                            image: AssetImage("assets/pro.png"),
                                            fit: BoxFit.fill,
                                          ),
                                          shape: OvalBorder(),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: size.width * .4,
                                      top: size.height * 0.04,
                                      child: Text(
                                        '${list['familyName']} ${list['name']}',
                                        style: TextStyle(
                                          color: Color(0xFF1B1464),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: size.width * .4,
                                      top: size.height * 0.06,
                                      child: const Opacity(
                                        opacity: 0.99,
                                        child: Text(
                                          '5 настай',
                                          style: TextStyle(
                                            color: Color(0xFF1B1464),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: size.width * .4,
                                      top: size.height * 0.08,
                                      child: Text(
                                        '${list['section']['section']}-н сурагч',
                                        style: TextStyle(
                                          color: Color(0xFF1B1464),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: size.width * .4,
                                      top: size.height * 0.14,
                                      child: Text(
                                        'Төрсөн огноо: ${list['birthdate']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: size.width * .4,
                                      top: size.height * 0.12,
                                      child: Text(
                                        'РД: ${list['registerNo']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: size.width * .4,
                                      top: size.height * .16,
                                      child: Text(
                                        'Цусны бүлэг: ${list['bloodType']} ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: size.height * .02),
                        width: size.width * .85,
                        height: size.height * .2,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Асран хамгаалагчийн мэдээлэл',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * .74,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .02,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Овог Нэр: ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    '${list['familyName']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Хэн болох:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Утас:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    '${list['phone']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Хаяг:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    '${list['address']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                children: [
                                  Text(
                                    'Яаралтай үед холбогдох дугаар:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: size.height * .01),
                        width: size.width * .85,
                        height: size.height * .18,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Эрүүл мэнд',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * .74,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Биеийн индекс:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    list['bodyIndex'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Вакцин:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    list['vaccine'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      'Тогтмол уудаг эм:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * .015,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    list['drug'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * .3,
                                    child: Text(
                                      'Харшил:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * .015,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    list['allergies'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: size.height * .005,
                                  left: size.width * .05,
                                  right: size.width * .05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * .3,
                                    child: Text(
                                      'Суурь өвчин:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * .015,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    list['underlyingDisease'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * .015,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: size.height * .01),
                        width: size.width * .85,
                        height: size.height * .18,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Бусад',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                            Container(
                              width: size.width * .74,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                width: size.width * .74,
                                height: size.height * .13,
                                child: SingleChildScrollView(
                                  child: Text(
                                    list['etc'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: size.height * .01),
                          alignment: Alignment.center,
                          width: size.width * 0.55,
                          height: size.height * 0.045,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Буцах',
                            style: TextStyle(
                              color: Color(0xFF1B1464),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                })));
  }
}
