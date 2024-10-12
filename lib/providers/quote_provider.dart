import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/api_service.dart';
import '../providers/database_helper.dart';

class QuoteProvider with ChangeNotifier {
  Quote? _quote;
  final List<Quote> _bookmarkedQuotes = [];
  final ApiService _apiService = ApiService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Quote? get quote => _quote;
  List<Quote> get bookmarkedQuotes => _bookmarkedQuotes;

  Future fetchQuote(String category) async {
    try {
      _quote = await _apiService.fetchRandomQuote(category);
      notifyListeners();
    } catch (error) {
      _quote = null;
      notifyListeners();
    }
  }

  void addBookmark(Quote quote) {
    if (!_bookmarkedQuotes.contains(quote)) {
      _bookmarkedQuotes.add(quote);
      _databaseHelper.insertQuote(quote);
      notifyListeners();
    }
  }

  void removeBookmark(Quote quote) {
    _bookmarkedQuotes.remove(quote);
    _databaseHelper.deleteQuote(quote);
    notifyListeners();
  }

  Future<void> loadBookmarkedQuotes() async {
    final quotes = await _databaseHelper.getBookmarkedQuotes();
    _bookmarkedQuotes.clear();
    _bookmarkedQuotes.addAll(quotes);
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
    notifyListeners();
  }
}
