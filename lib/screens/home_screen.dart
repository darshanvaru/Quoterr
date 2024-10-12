import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bookmarked_quotes_screen.dart';
import 'quote_screen.dart';
import '../providers/quote_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const QuoteScreen(),
    const BookmarkedQuotesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final backgroundColor = quoteProvider.backgroundColor;
    final textColor = quoteProvider.textColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: backgroundColor,
        selectedItemColor: textColor,
        unselectedItemColor: textColor.withOpacity(0.5),
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
        onTap: _onItemTapped,
      ),
    );
  }
}
