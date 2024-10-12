class Quote {
  final String quote;
  final String author;

  Quote({required this.quote, required this.author});

  Map<String, dynamic> toMap() {
    return {
      'quote': quote,
      'author': author,
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      quote: map['quote'],
      author: map['author'],
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'],
      author: json['author'],
    );
  }
}
