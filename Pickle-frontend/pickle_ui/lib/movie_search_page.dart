import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieSearchPage extends StatefulWidget {
  @override
  _MovieSearchPageState createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = false;
  String _query = '';

  Future<void> _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
      _query = query;
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/searchMovieBasedOnDescriptionWithDeepSeek'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query, 'exclude': ''}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _movies = List<Map<String, dynamic>>.from(data['movies']);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch movies')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch at Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isLoading) ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        'Fetching suggestions...',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$_query',
                        style: TextStyle(fontSize: 14, fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_movies.isNotEmpty) ...[
              Text(
                '$_query',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _movies.length,
                  itemBuilder: (context, index) {
                    final movie = _movies[index];
                    return Card(
                      child: ListTile(
                        title: Text(movie['movie']),
                        subtitle: Text(movie['intro']),
                        trailing: Text(movie['release_date']),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _movies.clear();
                    _query = '';
                  });
                },
                child: Text('Search Again'),
              ),
            ] else ...[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter a plot description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        _searchMovies(_controller.text);
                      },
                child: Text('Search Movies'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
