import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loading_screen.dart';
import 'schedule_result_page.dart';

class TaskInputPage extends StatefulWidget {
  final List<dynamic> calendarEvents;

  const TaskInputPage({super.key, required this.calendarEvents});

  @override
  _TaskInputPageState createState() => _TaskInputPageState();
}

class _TaskInputPageState extends State<TaskInputPage> {
  final List<Map<String, dynamic>> _tasks = [];
  final List<Map<String, dynamic>> _physicalActivities = [];

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Recurring Task'),
                onTap: () {
                  Navigator.pop(context);
                  _addRecurringTask();
                },
              ),
              ListTile(
                title: const Text('One-Time Task'),
                onTap: () {
                  Navigator.pop(context);
                  _addOneTimeTask();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addRecurringTask() {
    final _taskNameController = TextEditingController();
    final _timesController = TextEditingController(text: '1');
    final _daysController = TextEditingController(text: '1');
    final _durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Recurring Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timesController,
                      decoration: const InputDecoration(labelText: 'Times'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('times per'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _daysController,
                      decoration: const InputDecoration(labelText: 'Days'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (e.g., 1 hour)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_taskNameController.text.isNotEmpty &&
                    _timesController.text.isNotEmpty &&
                    _daysController.text.isNotEmpty &&
                    _durationController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add({
                      'type': 'recurring',
                      'name': _taskNameController.text,
                      'frequency': '${_timesController.text} times per ${_daysController.text} days',
                      'duration': _durationController.text,
                    });
                  });
                  Navigator.pop(context);
                  _promptToContinueOrAddMore();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addOneTimeTask() {
    final _taskNameController = TextEditingController();
    final _durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add One-Time Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (e.g., 30 minutes)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_taskNameController.text.isNotEmpty && _durationController.text.isNotEmpty) {
                  setState(() {
                    _tasks.add({
                      'type': 'oneTime',
                      'name': _taskNameController.text,
                      'duration': _durationController.text,
                    });
                  });
                  Navigator.pop(context);
                  _promptToContinueOrAddMore();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _promptToContinueOrAddMore() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Task Added'),
          content: const Text('Would you like to add another task or continue?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addTask();
              },
              child: const Text('Add More'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _promptForPhysicalActivity();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _promptForPhysicalActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Stay Active!'),
          content: const Text('Adding physical activities to your schedule can boost your productivity and health. Would you like to add one?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addPhysicalActivity();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _addPhysicalActivity() {
    final _activityNameController = TextEditingController();
    final _timesController = TextEditingController(text: '1');
    final _daysController = TextEditingController(text: '1');
    final _durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Physical Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _activityNameController,
                decoration: const InputDecoration(labelText: 'Activity Name'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _timesController,
                      decoration: const InputDecoration(labelText: 'Times'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('times per'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _daysController,
                      decoration: const InputDecoration(labelText: 'Days'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (e.g., 1 hour)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_activityNameController.text.isNotEmpty &&
                    _timesController.text.isNotEmpty &&
                    _daysController.text.isNotEmpty &&
                    _durationController.text.isNotEmpty) {
                  setState(() {
                    _physicalActivities.add({
                      'name': _activityNameController.text,
                      'frequency': '${_timesController.text} times per ${_daysController.text} days',
                      'duration': _durationController.text,
                    });
                  });
                  Navigator.pop(context);
                  _promptAddAnotherActivity();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _promptAddAnotherActivity() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Activity Added'),
          content: const Text('Would you like to add another activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addPhysicalActivity();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _submitData() async {
    final payload = {
      'calendarEvents': widget.calendarEvents,
      'tasks': _tasks,
      'physicalActivities': _physicalActivities,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(
          message: 'Creating schedule for tasks to do',
          subMessage: 'Optimizing your task schedule...',
        ),
      ),
    );
    
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/createScheduleUsingDeepseek'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      Navigator.pop(context); // Remove loading screen

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleResultPage(scheduleText: response.body),
          ),
        );
      } else {
        _showErrorDialog('API Error: ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog('Connection Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add a Task'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length + _physicalActivities.length,
              itemBuilder: (context, index) {
                if (index < _tasks.length) {
                  final task = _tasks[index];
                  return ListTile(
                    title: Text(task['name']),
                    subtitle: Text(
                        '${task['type'] == 'recurring' ? 'Recurring' : 'One-Time'} - ${task['duration']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                    ),
                  );
                } else {
                  final activity = _physicalActivities[index - _tasks.length];
                  return ListTile(
                    title: Text(activity['name']),
                    subtitle: Text('${activity['frequency']} - ${activity['duration']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _physicalActivities.removeAt(index - _tasks.length);
                        });
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _submitData,
              child: const Text('Create Schedule'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}