// import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:yoko_mind/theme/color.dart';

class QrReader extends StatefulWidget {
  const QrReader({super.key});
  static const route = "/qr_reader";

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  bool loading = false;

  Barcode? barcode;
  QRViewController? controller;
  bool qrError = false;

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // if (Barcode != null) {
      // String? url = barcode?.code;
      //TODO: on qr code found functions
      // }
    });
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(
            top: 10 + MediaQuery.of(context).padding.top,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(15),
              ),
              child: buildControlButtons(),
            ),
          ),
          Positioned(
            top: 10 + MediaQuery.of(context).padding.top,
            left: 10,
            child: IconButton(
              icon: const Icon(
                (Icons.arrow_back_ios_new),
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          loading
              ? Positioned(
                  child: Container(
                    color: Colors.black38,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildControlButtons() => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IconButton(
          //   onPressed: () async {
          //     await controller?.toggleFlash();
          //     setState(() {});
          //   },
          //   icon: FutureBuilder<bool?>(
          //     future: controller?.getFlashStatus(),
          //     builder: (context, snapshot) {
          //       if (snapshot.data != null) {
          //         return Icon(
          //             snapshot.data! ? Icons.flash_on : Icons.flash_off);
          //       } else {
          //         return Container();
          //       }
          //     },
          //   ),
          // ),
          IconButton(
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
            icon: const Icon(Icons.switch_camera),
          ),
        ],
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: AppColor.outLine,
          borderRadius: 20,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream
        .listen((barcode) => setState(() => this.barcode = barcode));
  }
// TODO: take ref from here
  // Future<void> sendRequest(userIdCode) async {
  //   final check = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(EnviConfig.apiUrl),
  //   );
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   check.headers['Authorization'] = 'JWT $token';
  //   final checkOperations = {
  //     'query': ShareGraphQl.share,
  //     "variables": {
  //       "id": userIdCode,
  //     }
  //   };
  //   check.fields['operations'] = json.encode(checkOperations);
  //   final checkStreamedResponse = await check.send();
  //   final checkResponse = await http.Response.fromStream(checkStreamedResponse);
  //   if (checkResponse.statusCode == 200) {
  //     final data = json.decode(checkResponse.body)['data']['sendToMe'];
  //     if (data != null) {
  //       if (data['success']) {
  //         if (context.mounted) {
  //           Navigator.of(context).pushReplacementNamed(
  //             '/user',
  //             arguments: {"userID": userIdCode, "owner": false},
  //           );
  //         }
  //       } else {
  //         if (context.mounted) Navigator.pop(context);
  //       }
  //     } else {
  //       if (context.mounted) Navigator.pop(context);
  //     }
  //   } else {
  //     throw Exception('Failed to add');
  //   }
  // }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
