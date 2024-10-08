import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[900],
          elevation: 0,
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.blueGrey[700]!,
          secondary: Colors.tealAccent,
          surface: Colors.blueGrey[800]!,
          background: Colors.grey[900]!,
        ),
        cardColor: Colors.blueGrey[800],
        dividerColor: Colors.blueGrey[700],
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
        ),
      ),
      home: TaskListScreen(),
    );
  }
}

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task({required this.name, this.isCompleted = false, this.priority = 'Medium'});
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Medium';

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        Task newTask = Task(name: _taskController.text, priority: _selectedPriority);
        _tasks.add(newTask);
        _tasks.sort((a, b) => _comparePriority(a.priority, b.priority));
        _taskController.clear();
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  int _comparePriority(String a, String b) {
    const priorityLevels = {'High': 1, 'Medium': 2, 'Low': 3};
    return priorityLevels[a]!.compareTo(priorityLevels[b]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _taskController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Enter task name',
                            hintStyle: TextStyle(color: Colors.white60),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _selectedPriority,
                        dropdownColor: Theme.of(context).cardColor,
                        items: ['Low', 'Medium', 'High']
                            .map((priority) => DropdownMenuItem(
                                  child: Text(priority, style: TextStyle(color: Colors.white)),
                                  value: priority,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                        underline: Container(),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        child: Icon(Icons.add),
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(12),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Checkbox(
                          value: _tasks[index].isCompleted,
                          onChanged: (value) {
                            _toggleTaskCompletion(index);
                          },
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                        title: Text(
                          _tasks[index].name,
                          style: TextStyle(
                            decoration: _tasks[index].isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: _tasks[index].isCompleted ? Colors.white38 : Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Priority: ${_tasks[index].priority}',
                          style: TextStyle(
                            color: _getPriorityColor(_tasks[index].priority),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            _deleteTask(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.amberAccent;
      case 'Low':
        return Colors.greenAccent;
      default:
        return Colors.white;
    }
  }
}