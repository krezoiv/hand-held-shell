import 'package:decimal/decimal.dart';

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

  static double parseNumber(String value) {
    if (value.isEmpty) {
      return 0.0;
    }
    // Eliminar todas las comas
    final cleanValue = value.replaceAll(',', '');
    // Intentar convertir a double
    return double.tryParse(cleanValue) ?? 0.0;
  }

  static String sanitizeTextField(String text) {
    if (text.isEmpty) return '';
    return text.replaceAll(RegExp(r'[^0-9.]'), '');
  }

  static Decimal sanitizeAndParse(String value) {
    String sanitized = sanitizeTextField(value);
    if (sanitized.isEmpty) {
      throw FormatException("Empty field");
    }
    return Decimal.parse(sanitized);
  }

  static String formatNumber(String number) {
    String cleanNumber = number.replaceAll(',', '');
    List<String> parts = cleanNumber.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    String formattedInteger = '';
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if ((integerPart.length - 1 - i) % 3 == 0 &&
          i != integerPart.length - 1) {
        formattedInteger = ',$formattedInteger';
      }
      formattedInteger = integerPart[i] + formattedInteger;
    }

    return formattedInteger + decimalPart;
  }
}
