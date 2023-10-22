
import 'dart:convert';

extension MapExtensions on Map<String, dynamic> {
  String toJson() {
    return jsonEncode(this);
  }
}

extension Utilities<T> on T {
  R? let<R>(R Function(T) block) {
    if (this != null) {
      return block(this);
    }
    return null;
  }
}

extension ListGetOrNullExtension<T> on List<T> {
  T? getOrNull(int index) {
    return (index >= 0 && index < length) ? this[index] : null;
  }
}
