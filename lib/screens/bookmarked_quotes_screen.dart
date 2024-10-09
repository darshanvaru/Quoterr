import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoterr/providers/quote_provider.dart';
import 'quote_screen.dart'; // Import your QuoteScreen here

class BookmarkedQuotesScreen extends StatefulWidget {
  const BookmarkedQuotesScreen({super.key});

  @override
  BookmarkedQuotesScreenState createState() => BookmarkedQuotesScreenState();
}

class BookmarkedQuotesScreenState extends State<BookmarkedQuotesScreen> {
  int currentIndex = 1; // Set current index to 1 for BookmarkedQuotesScreen

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final bookmarkedQuotes = quoteProvider.bookmarkedQuotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Quotes'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedQuotes.length,
        itemBuilder: (context, index) {
          final quote = bookmarkedQuotes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adds spacing around each card
            elevation: 4, // Adds shadow for a lifted appearance
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16), // Inner padding for the card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.quote,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bold quote text
                  ),
                  const SizedBox(height: 8), // Spacing between quote and author
                  Text(
                    '- ${quote.author}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey), // Gray author text
                  ),
                  const SizedBox(height: 8), // Spacing before delete button
                  Align(
                    alignment: Alignment.centerRight, // Align delete button to the right
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Show a confirmation dialog before removing
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Bookmark'),
                            content: const Text('Are you sure you want to remove this quote from bookmarks?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Remove the quote and close the dialog
                                  quoteProvider.removeBookmark(quote);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Just close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex, // Highlight the current index
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const QuoteScreen()), // Navigate to QuoteScreen
              );
              break;
            case 1: // Bookmarks (current screen)
              break;
          }
        },
      ),
    );
  }
}
