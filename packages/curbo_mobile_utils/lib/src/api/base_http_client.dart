import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

abstract class BaseHttpClient {
  final http.Client _client;

  BaseHttpClient(
    this._client,
  );

  Future<String?> getToken();

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final token = await _getToken();

    final preparedHeaders = await _buildHeader(token: token, headers: headers);

    final response = await _client.get(url, headers: preparedHeaders);

    return _processResponse(response);
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final token = await _getToken();

    final preparedHeaders = await _buildHeader(token: token, headers: headers);

    final response = await _client.post(url,
        headers: preparedHeaders, body: body, encoding: encoding);

    return _processResponse(response);
  }

  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final token = await _getToken();

    final preparedHeaders = await _buildHeader(token: token, headers: headers);

    final response = await _client.put(url,
        headers: preparedHeaders, body: body, encoding: encoding);

    return _processResponse(response);
  }

  Future<String?> _getToken() async {
    final token = await getToken();

    return token;
  }

  Future<Map<String, String>> _buildHeader({
    String? token,
    Map<String, String>? headers,
  }) async {
    final overrideHeaders = Map<String, String>();

    if (headers != null) overrideHeaders.addAll(headers);

    if (token?.isNotEmpty ?? false)
      overrideHeaders[HttpHeaders.authorizationHeader] = 'Bearer $token';

    return overrideHeaders;
  }

  http.Response _processResponse(http.Response response) {
    var statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode <= 300) {
      return response;
    } else if (statusCode == 400) {
      throw BadRequestException(
        response.body,
        json.decode(response.body),
      );
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorisedException(
        response.body,
        json.decode(response.body),
      );
    } else if (statusCode == 404) {
      throw NotFoundException(
        response.body,
        json.decode(response.body),
      );
    } else {
      throw ServerException(
        'Error occured while Communication with Server with StatusCode : $statusCode',
        json.decode(response.body),
      );
    }
  }
}
