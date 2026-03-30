import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/task_provider.dart';
import '../models/task_model.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String searchQuery = "";
  Timer? _debounce;
  String selectedStatusFilter = "All";

  final List<String> statusOptions = [
    "All",
    "To-Do",
    "In Progress",
    "Done"
  ];

  /// Highlight matching search text
  Widget highlightText(String text) {

    if (searchQuery.isEmpty) {
      return Text(text);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(text);
    }

    final startIndex = lowerText.indexOf(lowerQuery);
    final endIndex = startIndex + lowerQuery.length;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [

          TextSpan(text: text.substring(0, startIndex)),

          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),

          TextSpan(text: text.substring(endIndex)),

        ],
      ),
    );
  }

  /// Status color badges
  Color getStatusColor(String status) {

    switch (status) {

      case "To-Do":
        return Colors.orange;

      case "In Progress":
        return Colors.blue;

      case "Done":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {

    _debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final taskProvider = Provider.of<TaskProvider>(context);

    List<Task> tasks = taskProvider.getTasks();


    /// Search + Filter Logic

    tasks = tasks.where((task) {

      final matchesSearch =
          task.title.toLowerCase()
              .contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedStatusFilter == "All" ||
              task.status == selectedStatusFilter;

      return matchesSearch && matchesStatus;

    }).toList();


    return Scaffold(

      appBar: AppBar(
        title: const Text("Flodo Task Manager"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// SEARCH FIELD

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(

              decoration: const InputDecoration(
                labelText: "Search by title",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),

              onChanged: (value) {

                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                _debounce = Timer(
                  const Duration(milliseconds: 300),
                      () {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                );

              },
            ),
          ),


          /// STATUS FILTER

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField(
  initialValue: selectedStatusFilter,

              items: statusOptions.map((status) {

                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedStatusFilter = value!;
                });

              },
            ),
          ),

          const SizedBox(height: 10),


          /// TASK LIST

          Expanded(

            child: tasks.isEmpty

                ? const Center(
              child: Text("No matching tasks found"),
            )

                : ListView.builder(

              itemCount: tasks.length,

              itemBuilder: (context, index) {

                Task task = tasks[index];


                /// BLOCKED TASK LOGIC

                bool isBlocked = false;

                if (task.blockedBy != null) {

                  final blockingTask =
                  taskProvider.getTasks().firstWhere(
                        (t) => t.id == task.blockedBy,
                    orElse: () => task,
                  );

                  if (blockingTask.status != "Done") {
                    isBlocked = true;
                  }
                }


                return Opacity(

                  opacity: isBlocked ? 0.4 : 1,

                  child: AnimatedContainer(

                    duration: const Duration(milliseconds: 250),

                    child: AnimatedScale(
  scale: 1,
  duration:
      const Duration(milliseconds: 300),
  child: Card(

                      margin: const EdgeInsets.all(10),

                      child: ListTile(

                        /// EDIT TASK ON TAP

                        /// EDIT TASK ON TAP

onTap: () {

  Navigator.push(

    context,

    PageRouteBuilder(

      transitionDuration:

          const Duration(milliseconds: 400),

      pageBuilder: (_, __, ___) =>

          TaskFormScreen(task: task),

      transitionsBuilder:

          (_, animation, __, child) {

        return SlideTransition(

          position: Tween<Offset>(

            begin: const Offset(1, 0),

            end: Offset.zero,

          ).animate(animation),

          child: child,

        );

      },

    ),

  );

},

title: highlightText(task.title),

subtitle: Column(

  crossAxisAlignment:

      CrossAxisAlignment.start,

  children: [

    Text(task.description),

    const SizedBox(height: 6),

    Chip(

      avatar: const Icon(

        Icons.calendar_today,

        size: 16,

      ),

      label: Text(

        task.dueDate

            .toString()

            .split(' ')[0],

      ),

    ),

    const SizedBox(height: 6),

    Container(

      padding:

          const EdgeInsets.symmetric(

        horizontal: 8,

        vertical: 4,

      ),

      decoration: BoxDecoration(

        color: getStatusColor(

            task.status),

        borderRadius:

            BorderRadius.circular(8),

      ),

      child: Text(

        task.status,

        style: const TextStyle(

          color: Colors.white,

          fontSize: 12,

        ),

      ),

    ),

  ],

),

trailing: Row(

  mainAxisSize: MainAxisSize.min,

  children: [

    if (isBlocked)

      const Icon(

        Icons.lock,

        color: Colors.grey,

      ),

    IconButton(

      icon: const Icon(Icons.delete),

      onPressed: () {

        final deletedTask = task;

        taskProvider.deleteTask(task.id);

        ScaffoldMessenger.of(context)

            .showSnackBar(

          SnackBar(

            content: Text(

                "${task.title} deleted"),

            duration:

                const Duration(seconds: 5),

            action: SnackBarAction(

              label: "UNDO",

              onPressed: () {

                taskProvider.addTask(

                    deletedTask);

              },

            ),

          ),

        );

      },

    ),

  ],

),

),

),

),
                  )
);
                

},

),

),

],

),


floatingActionButton:

TweenAnimationBuilder(

  tween:

      Tween(begin: 0.0, end: 1.0),

  duration:

      const Duration(milliseconds: 500),

  builder:

      (context, value, child) {

    return Transform.scale(

      scale: value,

      child: child,

    );

  },

  child: FloatingActionButton(

    onPressed: () {

      Navigator.push(

        context,

        PageRouteBuilder(

          transitionDuration:

              const Duration(

                  milliseconds: 400),

          pageBuilder:

              (_, __, ___) =>

                  const TaskFormScreen(),

          transitionsBuilder:

              (_, animation, __, child) {

            return SlideTransition(

              position:

                  Tween<Offset>(

                begin:

                    const Offset(1, 0),

                end: Offset.zero,

              ).animate(animation),

              child: child,

            );

          },

        ),

      );

    },

    child: const Icon(Icons.add),

  ),

),

    );
  }
}