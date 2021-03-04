import 'dart:math';

String intToHexChar(int a) {
  if (0 <= a && a <= 9) return a.toString();
  if (a == 10) return 'A';
  if (a == 11) return 'B';
  if (a == 12) return 'C';
  if (a == 13) return 'D';
  if (a == 14) return 'E';
  return "F";
}

bool isPrivateKey(String text) {
  if (text.length == 64)
    return true;
  return false;
}

String generateSecretKey() {
  String value = "";
  var rng = Random();
  for (int i = 0; i < 64; i++) value = value + intToHexChar(rng.nextInt(16));
  return value;
}
