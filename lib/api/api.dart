import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoko_mind/main.dart';
import 'package:yoko_mind/screens/public/payment/payment_ql.dart';

class BaseApi {
  static Future<dynamic> getResponse({
    operations,
    token = '',
  }) async {
    dynamic result;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$UrlBase:8002/graphql"),
    );
    if (operations != null) {
      request.fields['operations'] = json.encode(operations);
    }

    var headers = {'Authorization': 'JWT $token'};

    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      if (res["data"] != null) {
        result = res["data"];
      } else {
        result = null;
      }
    } else {
      Future.error('Error! Error code: ${response.statusCode}');
    }
    return result;
  }
}

class SendRequests {
  static Future<bool> studentHandoverByDate(
      String token, String userCode) async {
    bool result = false;
    await BaseApi.getResponse(
      operations: {
        "query": '''
          mutation{
            notifyToTeacher (code: "$userCode") {
              handOver {
                isNotified
              }
            }
          }
        ''',
        "variable": {}
      },
      token: token,
    ).onError((error, stackTrace) => null).then((res) {
      if (res['notifyToTeacher'] != null) {
        if (res['notifyToTeacher']["handOver"] != null) {
          result = res['notifyToTeacher']["handOver"]["isNotified"];
        }
      }
    });
    return result;
  }

  static Future<bool> setHandOverSuccessed(
      String token, String userCode) async {
    bool result = false;
    await BaseApi.getResponse(
      operations: {
        "query": '''
          mutation {
            setHandOverSuccessed (code: "$userCode") {
              handOver {
                isSuccessed
              }
            }
          }
        ''',
        "variable": {}
      },
      token: token,
    ).onError((error, stackTrace) => null).then((res) {
      if (res['setHandOverSuccessed'] != null) {
        if (res['setHandOverSuccessed']["handOver"] != null) {
          result = res['setHandOverSuccessed']["handOver"]["isSuccessed"];
        }
      }
    });
    return result;
  }

  static Future<List> fetchNewsAll() async {
    List result = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    await BaseApi.getResponse(
      operations: {
        "query": '''
          query {
            allNews {
              id
              title
              description
              image
              createdAt
            }
          }
        ''',
        "variable": {}
      },
      token: token,
    ).onError((error, stackTrace) => null).then((res) {
      result = res["allNews"];
    });
    return result;
  }

  static Future<Map> createInvoice() async {
    Map result = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    await BaseApi.getResponse(
      operations: {"query": PaymentGraphQL.createInvoice, "variable": {}},
      token: token,
    ).onError((error, stackTrace) => null).then((res) {
      result = res['createInvoice']['invoice'];
    });
    return result;
  }

  static Future<Map> queryInvoices() async {
    Map result = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    await BaseApi.getResponse(
      operations: {"query": PaymentGraphQL.queryInvoce, "variable": {}},
      token: token,
    ).onError((error, stackTrace) => null).then((res) {
      result = res['myInvoice'];
    });
    return result;
  }

  static Future<String?> statusCheckQuery(String invoiceId) async {
    String? result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    await BaseApi.getResponse(
      operations: {
        "query": """
          query {
            checkInvoiceStatus (invoice: $invoiceId)
          }
        """,
        "variable": {}
      },
      token: token,
    ).onError((error, stackTrace) => null).then(
      (res) {
        result = res['checkInvoiceStatus'];
      },
    );
    return result;
  }

  static Future<Map?> handoverQrCode(String code) async {
    Map? result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    await BaseApi.getResponse(
      operations: {
        "query": '''
          mutation{
            setHandOverSuccessed(code:"$code"){
              handOver{
                isSuccessed
              }
            }
          }
        ''',
        "variable": {}
      },
      token: token,
    ).onError((error, stackTrace) => null).then(
      (res) {
        result = res['handOver'];
      },
    );
    return result;
  }
}
