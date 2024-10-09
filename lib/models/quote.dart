// lib/models/quote.dart

class Quote {
  final String quote;  // Property to hold the quote text
  final String author; // Property to hold the author's name

  Quote({required this.quote, required this.author}); // Constructor

  // Factory method to create a Quote object from JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    // print('---------------------------------------------------------');
    // print('quote: ${json['quote']}');
    // print('author: ${json['author']}');
    // print('---------------------------------------------------------');
    return Quote(
      quote: json['quote'],  // Adjust this according to the actual API response key
      author: json['author'], // Adjust this according to the actual API response key
    );

  }
}
