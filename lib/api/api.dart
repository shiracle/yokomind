import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yoko_mind/main.dart';

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
}
