import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: TodoHomeScreen(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    ),
  ),
);

class TodoItem {
  String title;
  bool priority;
  bool completed;

  TodoItem(this.title, this.priority, this.completed);
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final List<TodoItem> todos = [];

  int get completedCount => todos.where((item) => item.completed).length;

  void _showAddTodoDialog() {
    String title = "";
    bool priority = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Create new"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter title here'),
                onChanged: (v) => setDialogState(() => title = v),
              ),
              CheckboxListTile(
                title: const Text("Priority"),
                value: priority,
                onChanged: (v) => setDialogState(() => priority = v ?? false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Close"),
            ),
            FilledButton(
              onPressed: () {
                if (title.trim().isNotEmpty) {
                  setState(() {
                    todos.add(TodoItem(title.trim(), priority, false));
                  });
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TODOs"),
          Text("Completed: $completedCount", style: TextStyle(fontSize: 15)),
        ],
      ),
      actions: [
        FilledButton(onPressed: _showAddTodoDialog, child: Icon(Icons.add)),
      ],
    ),
    body: todos.isEmpty
        ? const Center(
            child: Text(
              "No tasks yet.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                leading: Checkbox(
                  value: todos[index].completed,
                  onChanged: (v) {
                    setState(() {
                      bool isNowCompleted = v ?? false;
                      todos[index].completed = isNowCompleted;
                    });
                  },
                ),
                title: Row(
                  children: [
                    if (todos[index].priority) ...[
                      const Icon(Icons.flag, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Expanded(child: Text(todos[index].title)),
                  ],
                ),
              ),
            ),
          ),
  );
}
