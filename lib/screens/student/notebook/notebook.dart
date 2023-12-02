import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/main.dart';
import 'package:yoko_mind/theme/color.dart';

class NotebookStudent extends StatefulWidget {
  const NotebookStudent({super.key});

  @override
  State<NotebookStudent> createState() => _NotebookStudentState();
}

class _NotebookStudentState extends State<NotebookStudent> {
  String token = "";
  String id = "";
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
    });
    print("token $token");
    print("id $id");
  }

  // final _formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  TextEditingController usernameController = TextEditingController();
  bool edited = false;
  int selectedValue = 0;
  bool sleep = false;
  bool food = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String token1 =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImswMDEiLCJleHAiOjE3MDE0OTg3NjQsIm9yaWdJYXQiOjE3MDE0OTg0NjR9.w59JuBRfZlnfCap4SZEhSifoOwTwp00gptYLB76jS0M";
    final HttpLink httpLink = HttpLink("$UrlBase:8002/graphql");
    final AuthLink authLink = AuthLink(getToken: () => 'JWT ${token1}');
    final Link link = authLink.concat(httpLink);
    ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    ));

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        body: Query(
            options: QueryOptions(
                document: gql(
                  '''
                    query (\$id: ID) {
                      todaysStudentContactBooks(student: \$id) {
                        id
                        file
                        attandance
                        physicalCondition
                        sleep
                        morningFoodEat
                        defecate
                        wordToSay
                        date
                      }
                    }
                  ''',
                ),
                fetchPolicy: FetchPolicy.networkOnly,
                variables: {
                  "id": id,
                }),
            builder: (QueryResult result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final list = result.data!['todaysStudentContactBooks'];
              switch (list['defecate']) {
                case null:
                  list['defecate'] = "";
                  break;
              }
              switch (list['physicalCondition']) {
                case null:
                  list['physicalCondition'] = "";
                  break;
              }
              switch (list['physicalCondition']) {
                case null:
                  list['physicalCondition'] = "";
                  break;
              }
              switch (list['wordToSay']) {
                case null:
                  list['wordToSay'] = "";
                  break;
              }

              switch (list['morningFoodEat']) {
                case "BAD":
                  list['morningFoodEat'] = "Муу";
                  break;
                case "MEDIUM":
                  list['morningFoodEat'] = "Дунд";
                  break;
                case "GOOD":
                  list['morningFoodEat'] = "Сайн";
                  break;
              }
              switch (list['sleep']) {
                case "BAD":
                  list['sleep'] = "Муу";
                  break;
                case "MEDIUM":
                  list['sleep'] = "Дунд";
                  break;
                case "GOOD":
                  list['sleep'] = "Сайн";
                  break;
              }
              switch (list['attandance']) {
                case "ARRIVED":
                  list['attandance'] = "Ирсэн";
                  break;
                case "FREE":
                  list['attandance'] = "Чөлөөтэй";
                  break;
                case "SICK":
                  list['attandance'] = "Өвчтэй";
              }
              final regex = RegExp(r'\S+T');
              final dateFormater = regex.stringMatch(list['date']).toString();
              final regex1 = RegExp(r'[^T.]+');
              final date = regex1.stringMatch(dateFormater).toString();
              return RawScrollbar(
                thumbColor: AppColor.outLine.withOpacity(.5),
                radius: const Radius.circular(20),
                thickness: 4,
                controller: scrollController,
                interactive: true,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: size.width * .1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Ирц бүртгэл ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: size.height * .04,
                              width: size.width * .4,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.outLine,
                                ),
                              ),
                              child: Text(
                                date,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.017,
                                  fontFamily: 'Inter',
                                  height: 0,
                                ),
                              ),
                            ),
                            Container(
                              height: size.height * .04,
                              width: size.width * .2,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.outLine,
                                ),
                              ),
                              child: Text(
                                list['attandance'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.017,
                                  fontFamily: 'Inter',
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.14,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * 0.8,
                                child: Text(
                                  'Биеийн байдал ',
                                  style: TextStyle(
                                    color: AppColor.outLine,
                                    fontSize: size.height * 0.018,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: size.height * .06,
                                width: size.width * .8,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColor.outLine,
                                  ),
                                ),
                                child: Text(
                                  list['physicalCondition'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.019,
                                    fontFamily: 'Inter',
                                    height: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * .45,
                                child: Text(
                                  'Бие зассан эсэх',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.021,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: size.height * .04,
                                width: size.width * 0.35,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    list['defecate'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.016,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .055,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * .45,
                                child: Text(
                                  'Өдөр унтсан эсэх',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.021,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                constraints:
                                    BoxConstraints(minWidth: size.width * 0.15),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  list['sleep'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.016,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .055,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: size.width * .45,
                                child: Text(
                                  'Өглөөний цай',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.021,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                constraints:
                                    BoxConstraints(minWidth: size.width * 0.15),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  list["morningFoodEat"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.016,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              Container(
                                width: size.width * .8,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Эцэг эхэд хэлэх үг",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.021,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor.outLine,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(10),
                                constraints:
                                    BoxConstraints(minHeight: size.height * .1),
                                width: size.width * .8,
                                child: Text(
                                  list['wordToSay'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.019,
                                    fontFamily: 'Inter',
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * .8,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Зураг ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.021,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: AppColor.outLine,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: size.width * .8,
                                height: size.height * .15,
                                child: const Icon(
                                  size: 40,
                                  Icons.hide_image_outlined,
                                  color: AppColor.outLine,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
