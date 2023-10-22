
import 'api_core.dart';

class ApiEndPoint {
  Uri address;
  String baseUrl;
  String path;
  HttpVerb requestType;
  Map<String, dynamic> body;
  Map<String, String> headers;

  // ApiActionFilter? actionFilters;

  ApiEndPoint({
    required this.address,
    required this.baseUrl,
    required this.path,
    required this.requestType,
    required this.body,
    required this.headers,
    // this.actionFilters,
  });
}

mixin EndPointCore {
  late String apiKey;
  Future<ApiEndPoint> createEndpoint({
    required String authority,
    required String path,
    requestType = HttpVerb,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    // ApiActionFilter? actionFilters,
  }) async {
    var _headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Basic $apiKey'
    };

    //add relative headers
    if (headers != null) {
      _headers.addAll(headers);
    }

    var requestBody = body;
    requestBody ??= {};

    if (requestType != HttpVerb.GET) {
      //requestBody[SharedPreferenceValues.KEY_ACCESS_TOKEN] = accessToken;
    }

    final queryParams = requestType == HttpVerb.GET ? requestBody : null;
    final uri = Uri.https(authority, path, queryParams);
    return ApiEndPoint(
      address: uri,
      baseUrl: authority,
      path: path,
      requestType: requestType,
      body: requestBody,
      headers: _headers,
      // actionFilters: actionFilters,
    );
  }


// void logEvent({
//   required AppEvent event,
//   dynamic data,
//   Serializable? extraData,
// }) {
//   if (data is Serializable) {
//     AnalyticsHelper.logEvent(event: event, data: data, extraData: extraData);
//   }
// }

// Future<String> getAppVersion() async {
//   String appVersion = "";
//
//   await Utils().getVersionNumber().then((completeVersion) {
//     appVersion = completeVersion[0];
//   });
//
//   return appVersion;
// }
}
