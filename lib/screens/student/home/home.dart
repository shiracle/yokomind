import 'package:flutter/material.dart';
import 'package:yoko_mind/theme/color.dart';

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

  List news = [];
  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    List allNews = await SendRequests.fetchNewsAll();
    setState(() {
      news = allNews;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
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
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> individualNews = news[index];
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
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: constraints.maxWidth * .4,
                                      margin: const EdgeInsets.only(
                                          top: 10, left: 10, bottom: 10),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Image.asset(
                                        individualNews["image"],
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
                                              padding: const EdgeInsets.all(10),
                                              child: Scrollbar(
                                                controller: controller,
                                                thumbVisibility: true,
                                                child: SingleChildScrollView(
                                                  controller: controller,
                                                  child: Text(
                                                    individualNews["decr"],
                                                    style: TextStyle(
                                                      color: theme
                                                          .colorScheme.primary,
                                                      fontSize:
                                                          size.height * .014,
                                                      fontFamily: 'Inter',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: theme.colorScheme.primary,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: constraints.maxWidth * .5,
                                            height: constraints.maxHeight * .2,
                                            child: Text(
                                              individualNews["date"],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontSize: size.height * .015,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
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
  }
}

void _showDetailDialog(
  BuildContext context, {
  required String title,
  required String text,
  required String image,
}) {
  final theme = Theme.of(context);
  Size size = MediaQuery.of(context).size;
  showCupertinoModalPopup(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.dialogBackgroundColor),
            height: size.height * .7,
            width: 350,
            margin: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      image,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.height * .38,
                  decoration: BoxDecoration(
                    color: theme.dialogBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              text,
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(fontSize: 14),
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
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.basic,
                  borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                iconSize: 36,
                color: theme.primaryColor,
                icon: const Icon(
                  Icons.close,
                  color: AppColor.outLine,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
