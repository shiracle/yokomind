import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String UrlBase = "http://103.143.40.163";

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
      if (res['data'] != null) {
        result = res;
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
  // static Future<Map?> queryME() async {
  //   Map? result = {};
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? token = prefs.getString('token');
  //   await BaseApi.getResponse(
  //           operations: {"query": AuthGraphQL.me}, token: token)
  //       .onError(
  //     (error, stackTrace) {},
  //   )
  //       .then((res) {
  // if (res['data']['me'] != null) {
  //         result = res['data']['me'];
  //       } else {
  //         result = null;
  //       }
  //   });
  //   return result;
  // }
}
