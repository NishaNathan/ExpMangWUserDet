import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trainbookingapp/common/network/appexceptions.dart';

class BaseClient {
  static const int TIME_OUT_DURATION = 20;

  Future<dynamic> get(String apiUrl) async {
    var uri = Uri.parse(apiUrl);
    try {
      var response = await http
          .get(uri)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API did not respond in time', uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 401:
        return response;
      case 400:
      case 422:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred with code: ${response.statusCode}',
            response.request!.url.toString());
    }
  }
}
