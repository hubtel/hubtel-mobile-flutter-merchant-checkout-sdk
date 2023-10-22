extension StringExtensions on String {
  double toDouble() {
    return double.tryParse(this) ?? 0;
  }

  bool? toBooleanStrictOrNull() {
    switch (this) {
      case "true":
        return true;
      case "false":
        return false;
    }
    return null;
  }

  /// Returns a new string with the first character of the string capitalized.
  /// Calling this function on a string which already starts with a capital letter will
  /// have no visible effect.
  ///
  /// ### Example:
  /// ```
  /// println("onions".capitalizeFirst()) // outputs Onions
  /// println("ONions".capitalize()) // outputs ONions"
  /// ```
  String capitalizeFirst() {
    if (isEmpty) {
      return this;
    } else {
      return replaceFirstMapped(RegExp(r'^[a-z]'), (match) {
        return match.group(0)!.toUpperCase();
      });
    }
  }

  int indexFirstNonWhiteSpace(int startIndex) {
    for (var i = startIndex; i < length; i++) {
      if (this[i].trim().isNotEmpty) {
        return i;
      }
    }
    return -1;
  }

  int indexLastNonWhiteSpace() {
    for (var i = length - 1; i >= 0; i--) {
      if (this[i].trim().isNotEmpty) {
        return i;
      }
    }
    return -1;
  }

  /// Returns a new string with the first character of the string capitalized.
  ///
  /// ### Example:
  /// ```
  /// println("onions".capitalizeFirstCase()) // outputs Onions
  /// println("ONions".capitalizeFirstCase()) // outputs Onions
  /// println("ONions For Me".capitalizeFirstCase()) // outputs Onions for me
  /// ```
  String capitalizeFirstCase({bool cleanSpace = true}) {
    if (isEmpty) {
      return this;
    } else if (cleanSpace && trim().isEmpty) {
      return "";
    } else if (cleanSpace) {
      final trimmedString = trim().replaceAll(RegExp(r'\s+'), ' ');
      return "${trimmedString[0].toUpperCase()}${trimmedString.substring(1).toLowerCase()}";
    } else {
      final index = indexFirstNonWhiteSpace(0);
      if (index < 0) {
        return toLowerCase();
      } else {
        return "${substring(0, index)}${this[index].toUpperCase()}${substring(index + 1).toLowerCase()}";
      }
    }
  }

  /// Returns a new string with the each substring from splitting by ' ' capitalized and joined.
  ///
  /// ### Example:
  /// ```
  /// println("onions for me".capitalizeWordCase()) // outputs Onions For Me
  /// println("ONIONS FOR ME".capitalizeWordCase()) // outputs Onions For Me
  /// println("ONions".capitalizeWordCase()) // outputs Onions
  /// ```
  String capitalizeWordCase({bool cleanSpace = true}) {
    if (isEmpty) {
      return this;
    } else if (cleanSpace && trim().isEmpty) {
      return "";
    } else if (cleanSpace) {
      final words = trim().split(RegExp(r'\s+'));
      final capitalizedWords = words.map((word) => word.capitalizeFirstCase());
      return capitalizedWords.join(' ');
    } else {
      var capitalizedString = "";
      var prev = '';
      for (var c in toLowerCase().runes) {
        final char = String.fromCharCode(c);
        if (char.trim().isNotEmpty && (prev.isEmpty || prev.trim().isEmpty)) {
          capitalizedString += char.toUpperCase();
        } else {
          capitalizedString += char;
        }
        prev = char;
      }
      return capitalizedString;
    }
  }

  /// Returns a new string with the each substring from splitting by '.' capitalized and joined.
  ///
  /// ### Example:
  /// ```
  /// println("i like her. she likes me".capitalizeSentenceCase()) // outputs I like her. She likes me
  /// println("I LIKE HER. She Likes me.".capitalizeSentenceCase()) // outputs I like her. She likes me.
  /// println("I Like Her".capitalizeSentenceCase()) // outputs I like her."
  /// ```
  String capitalizeSentenceCase({bool cleanSpace = true}) {
    if (isEmpty) {
      return this;
    } else if (cleanSpace && trim().isEmpty) {
      return "";
    } else if (cleanSpace) {
      final sentences = split('.');
      final capitalizedSentences =
      sentences.map((sentence) => sentence.trim().capitalizeFirstCase());
      return capitalizedSentences.join('. ');
    } else {
      final sentences = split('.');
      final capitalizedSentences =
      sentences.map((sentence) => sentence.trim().capitalizeFirstCase());
      return capitalizedSentences.join('. ');
    }
  }

  /// Returns a new string with the each substring from splitting by '.' capitalized and joined.
  ///
  /// ### Example:
  /// ```
  /// println("bill kwaku ansah-inkoom".capitalizeNameWordCase()) // outputs Bill Kwaku Ansah-Inkoom
  /// println("Bill Kwaku Ansah-inkoom".capitalizeNameWordCase()) // outputs Bill Kwaku Ansah-Inkoom
  /// println("Bill inkoom".capitalizeNameWordCase()) // outputs Bill Inkoom
  /// ```
  String capitalizeNameWordCase({
    List<String> delimiters = const [' ', '-', '.'],
  }) {
    var capitalizedString = "";
    var prev = '';
    for (var c in toLowerCase().runes) {
      final char = String.fromCharCode(c);
      if (char.trim().isNotEmpty &&
          (prev.isEmpty || delimiters.contains(prev))) {
        capitalizedString += char.toUpperCase();
      } else {
        capitalizedString += char;
      }
      prev = char;
    }
    return capitalizedString.trim();
  }

  String urlEncode() {
    return Uri.encodeComponent(this);
  }

  String base64Image() {
    return "data:image/png;base64,$this";
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  String capitalize() {
    if (isEmpty) {
      return "";
    }
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeAll() {
    if (isEmpty) {
      return "";
    }
    var res = split(" ").map((val) => val.capitalize()).toList().join(" ");
    return res;
  }

  String removeGhanaPrefix() {
    final cropLength = length - 3;

    if (startsWith("233") && cropLength > 0) {
      return "0${substring(3)}"; // Remove the first 3 characters (the prefix)
    } else {
      return this;
    }
  }

  String removeLastChar() {
    var newStr = "";
    if (isNotEmpty) {
      newStr = substring(0, length - 1);
    }

    return newStr;
  }
}

extension NullableStringExtensions on String? {}
