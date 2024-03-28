import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/theme/color.dart';

import '../../../main.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String token = "";
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _tokens());
    super.initState();
  }

  Future<void> _tokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
    print("token $token");
  }

  ScrollController mainController = ScrollController();

  List<Map<String, dynamic>> news = [
    {
      "image": "assets/news1.png",
      "decr":
          'Ёкоминэ Монгол цэцэрлэг өөрийн брэнд гар утасны апп-ыг хэрэглээнд нэвтрүүллээ',
      "date": "2023.10.09",
    },
    {
      "image": "assets/news2.jpeg",
      "decr":
          'Ёкоминэ Монгол цэцэрлэгийн 2 дугаар салбарын А бүлгүүдийн "Алтан намар" өдөрлөгийн гэрэл зургуудыг хүргэж байна',
      "date": "2023.10.09",
    },
  ];

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
      child: Query(
          options: QueryOptions(document: gql('''
query allNews {
  allNews {
    id
    title
    description
    image
    createdAt
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
            final list = result.data!['allNews'];
            return Column(
              children: [
                Image.asset(
                  "assets/news1.png",
                  height: size.height * .15,
                ),
                Container(
                  height: size.height * .2,
                  padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow,
                          size: size.height * .04,
                          color: theme.colorScheme.primary,
                        ),
                        Text(
                          'Ашиглах заавар үзэх',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: size.height * .02,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * .03),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * .05),
                    decoration: BoxDecoration(
                      color: AppColor.outLine,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: size.height * .05,
                          child: Text(
                            'Мэдээлэл',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: size.height * .019,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Scrollbar(
                          controller: mainController,
                          thumbVisibility: true,
                          interactive: true,
                          child: ListView.builder(
                            controller: mainController,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> individualNews = list[index];
                              ScrollController controller = ScrollController();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: AspectRatio(
                                  aspectRatio: 3 / 1,
                                  child: LayoutBuilder(
                                    builder: (
                                      BuildContext context,
                                      BoxConstraints constraints,
                                    ) {
                                      return Container(
                                        clipBehavior: Clip.hardEdge,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: size.width * .03),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: theme.colorScheme.primary,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: constraints.maxWidth * .4,
                                              margin: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Image.network(
                                                "$UrlBase:8002/media/${individualNews["image"]}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Scrollbar(
                                                        controller: controller,
                                                        thumbVisibility: true,
                                                        child:
                                                            SingleChildScrollView(
                                                          controller:
                                                              controller,
                                                          child: Text(
                                                            individualNews[
                                                                "description"],
                                                            style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .primary,
                                                              fontSize:
                                                                  size.height *
                                                                      .014,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 1,
                                                    color: theme
                                                        .colorScheme.primary,
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    width:
                                                        constraints.maxWidth *
                                                            .5,
                                                    height:
                                                        constraints.maxHeight *
                                                            .2,
                                                    child: Text(
                                                      individualNews[
                                                          "createdAt"],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: theme.colorScheme
                                                            .primary,
                                                        fontSize:
                                                            size.height * .015,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * .03),
              ],
            );
          }),
    );
  }
}
