import 'package:encrypt/encrypt.dart';

encryptAES(plainText) {
  late Encrypted encrypted;
  final key = Key.fromUtf8('iMbd.....23(klMfdgjKt9z2..AdgHGw');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));
  encrypted = encrypter.encrypt(plainText.toString(), iv: iv);
  return encrypted.base64;
}

String decryptAES(String encryptedText) {
  final keyBytes = Key.fromUtf8('iMbd.....23(klMfdgjKt9z2..AdgHGw');
  final iv =
      IV.fromLength(16); // génération d'un vecteur d'initialisation aléatoire
  final encrypter = Encrypter(AES(keyBytes));

  final decrypted = encrypter.decrypt64(encryptedText, iv: iv);

  return decrypted;
}
