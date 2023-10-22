
// import '../../utils/helpers/serializable.dart'; // TODO: double check
import '../api_core.dart';
import '../serializable.dart';

typedef ResultWrapper<T extends Serializable>
= BaseApiResponse<DataResponse<T>>;

typedef ListResultWrapper<T extends Serializable>
= BaseApiResponse<DataResponseList<T>>;


class BaseApiResponse<T extends Serializable> implements Serializable {
  T? response;

  ApiResult? apiResult;

  BaseApiResponse({this.response, this.apiResult});

  @override
  Map<String, dynamic> toMap() {
    return {"response": response?.toMap(), "status": apiResult};
  }
}

class DataResponse<T extends Serializable> implements Serializable {
  T? data;
  String? developerMessage;
  bool error;
  String? message;
  int status;

  DataResponse({
    this.data,
    this.developerMessage,
    this.error = false,
    this.message,
    required this.status,
  });

  factory DataResponse.fromJson(
      Map<String, dynamic>? json,
      Function(Map<String, dynamic>?) create,
      ) {
    return DataResponse(
      data: create(json?['data']),
      developerMessage: json?['developer_message'],
      error: json?['error'] ?? false,
      message: json?['message'],
      status:  json?['code'] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'developer_message': developerMessage,
      'error': error,
      'message': message,
      'status': status,
    };
  }
}


class DataResponseList<T> implements Serializable {
  List<T>? data;
  String? developerMessage;
  bool error;
  String? message;
 int? code;

  DataResponseList({
    this.data,
    this.developerMessage,
    this.error = false,
    this.message,
    this.code,
  });

  factory DataResponseList.fromJson(
      Map<String, dynamic>? json,
      Function(Map<String, dynamic>?) create,
      ) {
    return DataResponseList(
      data: List<T>.from(
        (json?['data'] ?? []).map(
              (x) => create(x),
        ),
      ),
      developerMessage: json?['developer_message'],
      error: json?['error'] ?? false,
      message: json?['message'],
      code: json?['status'] ?? json?['code'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'developer_message': developerMessage,
      'error': error,
      'message': message,
      'status': code,
    };
  }
}