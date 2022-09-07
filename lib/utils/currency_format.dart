class CurrencyFormat {
  static String toNumber(String number) {
    // Replace semua char setelah comma "."
    String noComma = (number).split('.')[0];
    noComma = noComma != '' ? noComma : '0';

    // Replace point ","
    String noPoint = noComma.split(',').join("");
    return noPoint;
  }
}
