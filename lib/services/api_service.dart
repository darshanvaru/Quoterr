// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quote.dart';

class ApiService {
  final String apiKey = 'Ds2uIswIeYTU3yvVoPdMdENmtCSG3TwkDNOx84uj';

  Future fetchRandomQuote(String category) async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category');

    final response = await http.get(url, headers: {
      'X-Api-Key': apiKey,
    });

    if (response.statusCode == 200) {

      List data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Quote.fromJson(data[0]); // Return the first quote in the response
      } else {
        throw Exception('No quotes found for this category.');
      }
    } else {
      throw Exception('Failed to load quotes');
    }
  }
}
