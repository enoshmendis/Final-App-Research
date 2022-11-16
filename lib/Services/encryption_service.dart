import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);

  EncryptionService(this._encrypter);

  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }

  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);

    return _encrypter.decrypt(encrypted, iv: this._iv);
  }
}
