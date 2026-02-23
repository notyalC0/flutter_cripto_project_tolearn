import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_app/config/app.settings.dart';
import 'package:intl/intl.dart';

class Formatters {
  static String moeda(AppSettings settings, double valor) {
    return settings.real.format(valor);
  }

  static double moedaToDouble(CurrencyTextInputFormatter formatter) {
    return formatter.getUnformattedValue().toDouble();
  }

  static String formatCurrency(AppSettings settings, double valor) {
    final format = NumberFormat.currency(
      locale: settings.localeCode.replaceAll('_', '-'),
      name: settings.symbol,
      decimalDigits: 2,
    );

    return format.format(valor);
  }
}
