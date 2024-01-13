import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yoko_mind/theme/color.dart';

showModal(
  context,
  String image,
) {
  Size size = MediaQuery.of(context).size;
  final base64Decoder = base64.decoder;
  var base64Bytes = image;
  final decodedBytes = base64Decoder.convert(base64Bytes);

  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: size.height * 0.5,
        color: AppColor.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              SizedBox(
                height: size.height * 0.3,
                child: Image.memory(decodedBytes, fit: BoxFit.fitHeight),
              ),
              SizedBox(height: size.height * 0.05),
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.1,
                child: const Text(
                  "Та энэхүү QR кодыг банкны апликэйшнаар уншуулан төлөөрэй Social pay-ээр уншуулах боломжгүй.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.outLine,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
