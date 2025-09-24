import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> _tasks = [
    "Wake at 5 am",
    "Meditate for 20 minutes",
    "Go for a walk",
    "Make a healthy breakfast",
    'Start coding for 5 hours',
  ];

  String? _lastDeletedTask;
  int? _lastDeletedIndex;
  final Set<int> _completedTasks = {};

  Future<void> _confirmDelete(BuildContext context, int index) async {
    final confirm_deletion = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Do you really want to delete '${_tasks[index]}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm_deletion == true) {
      _deleteTask(index);
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _lastDeletedTask = _tasks[index];
      _lastDeletedIndex = index;
      _tasks.removeAt(index);
      _completedTasks.remove(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Task deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF9F2F8,
      ), // light background like screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Task Manager",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _tasks.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final task = _tasks.removeAt(oldIndex);
            _tasks.insert(newIndex, task);
          });
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: ValueKey(task),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              await _confirmDelete(context, index);
              return false; // only delete after dialog confirms
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              key: ValueKey("card_$task"),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.drag_handle),
                title: Text(
                  task,
                  style: TextStyle(
                    decoration: _completedTasks.contains(index)
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                trailing: Checkbox(
                  value: _completedTasks.contains(index),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _completedTasks.add(index);
                      } else {
                        _completedTasks.remove(index);
                      }
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
