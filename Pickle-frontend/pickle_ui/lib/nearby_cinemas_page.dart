import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyCinemasPage extends StatefulWidget {
  @override
  _NearbyCinemasPageState createState() => _NearbyCinemasPageState();
}

class _NearbyCinemasPageState extends State<NearbyCinemasPage> {
  final TextEditingController _pincodeController = TextEditingController();
  final List<DateTime> _selectedDates = [];
  bool _isLoading = false;
  Map<String, dynamic>? _cinemas;
  bool _letUsChooseDate = false;
  String? _source;
  DateTime? _selectedDate;
  bool _isTopSectionVisible = true;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  DateTime getNextToNextSunday() {
    final today = DateTime.now();
    final daysUntilNextSunday = DateTime.sunday - today.weekday;
    final nextSunday = today.add(Duration(days: daysUntilNextSunday));
    return nextSunday.add(Duration(days: 7));
  }

  bool _isValidPincode(String pincode) {
    final regex = RegExp(r'^\d{5}$');
    return regex.hasMatch(pincode);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_selectedDates.contains(selectedDay)) {
        _selectedDates.remove(selectedDay);
      } else {
        if (!_letUsChooseDate) {
          _selectedDates.clear();
        }
        _selectedDates.add(selectedDay);
      }
    });
  }

  void _showCalendarPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Dates'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: getNextToNextSunday(),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) => _selectedDates.contains(day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _onDaySelected(selectedDay, focusedDay);
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, date, _) {
                          return Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                        todayBuilder: (context, date, _) {
                          return Center(
                            child: Tooltip(
                              message: 'Today',
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _letUsChooseDate,
                          onChanged: (value) {
                            setState(() {
                              _letUsChooseDate = value ?? false;
                              if (!_letUsChooseDate) {
                                _selectedDates.clear();
                              }
                            });
                          },
                        ),
                        Text('Let us choose'),
                      ],
                    ),
                    Text(
                      'Select multiple dates, and we will randomly pick one for you.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchCinemas() async {
    if (!_isValidPincode(_pincodeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 5-digit US pincode')),
      );
      return;
    }

    if (_selectedDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one date')),
      );
      return;
    }

    if (_letUsChooseDate && _selectedDates.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select 2 or more dates for "Let us choose"')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _cinemas = null;
      _source = null;
      _isTopSectionVisible = false;
    });

    final selectedDate = _letUsChooseDate
        ? _selectedDates[DateTime.now().millisecondsSinceEpoch % _selectedDates.length]
        : _selectedDates.first;

    setState(() {
      _selectedDate = selectedDate;
    });

    final date = DateFormat('yyyy-MM-dd').format(selectedDate);
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/searchCurrentMoviesInCinemasUsingOpenPerplex'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pincode': _pincodeController.text,
        'date': date,
        'radius': 10,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['cinemas'] != null) {
        setState(() {
          _cinemas = data['cinemas'];
          _source = data['source'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No movies found for the given date and location')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data')),
      );
    }
  }

  String _formatSelectedDate(DateTime date) {
    final day = DateFormat('EEEE').format(date);
    final dateSuffix = _getDateSuffix(date.day);
    return 'Shows near you on $day, ${date.day}$dateSuffix';
  }

  String _getDateSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Cinemas'),
        actions: [
          IconButton(
            icon: Icon(_isTopSectionVisible ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _isTopSectionVisible = !_isTopSectionVisible;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Visibility(
              visible: _isTopSectionVisible,
              child: Column(
                children: [
                  TextField(
                    controller: _pincodeController,
                    decoration: InputDecoration(
                      labelText: 'Enter US Pincode',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Dates',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Tap below to choose dates. Today\'s date is highlighted in light blue.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _showCalendarPopup(context),
                          child: Text('Open Calendar'),
                        ),
                        if (_selectedDates.isNotEmpty) ...[
                          SizedBox(height: 10),
                          Text(
                            'Selected Dates:',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: _selectedDates.map((date) {
                              return Chip(
                                label: Text(DateFormat('yyyy-MM-dd').format(date)),
                                onDeleted: () {
                                  setState(() {
                                    _selectedDates.remove(date);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _searchCinemas,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Search Cinemas'),
                  ),
                ],
              ),
            ),
            if (_isLoading) ...[
              SizedBox(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
              Text(
                _letUsChooseDate
                    ? 'Fetching movies scheduled for ${DateFormat('EEEE, MMMM d, y').format(_selectedDates[DateTime.now().millisecondsSinceEpoch % _selectedDates.length])}...'
                    : 'Fetching movies scheduled for ${DateFormat('EEEE, MMMM d, y').format(_selectedDates.first)}...',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.normal),
              ),
            ],
            if (_cinemas != null && _selectedDate != null) ...[
              SizedBox(height: 20),
              Text(
                _formatSelectedDate(_selectedDate!),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _cinemas!.length,
                  itemBuilder: (context, index) {
                    final cinema = _cinemas!.keys.elementAt(index);
                    final movies = _cinemas![cinema]['movies'];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ExpansionTile(
                        title: Text(
                          cinema,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        children: movies.map<Widget>((movie) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  movie['movie_name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  alignment: WrapAlignment.start,
                                  children: movie['show_timings'].map<Widget>((timing) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        timing,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 8.0),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
              if (_source != null) ...[
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(_source!));
                    },
                    child: Text(
                      'Source: MovieFone',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}