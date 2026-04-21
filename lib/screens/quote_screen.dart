import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoterr/providers/quote_provider.dart';
import 'package:share_plus/share_plus.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  void _fetchQuote() async {
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);

    if (!quoteProvider.quoteLoaded) {
      setState(() {
        _isLoading = true;
      });

      await quoteProvider.fetchQuote();

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _refreshQuote() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<QuoteProvider>(context, listen: false).fetchQuote();

    setState(() {
      _isLoading = false;
    });
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
      Share.share('${quoteProvider.quote!.quote} \n- ${quoteProvider.quote!.author}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final quote = quoteProvider.quote;
    final backgroundColor = quoteProvider.backgroundColor;
    final textColor = quoteProvider.textColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 35.0, bottom: 15),
          child: Text('Quoter', style: TextStyle(fontSize: 30)),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
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
              quote != null
                  ? Text(
                quote.quote,
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : Text('Network Error!',
                style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              quote != null
                  ? Text(
                '- ${quote.author}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              )
                  : const SizedBox.shrink(),
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
            onPressed: _refreshQuote,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
