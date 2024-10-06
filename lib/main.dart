import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: Text('Task Manager'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(hintText: 'Enter task name'),
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem(
                            child: Text(priority),
                            value: priority,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: _tasks[index].isCompleted,
                      onChanged: (value) {
                        _toggleTaskCompletion(index);
                      },
                    ),
                    title: Text(
                      _tasks[index].name,
                      style: TextStyle(
                          decoration: _tasks[index].isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none),
                    ),
                    subtitle: Text('Priority: ${_tasks[index].priority}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
