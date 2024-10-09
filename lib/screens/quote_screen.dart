// lib/screens/quote_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoterr/providers/quote_provider.dart';
import 'bookmarked_quotes_screen.dart'; // Import your Bookmark screen here

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  List<String> categories = [
    'random',
    'happiness',
    'love',
    'success',
    'life',
    'inspirational',
    'alone',
    'attitude',
    'courage',
    'friendship',
    'freedom',
    'fear',
    'health',
    'family',
    'funny',
    'dreams',
    'education',
    'change',
    'beauty',
    'art',
    'government',
  ];

  String selectedCategory = 'success';
  Color backgroundColor = Colors.black;
  Color textColor = Colors.white;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  void _fetchQuote() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    Provider.of<QuoteProvider>(context, listen: false).toggleTheme();
    Provider.of<QuoteProvider>(context, listen: false).fetchQuote(selectedCategory);

    // Fetch the quote
    await Provider.of<QuoteProvider>(context, listen: false).fetchQuote(selectedCategory);

    // Change the background and text colors after fetching the quote
    setState(() {
      backgroundColor = (backgroundColor == Colors.white) ? Colors.black : Colors.white;
      textColor = (textColor == Colors.black) ? Colors.white : Colors.black;
      _isLoading = false; // Set loading state to false
    });
  }


  void _changeCategory() async {
    final String? newCategory = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a Category'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Adjust height for more items
            child: ListView(
              children: categories.map((category) {
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    Navigator.of(context).pop(category);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    if (newCategory != null) {
      setState(() {
        selectedCategory = newCategory; // Update selected category
      });
      _fetchQuote(); // Fetch new quote for selected category
    }
  }

  void _bookmarkQuote() {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    if (quoteProvider.quote != null) {
      quoteProvider.addBookmark(quoteProvider.quote!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote bookmarked!')),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final quote = quoteProvider.quote;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 35.0, bottom: 15),
          child: Text('Quoter', style: TextStyle(fontSize: 30)),
        ),
        backgroundColor: backgroundColor == Colors.black ? Colors.black : Colors.white,
        foregroundColor: backgroundColor == Colors.black ? Colors.white : Colors.black, // Change text color
      ),
      body: Center(
        child: _isLoading // Check loading state
            ? const CircularProgressIndicator() // Show loading indicator
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote!.quote, // Ensure quote is not null
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '- ${quote.author}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _bookmarkQuote,
                child: const Text('Bookmark Quote'),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _fetchQuote,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _changeCategory,
            child: const Icon(Icons.category),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor == Colors.black ? Colors.black : Colors.white, // Change navbar color
        selectedItemColor: backgroundColor == Colors.black ? Colors.white : Colors.black, // Selected item color
        unselectedItemColor: backgroundColor == Colors.black ? Colors.grey : Colors.black54, // Unselected item color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0: // Home
              break;
            case 1: // Bookmarks
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkedQuotesScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
