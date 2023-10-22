
// ignore_for_file: constant_identifier_names

import 'endpoints.dart';
import 'requester.dart';

enum ApiResult { Success, NoInternet, Error }

enum HttpVerb { POST, GET, PUT, PATCH, DELETE }

abstract class ApiCore {
  EndPoints endPoints = EndPoints();

  Requester requester;

  ApiCore({required this.requester});

  bool responseHasBody({ApiResult? status}) {
    if (status == ApiResult.Success) {
      return true;
    }
    return false;
  }
}
