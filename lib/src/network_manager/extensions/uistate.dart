enum UiState { loading, success, error, idle }

class UiState2<T> {
  final T data;
  final bool isLoading;
  final String? error;

  UiState2({
    required this.data,
    required this.isLoading,
    this.error,
  });
}

class UiResult<T> {
  final T? data;
  String message;
  UiState state;

  UiResult({
    required this.state,
    this.message = "",
    this.data,
  });

  bool get hasError => state == UiState.error;
}

class UiResult2<T> {
  final T? data;
  String message = "";
  UiState state;
  final UiText? error;

  UiResult2({
    required this.state,
    required this.message,
    this.data,
    this.error,
  });

  bool get hasError => error != null;

  bool get hasData => data != null;
}

enum UiTextType { dynamicString, stringResource, pluralResource }

class UiText {
  final UiTextType type;
  final String? dynamicString;
  final int? resId;
  final List<dynamic>? args;
  final int? quantity;

  UiText.dynamicString(String value)
      : type = UiTextType.dynamicString,
        dynamicString = value,
        resId = null,
        args = null,
        quantity = null;

  UiText.stringResource(int resId, List<dynamic> args)
      : type = UiTextType.stringResource,
        dynamicString = null,
        resId = resId,
        args = args,
        quantity = null;

  UiText.pluralResource(int resId, int quantity, List<dynamic> args)
      : type = UiTextType.pluralResource,
        dynamicString = null,
        resId = resId,
        args = args,
        quantity = quantity;

  String asString() {
    switch (type) {
      case UiTextType.dynamicString:
        return dynamicString ?? '';
      case UiTextType.stringResource:
        return 'String Resource (resId: $resId, args: $args)';
      case UiTextType.pluralResource:
        return 'Plural Resource (resId: $resId, quantity: $quantity, args: $args)';
      default:
        return '';
    }
  }
}
