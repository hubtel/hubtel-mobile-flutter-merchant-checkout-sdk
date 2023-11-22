


extension StringExtension on String{
  String generateFormattedPhoneNumber(){
  if (startsWith("0")){
  return "233${substring(1)}";
  }
  return this;
  }
}

extension CardFormattingHelper on String {
  String middle({int start = 6, int end = -4}) {
    if (length < 6) {
      return '';
    }

    // Calculate the actual start and end indices based on negative values.
    start = start >= 0 ? start : length + start;
    end = end >= 0 ? end : length + end;

    // Ensure start is not less than 0 and end is not greater than the string length.
    start = start.clamp(0, length - 1);
    end = end.clamp(0, length);

    return substring(start, end);
  }

  String getExpiryMonth(){
    return split("/").first;
  }

  String getExpiryYear(){
    return split("/").last;
  }

  (String?, String?) getExpiryInfo() {
    if (!contains('/')) {
      return (null, null);
    }

    List<String> splitExpiry = split('/');
    String expiryMonth = splitExpiry[0];
    String expiryYear = splitExpiry[1];

    return (expiryMonth, expiryYear);
  }


}