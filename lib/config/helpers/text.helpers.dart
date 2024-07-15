class TextHelpers {
  static String capitalizeFirstLetterOfEachWord(String text) {
    if (text.isEmpty) return text;
    List<String> words = text.split(' ');
    return words
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  static String formatNumberForDisplay(String number) {
    if (number.isEmpty) return '';

    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    integerPart = integerPart.replaceAll(',', '');

    String reversedIntegerPart = integerPart.split('').reversed.join();

    String formattedInteger = '';
    for (int i = 0; i < reversedIntegerPart.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += reversedIntegerPart[i];
    }

    formattedInteger = formattedInteger.split('').reversed.join();

    return formattedInteger + decimalPart;
  }
}
