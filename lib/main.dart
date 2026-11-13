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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TODOs"),
          Text(
            "Completed: $completedCount",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () {
            bool addModalPriority = false;
            String addModalTitle = "";
            showDialog(
              context: context,
              builder: (dialogContext) => StatefulBuilder(
                builder: (context, setDialogState) => AlertDialog(
                  title: Text("Create new"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter title here',
                        ),
                        onChanged: (v) =>
                            setDialogState(() => addModalTitle = v),
                      ),
                      CheckboxListTile(
                        title: Text("Priority"),
                        value: addModalPriority,
                        onChanged: (v) {
                          setDialogState(() => addModalPriority = v ?? false);
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text("Close"),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (addModalTitle.isNotEmpty) {
                          setState(() {
                            todos.add(
                              TodoItem(addModalTitle, addModalPriority, false),
                            );
                          });
                          Navigator.pop(dialogContext);
                        }
                      },
                      child: Text("Create"),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ],
    ),
    body: ListView.builder(
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
