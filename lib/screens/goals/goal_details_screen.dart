import 'package:flutter/material.dart';

enum Target { daily, monthly, halfYear }

class GoalDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  final Target currentTarget;

  const GoalDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.currentTarget,
  });

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Target _selectedTarget;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedTarget = widget.currentTarget;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Target>(
              value: _selectedTarget,
              onChanged: (newValue) {
                setState(() {
                  _selectedTarget = newValue!;
                });
              },
              items: [
                DropdownMenuItem<Target>(
                  value: Target.daily,
                  child: Text('Daily'),
                ),
                DropdownMenuItem<Target>(
                  value: Target.monthly,
                  child: Text('Monthly'),
                ),
                DropdownMenuItem<Target>(
                  value: Target.halfYear,
                  child: Text('Half a Year'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Target',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save changes
                String newTitle = _titleController.text;
                String newDescription = _descriptionController.text;
                // Do something with the newTitle, newDescription, _selectedTarget
                // For example, you can send them to a database or update an existing object
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GoalDetailsScreen(
      title: 'Exercise',
      description: 'Do daily exercise for 30 minutes.',
      currentTarget: Target.daily,
    ),
  ));
}
