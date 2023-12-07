import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yoko_mind/main.dart';

class Food extends StatefulWidget {
  const Food({super.key});

  @override
  State<Food> createState() => _FoodState();
}

@override
class _FoodState extends State<Food> {
  String token = "";
  String id = "";
  String firstName = "";
  String lastName = '';
  String buleg = "";
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
    final HttpLink httpLink = HttpLink("$UrlBase:8002/graphql");
    final AuthLink authLink = AuthLink(getToken: () => 'JWT $token');
    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ));
    return GraphQLProvider(
        client: client,
        child: Query(
            options: QueryOptions(document: gql('''
query allFoods {
  allFoods {
    name
    time
    day
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
              return Row(
                children: [
                  SizedBox(
                    width: size.width * .18,
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list['allFoods'].length,
                      itemBuilder: (context, index) {
                        if (list['allFoods'][index]['day'] == "Даваа") {
                          return Container(
                              width: size.width * .18,
                              height: size.height * .06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF6056C3),
                                  border: Border.all(color: Colors.white54)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    "${list['allFoods'][index]['name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * .18,
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list['allFoods'].length,
                      itemBuilder: (context, index) {
                        if (list['allFoods'][index]['day'] == "Мягмар") {
                          return Container(
                              width: size.width * .18,
                              height: size.height * .06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF6056C3),
                                  border: Border.all(color: Colors.white54)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    "${list['allFoods'][index]['name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * .18,
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list['allFoods'].length,
                      itemBuilder: (context, index) {
                        if (list['allFoods'][index]['day'] == "Лхагва") {
                          return Container(
                              width: size.width * .18,
                              height: size.height * .06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF6056C3),
                                  border: Border.all(color: Colors.white54)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    "${list['allFoods'][index]['name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * .18,
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list['allFoods'].length,
                      itemBuilder: (context, index) {
                        if (list['allFoods'][index]['day'] == "Пүрэв") {
                          return Container(
                              width: size.width * .18,
                              height: size.height * .06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF6056C3),
                                  border: Border.all(color: Colors.white54)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    "${list['allFoods'][index]['name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.width * .18,
                    height: size.height * .3,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: list['allFoods'].length,
                      itemBuilder: (context, index) {
                        if (list['allFoods'][index]['day'] == "Баасан") {
                          return Container(
                              width: size.width * .18,
                              height: size.height * .06,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xFF6056C3),
                                  border: Border.all(color: Colors.white54)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    "${list['allFoods'][index]['name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              );
            }));
  }
}
