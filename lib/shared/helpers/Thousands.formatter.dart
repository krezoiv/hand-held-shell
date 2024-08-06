import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  String formatNumber(String number) {
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

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Permitir borrar todo el contenido
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Eliminar todas las comas existentes
    String newText = newValue.text.replaceAll(',', '');

    // Verificar si es un número válido (incluyendo números parciales)
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newText)) {
      return oldValue;
    }

    // Formatear el número
    String formatted = formatNumber(newText);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
