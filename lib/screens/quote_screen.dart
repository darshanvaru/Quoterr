import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoterr/providers/quote_provider.dart';
import 'package:share_plus/share_plus.dart'; // Import the Share package
import 'bookmarked_quotes_screen.dart'; // Import your Bookmark screen here

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  List<String> categories = [
    'Happiness',
    'Love',
    'Success',
    'Life',
    'Inspirational',
    'Alone',
    'Friendship',
    'Freedom',
    'Fear',
    'Family',
    'Funny',
    'Dreams',
    'Education',
    'Change',
    'Beauty',
  ];

  String selectedCategory = 'Life';
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
      _isLoading = true;
    });

    Provider.of<QuoteProvider>(context, listen: false).toggleTheme();
    Provider.of<QuoteProvider>(context, listen: false).fetchQuote(selectedCategory);

    // Waiting till the quote is fetched so Bg changes at perfect sync
    await Provider.of<QuoteProvider>(context, listen: false).fetchQuote(selectedCategory);
    setState(() {
      backgroundColor = (backgroundColor == Colors.white) ? Colors.black : Colors.white;
      textColor = (textColor == Colors.black) ? Colors.white : Colors.black;
      _isLoading = false;
    });
  }

  void _changeCategoryDialogBox() async {
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

  void _shareQuote() {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    if (quoteProvider.quote != null) {
      Share.share('${quoteProvider.quote!.quote} - ${quoteProvider.quote!.author}');
    }
  }

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
        foregroundColor: backgroundColor == Colors.black ? Colors.white : Colors.black,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quote!.quote,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _shareQuote,
            child: const Icon(Icons.share),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _fetchQuote,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(selectedCategory, style: TextStyle(fontSize: 20, color: textColor),),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: _changeCategoryDialogBox,
                child: const Icon(Icons.category),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookmarkedQuotesScreen()),
            );
          }
        },
      ),
    );
  }
}