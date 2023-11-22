
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hubtel_merchant_checkout_sdk/src/network_manager/network_manager.dart';
import '../resources/network_manager_strings.dart';


class Response {
  ApiResult? apiResult;
  dynamic response;
  String? rawResponse;

  Response({this.apiResult, this.response, this.rawResponse});
}

class Requester {
  // AppPrefManager manager;

  Requester();

  late http.Response _response;

  Future<Response> makeRequest({
    required Future<ApiEndPoint> apiEndPoint,
  }) async {
    final endPoint = await apiEndPoint;

    var headers = endPoint.headers;

    log("${endPoint.requestType.toString()} Request Initiated : ${endPoint.address} \nParams: ${endPoint.body} \nHeaders $headers");

    var timeOutDuration = const Duration(seconds: 60);

    try {
      _response = await runRequest(endPoint, headers).timeout(timeOutDuration);
    } catch (e) {
      log(e.toString());
      return formatErrorMessage(e, e.toString());
    }

    try {
      log("Response with code : ${_response.statusCode} for ${endPoint.requestType.toString()} >> ${endPoint.address} with params ${endPoint.body} : \nResponse >> ${_response.body}");

      var jsonResponse = json.decode(_response.body);

      if (_response.statusCode >= 200 && _response.statusCode < 300) {
        return Response(
          apiResult: ApiResult.Success,
          response: jsonResponse,
          rawResponse: _response.body,
        );
      } else {
        return Response(apiResult: ApiResult.Error, response: jsonResponse);
      }
    } catch (e) {
      log(e.toString());
      return formatErrorMessage(e, NetworkStrings.somethingWentWrong);
    }
  }

  Future<http.Response> runRequest(
      ApiEndPoint request,
      Map<String, String> headers,
      ) {
    switch (request.requestType) {
      case HttpVerb.GET:
        return http.get(request.address, headers: headers);
      case HttpVerb.DELETE:
        return http.delete(request.address, headers: headers);
      case HttpVerb.PATCH:
        return http.patch(
          request.address,
          headers: headers,
          body: request.body.toJson(),
        );
      case HttpVerb.PUT:
        return http.put(
          request.address,
          headers: headers,
          body: request.body.toJson(),
        );
      default:
        return http.post(
          request.address,
          headers: headers,
          body: request.body.toJson(),
        );
    }
  }

  Response formatErrorMessage(dynamic error, String defaultErrorMessage) {
    String? message;
    Map<String, dynamic> data = {};
    ApiResult apiResult = ApiResult.Error;

    switch (error.runtimeType) {
      case SocketException:
      case HttpException:
      case RedirectException:
      case WebSocketException:
        apiResult = ApiResult.NoInternet;
        message = NetworkStrings.internetError;
        break;
      case FormatException:
        apiResult = ApiResult.Error;
        message = NetworkStrings.formatError;
        break;
      case HandshakeException:
        message = NetworkStrings.handShakeError;
        break;
      case CertificateException:
        message = NetworkStrings.certificateError;
        break;
      case TlsException:
        message = 'SSL error occurred ${error?.message ?? ''}';
        break;
      case TimeoutException:
        apiResult = ApiResult.NoInternet;
        message = NetworkStrings.connectionTimeOut;
        break;
      default:
        message = message ?? defaultErrorMessage;
    }

    return Response(apiResult: apiResult, response: data);
  }
}
