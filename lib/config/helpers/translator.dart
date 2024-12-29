import 'package:translator/translator.dart';

class Translator {
  static Future<String> translate(String input) async {
    try {
      final translator = GoogleTranslator();

      var translation = await translator.translate(input, to: 'en');

      return translation.text;
    } catch (e) {
      throw Exception();
    }
  }
}
