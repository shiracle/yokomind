import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart' as flags;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoko_mind/screens/public/payment/gradient_button.dart';
import 'package:yoko_mind/screens/public/payment/payment_modal.dart';

import 'package:yoko_mind/screens/public/payment/payment_ql.dart';
import 'package:yoko_mind/screens/student/student_home.dart';
import 'package:yoko_mind/theme/color.dart';

class PaymentBankList extends StatefulWidget {
  final List invoice;
  final String invoiceId;
  final String invoiceQr;
  final Map<String, dynamic> userData;
  const PaymentBankList({
    super.key,
    required this.invoice,
    required this.invoiceId,
    required this.invoiceQr,
    required this.userData,
  });

  @override
  State<PaymentBankList> createState() => _PaymentBankListState();
}

class _PaymentBankListState extends State<PaymentBankList> {
  final ScrollController dragController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        child: Stack(
          children: <Widget>[
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: GradientButton(
            //     onTap: () {
            //       appState.signOut();

            //       Navigator.of(context).popUntil((route) {
            //         return route.settings.name == '/';
            //       });
            //     },
            //     text: "Буцах",
            //     textColor: Colors.white,
            //     gradient: const [Colors.teal, Colors.blue],
            //     width: size.width * 0.3,
            //     height: size.height * 0.065,
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GradientButton(
                onTap: () {
                  showModal(context, widget.invoiceQr);
                },
                text: "Qr харах",
                textColor: Colors.white,
                gradient: const [Colors.teal, Colors.blue],
                width: size.width * 0.3,
                height: size.height * 0.065,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Query(
                options: QueryOptions(
                  document: gql(PaymentGraphQL.statusCheck),
                  fetchPolicy: FetchPolicy.noCache,
                  variables: {"id": widget.invoiceId},
                  pollInterval: const Duration(seconds: 10),
                  onComplete: (data) async {
                    if (data['checkInvoiceStatus'] != null) {
                      if (data['checkInvoiceStatus'] == 'PENDING') {
                      } else {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var token = prefs.getString('token') ?? '';

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StudentView(token)));
                      }
                    }
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.teal, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(size.width * 0.05),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      width: size.width * 0.3,
                      height: size.height * 0.065,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }
                  return GradientButton(
                    onTap: () async {
                      await refetch!();
                    },
                    text: "Төлбөр шалгах",
                    textColor: Colors.white,
                    gradient: const [Colors.teal, Colors.blue],
                    width: size.width * 0.3,
                    height: size.height * 0.065,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          controller: dragController,
          interactive: true,
          thumbVisibility: true,
          child: GridView.builder(
            controller: dragController,
            itemCount: widget.invoice.length,
            padding: const EdgeInsets.only(
                top: 15, left: 15, right: 15, bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (_, index) {
              var bank = widget.invoice[index];
              return GestureDetector(
                onTap: () {
                  _launchBank(
                    bank["name"],
                    bank["link"],
                  );
                },
                child: buildBankItem(bank),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBankItem(bank) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: constraints.maxHeight * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(
                    bank["logo"],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.05),
              Text(
                bank["description"],
                style: TextStyle(
                  fontSize: constraints.maxHeight * 0.09,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  _launchBank(String packageName, String action) async {
    if (Platform.isAndroid) {
      String packagebank = _switchBankAndroid(packageName);
      if (packagebank != "bank_404") {
        try {
          AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            package: packagebank,
            data: action,
          );
          await intent.launch();
        } on PlatformException catch (e) {
          if (e.code == 'error') {
            AndroidIntent intent = AndroidIntent(
              action: 'action_view',
              data:
                  'https://play.google.com/store/apps/details?id=$packagebank',
              flags: [flags.Flag.FLAG_ACTIVITY_NEW_TASK],
            );
            await intent.launch();
          }
        }
      }
    }
    if (Platform.isIOS) {
      String packagebank = _switchBankIos(packageName);
      Uri uri = Uri.parse(action);
      String appName = packageName.toLowerCase().replaceAll(' ', '-');
      Uri marketUri =
          Uri.parse("https://apps.apple.com/us/app/$appName/$packagebank");

      if (packagebank != "bank_404") {
        if (await canLaunchUrl(uri)) {
          launchUrl(uri);
        } else if (await canLaunchUrl(marketUri)) {
          launchUrl(marketUri);
        } else {
          if (context.mounted) {
            Fluttertoast.showToast(
              msg: "Алдаа гарсан тул хэсэг хугацааны дараа оролднуу!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        }
      }
    }
  }
}

_switchBankAndroid(String bankName) {
  switch (bankName) {
    case "qPay wallet":
      return "mn.qpay.wallet";

    case "Khan bank":
      return "com.khanbank.retail";

    case "State bank":
      return "mn.statebank.mobilebank";

    case "Xac bank":
      return "com.xacbank.mobile";

    case "Trade and Development bank":
      return "mn.tdb.pay";

    case "Most money":
      return "mn.grapecity.mostmoney";

    case "National investment bank":
      return "mn.nibank.mobilebank";

    case "Chinggis khaan bank":
      return "mn.ckbank.smartbank2";

    case "Capitron bank":
      return "mn.ecapitron";

    case "Bogd bank":
      return "com.bogdbank.ebank.v2";

    case "Trans bank":
      return "com.transbank.transbankmobile";

    case "M bank":
      return "mn.mllc.mbank";

    case "Ard App":
      return "mn.ard.androidmm";

    case "Arig bank":
      return "mn.arig.online";

    default:
      return "bank_404";
  }
}

_switchBankIos(String bankName) {
  switch (bankName) {
    case "qPay wallet":
      return "id1501873159";

    case "Khan bank":
      return "id1555908766";

    case "State bank":
      return "id703343972";

    case "Xac bank":
      return "id1534265552";

    case "Trade and Development bank":
      return "id1458831706";

    case "Most money":
      return "id487144325";

    case "National investment bank":
      return "id882075781";

    case "Chinggis khaan bank":
      return "id1180620714";

    case "Capitron bank":
      return "id1312706504";

    case "Bogd bank":
      return "id1475442374";

    case "Trans bank":
      return "id1604334470";

    case "M bank":
      return "id1455928972";

    case "Ard App":
      return "id1369846744";

    default:
      return "bank_404";
  }
}
