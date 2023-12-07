import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:yoko_mind/main.dart';
import 'package:yoko_mind/screens/teacher/index.dart';
import 'package:yoko_mind/theme/color.dart';

const studentz = """
query allStudents {
  allStudents {
    id
    name
    familyName
  }
  me {
    teacher {
      sectionSet {
        section
      }
    }
  }
}
""";

class TeacherHomeView extends StatefulWidget {
  final token;
  TeacherHomeView(this.token);
  static const route = "/home-teacher";

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}

class _TeacherHomeViewState extends State<TeacherHomeView> {
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
          backgroundColor: AppColor.background,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: size.height * .14,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/he.png",
                        height: size.height * .1,
                      ),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      Query(
                          options: QueryOptions(document: gql(studentz)),
                          builder: (QueryResult result, {fetchMore, refetch}) {
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }
                            if (result.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final categorys = result.data!['me'];
                            final buleg = categorys['teacher']['sectionSet'][0]
                                ['section'];
                            print("ddd--> $categorys");
                            // Profile(
                            //   email: "user@gmail.com",
                            //   name: "User",
                            //   onTap: () {
                            //     // TODO: implement qr ontap function
                            //     Navigator.pushNamed(context, QrReader.route);
                            //   },
                            //   phone: "998876655",
                            //   profilePic: "assets/profile.png",
                            // ),
                            return SizedBox(
                              width: 200,
                              child: Text(
                                buleg,
                                style: const TextStyle(
                                  color: Color(0xFF1B1464),
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'СУРАГЧДЫН НЭРС',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: size.height * .02,
                        width: size.width * .4,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => QrReader()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code,
                                color: Colors.white,
                                size: size.height * .025,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Qr уншуулах',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: size.width * 0.89,
                  height: 1,
                ),
                Container(
                  color: AppColor.background,
                  height: size.height * 0.66,
                  child: Query(
                      options: QueryOptions(document: gql(studentz)),
                      builder: (QueryResult result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }
                        if (result.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final categorys = result.data!['allStudents'];

                        return Container(
                          margin: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                              itemCount: categorys!.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var category = categorys[index];
                                var id = category['id'];
                                var name = category['name'];
                                var buleg = result.data!['me']['teacher']
                                    ['sectionSet'][0]['section'];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => NoteBookView(id,
                                                buleg, name, widget.token)));
                                  },
                                  child: Container(
                                    height: size.height * 0.067,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        bottom: size.height * 0.025),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: .5,
                                        color: AppColor.outLine,
                                      ),
                                      color: Color(0xFF010080),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.022,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
