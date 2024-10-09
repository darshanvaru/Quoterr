// lib/providers/quote_provider.dart

import 'package:flutter/material.dart';
import '../models/quote.dart'; // Ensure you have this model
import '../services/api_service.dart'; // Import your ApiService

// lib/providers/quote_provider.dart

class QuoteProvider with ChangeNotifier {
  Quote? _quote;
  final List _bookmarkedQuotes = [];
  final ApiService _apiService = ApiService();

  Quote? get quote => _quote;
  List get bookmarkedQuotes => _bookmarkedQuotes;


  // Fetch quote from the API based on the category
  Future fetchQuote(String category) async {
    try {
      _quote = await _apiService.fetchRandomQuote(category);
      notifyListeners();
    } catch (error) {
      // print('---------------------------------------------------------');
      // print('Error fetching quote: $error');
      // print('---------------------------------------------------------');
      _quote = null; // Set quote to null on error
      notifyListeners();
    }
  }

  void addBookmark(Quote quote) {
    if (!_bookmarkedQuotes.contains(quote)) {
      _bookmarkedQuotes.add(quote);
      notifyListeners();
    }
  }


  void removeBookmark(Quote quote) {
    _bookmarkedQuotes.remove(quote);
    notifyListeners();
  }


  Color _backgroundColor = Colors.black;
  Color _textColor = Colors.white;

  Color get backgroundColor => _backgroundColor;
  Color get textColor => _textColor;

  void toggleTheme() {
    if (_backgroundColor == Colors.black) {
      _backgroundColor = Colors.white;
      _textColor = Colors.black;
    } else {
      _backgroundColor = Colors.black;
      _textColor = Colors.white;
    }
    notifyListeners(); // Notify listeners about the change
  }
}
