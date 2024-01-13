import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/main.dart';
import 'package:yoko_mind/screens/student/everyday/food.dart';
import 'package:yoko_mind/theme/color.dart';

/// Flutter code sample for [Table].

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  String token = "";
  String id = "";
  String firstName = "";
  String lastName = '';
  String buleg = "";
  late final TabController _tabController;
  bool col = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _tokens());

    _tabController = TabController(length: 2, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            backgroundColor: AppColor.background,
            body: Query(
                options: QueryOptions(document: gql('''
query routines {
  me {
    student {
      section {
        teacher{
          name
          familyName
          phone
          photo
        }
        section
      }
    }
  }
  routines {
    action
    startAt
    endAt
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
                  final list = result.data!;
                  return Column(
                    children: <Widget>[
                      Container(
                        width: size.width * .9,
                        height: size.height * .1,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF6056C3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: size.height * .07,
                              width: size.width * 0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "$UrlBase:8002/media/${list['me']['student']['section']['teacher']['photo']}",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Багшийн танилцуулга',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * .02,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    height: 0,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * .6,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Нэр:",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                          Text(
                                            " ${list['me']['student']['section']['teacher']['familyName']}-н ${list['me']['student']['section']['teacher']['name']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Утасны дугаар:",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                          Text(
                                            "${list['me']['student']['section']['teacher']['phone']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF6056C3),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05,
                            vertical: size.height * .005),
                        child: TabBar.secondary(
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,

                          indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          // indicatorPadding:
                          //     EdgeInsets.symmetric(horizontal: size.width * 0.1),
                          unselectedLabelColor: Colors.white,
                          labelColor: AppColor.background,
                          tabs: const <Widget>[
                            Tab(
                              text: 'Хуваарь',
                            ),
                            Tab(text: 'Хоолны цэс'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Card(
                              elevation: 4,
                              color: AppColor.background,
                              surfaceTintColor: Colors.white,
                              margin: EdgeInsets.symmetric(
                                  horizontal: size.width * .05,
                                  vertical: size.height * .005),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: size.height * .01),
                                    alignment: Alignment.center,
                                    width: size.width * 0.9,
                                    height: size.height * .05,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                    ),
                                    child: Text(
                                      'Хичээлийн хуваарь: ${list['me']['student']['section']['section']} бүлэг ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF1B1464),
                                        fontSize: size.height * .017,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: size.height * .565,
                                      child: ListView.builder(
                                        itemCount: list['routines'].length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: size.height *
                                                .565 /
                                                list['routines'].length,
                                            width: size.width * .9,

                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  width: size.width * .44,
                                                  height: size.height /
                                                      list['routines'].length,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${list['routines'][index]['startAt']}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                      const Text(
                                                        " - ",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${list['routines'][index]['endAt']}",
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  width: size.width * .45,
                                                  height: size.height /
                                                      list['routines'].length,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "${list['routines'][index]['action']}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),

                                            // Text("$list['routines']['action']"),
                                          );
                                        },
                                      ))
                                ],
                              ),
                            ),
                            Card(
                              elevation: 4,
                              color: AppColor.background,
                              surfaceTintColor: Colors.white,
                              margin: EdgeInsets.only(top: size.height * .01),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            "assets/eee.jpg",
                                          ),
                                          fit: BoxFit.fill,
                                        )),
                                    height: size.height * .22,
                                    width: size.width * .9,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFF6056C3),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10))),
                                              margin: EdgeInsets.only(
                                                  top: size.height * .079),
                                              height: size.height * .32,
                                              width: 30,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height:
                                                          size.height * .02),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: size.height * .06,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                    child: const RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        "09:30",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: size.height * .06,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                    child: const RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        "11:00",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: size.height * .06,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                    child: const RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        "12:30",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: size.height * .06,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                    child: const RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        "16:30",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: size.height * .06,
                                                    decoration:
                                                        const BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .white))),
                                                    child: const RotatedBox(
                                                      quarterTurns: 3,
                                                      child: Text(
                                                        "17:30",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          height: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                top: size.height * .01),
                                            width: size.width * 0.9,
                                            height: size.height * .05,
                                            decoration: const ShapeDecoration(
                                              color: Color(0xFF6056C3),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              16))),
                                            ),
                                            child: Text(
                                              'Хоолны цэс',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.height * .015,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: const Color(0xFF6056C3),
                                            width: size.width * .9,
                                            height: size.height * .04,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * .18,
                                                  height: size.height * .04,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text(
                                                    'Даваа',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.height * .015,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * .18,
                                                  height: size.height * .04,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text(
                                                    'Мягмар',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.height * .015,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * .18,
                                                  height: size.height * .04,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text(
                                                    'Лхагва',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.height * .015,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * .18,
                                                  height: size.height * .04,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                    right: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text(
                                                    'Пүрэв',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.height * .015,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: size.width * .18,
                                                  height: size.height * .04,
                                                  decoration:
                                                      const BoxDecoration(
                                                          border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.white),
                                                  )),
                                                  child: Text(
                                                    'Баасан',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.height * .015,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Food()
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })));
  }
}
