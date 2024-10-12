import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoterr/providers/quote_provider.dart';
import 'package:share_plus/share_plus.dart'; // Import the Share package
import '../models/quote.dart';

class BookmarkedQuotesScreen extends StatefulWidget {
  const BookmarkedQuotesScreen({super.key});

  @override
  BookmarkedQuotesScreenState createState() => BookmarkedQuotesScreenState();
}

class BookmarkedQuotesScreenState extends State<BookmarkedQuotesScreen> {
  int currentIndex = 1; // Set current index to 1 for BookmarkedQuotesScreen

  @override
  void initState() {
    super.initState();
    // Load the bookmarked quotes from the database
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    quoteProvider.loadBookmarkedQuotes(); // Load bookmarks when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final bookmarkedQuotes = quoteProvider.bookmarkedQuotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Quotes'),
      ),
      body: bookmarkedQuotes.isEmpty
          ? Center(
        child: Text(
          "No Quotes Bookmarked yet!",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      )
          : ListView.builder(
        itemCount: bookmarkedQuotes.length,
        itemBuilder: (context, index) {
          final quote = bookmarkedQuotes[index];
          return _buildQuoteCard(quote, quoteProvider);
        },
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote, QuoteProvider quoteProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote.quote,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '- ${quote.author}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            _buildQuoteActions(quote, quoteProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteActions(Quote quote, QuoteProvider quoteProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.blue),
          onPressed: () {
            // Share the quote and author
            Share.share('${quote.quote} \n- ${quote.author}');
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Show a confirmation dialog before removing
            _showRemoveBookmarkDialog(quote, quoteProvider);
          },
        ),
      ],
    );
  }

  void _showRemoveBookmarkDialog(Quote quote, QuoteProvider quoteProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Bookmark'),
        content: const Text('Are you sure you want to remove this quote from bookmarks?'),
        actions: [
          TextButton(
            onPressed: () {
              quoteProvider.removeBookmark(quote);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}
