import 'package:intl/intl.dart';

class NumberHelper {
  static NumberFormat currencyFormatter = NumberFormat('###,###,##0.00', 'en');

  static bool isNumeric(String str) {
    if (str == null) return false;
    return double.tryParse(str) != null;
  }

  static String formatAmount(String amount) {
    var a = num.parse(amount);
    var isInteger = a % 1 == 0;
    if (isInteger) {
      return '${a.toInt()}';
    } else {
      return amount;
    }
  }

  static String formatBankCard(String cardNumber) {
    var str = '';
    if (cardNumber.isNotEmpty) {
      if (cardNumber.length >= 4) {
        str = cardNumber.substring(0, 4) + ' ';
        var substring = cardNumber.substring(4);
        str += formatBankCard(substring);
      } else {
        str += cardNumber;
      }
    }
    return str.trimRight();
  }

  static String formatCurrency(dynamic value) {
    if (value == null || value == '') {
      return '0.0';
    }
    var a = value.toString();
    if (a.length - (a.lastIndexOf('.') - 1) < 2) {}

    if (value is String) value = double.parse(value);

    return currencyFormatter.format(value);
  }

  static String formatNum(double num, int fractionDigits) {
    if ((num.toString().length - num.toString().lastIndexOf('.') - 1) <
        fractionDigits) {
      //小数点后有几位小数
      return num.toStringAsFixed(fractionDigits)
          .substring(0, num.toString().lastIndexOf('.') + fractionDigits + 1)
          .toString();
    } else {
      return num.toString()
          .substring(0, num.toString().lastIndexOf('.') + fractionDigits + 1)
          .toString();
    }
  }
}