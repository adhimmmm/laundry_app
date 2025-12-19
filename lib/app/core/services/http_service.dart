import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<List<dynamic>> getFaqs() async {
    final response = await http.get(
      Uri.parse('https://6915596b84e8bd126af996e3.mockapi.io/faqs'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data FAQ');
    }
  }
}
