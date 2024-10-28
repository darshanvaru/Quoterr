// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/quote.dart';

class ApiService {
  final String apiKey = 'Ds2uIswIeYTU3yvVoPdMdENmtCSG3TwkDNOx84uj';

  Future fetchRandomQuote(String category) async {
    final url = Uri.parse('https://api.api-ninjas.com/v1/quotes?category=$category');

    print("----------------------------------------------------");
    print(url);
    print("----------------------------------------------------");

    final response = await http.get(url, headers: {
      'X-Api-Key': apiKey,
    });

    print("----------------------------------------------------");
    print("Reponce sent");
    print(response);
    print("----------------------------------------------------");

    if (response.statusCode == 200) {
      print("----------------------------------------------------");
      print("Response status: 200 OK");
      print("Response body: ${response.body}");
      print("----------------------------------------------------");

      List data = json.decode(response.body);
      if (data.isNotEmpty) {
        return Quote.fromJson(data[0]); // Return the first quote in the response
      } else {
        throw Exception('No quotes found for this category.');
      }
    } else {
      print("----------------------------------------------------");
      print("Failed to fetch quote. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("----------------------------------------------------");
      throw Exception('Failed to load quotes');
    }
  }
}
