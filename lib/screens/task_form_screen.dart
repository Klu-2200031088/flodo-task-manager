// COMPLETE FINAL VERSION

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String selectedStatus = "To-Do";
  DateTime? selectedDate;
  String? selectedBlockedTaskId;

  bool isSaving = false;
  bool isEditMode = false;

  final statusOptions = ["To-Do","In Progress","Done"];


  /// DRAFT STORAGE KEYS

  static const draftTitleKey = "draft_title";
  static const draftDescriptionKey = "draft_description";
  static const draftDateKey = "draft_date";
  static const draftStatusKey = "draft_status";
  static const draftBlockedKey = "draft_blocked";


  /// LOAD DRAFT

  Future<void> loadDraft() async {

    final prefs = await SharedPreferences.getInstance();

    titleController.text =
        prefs.getString(draftTitleKey) ?? "";

    descriptionController.text =
        prefs.getString(draftDescriptionKey) ?? "";

    selectedStatus =
        prefs.getString(draftStatusKey) ?? "To-Do";

    final savedDate =
        prefs.getString(draftDateKey);

    if (savedDate != null) {
      selectedDate = DateTime.parse(savedDate);
    }

    selectedBlockedTaskId =
        prefs.getString(draftBlockedKey);

    setState(() {});
  }


  /// SAVE DRAFT

  Future<void> saveDraft() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        draftTitleKey,
        titleController.text);

    await prefs.setString(
        draftDescriptionKey,
        descriptionController.text);

    if (selectedDate != null) {
      await prefs.setString(
          draftDateKey,
          selectedDate!.toIso8601String());
    }

    await prefs.setString(
        draftStatusKey,
        selectedStatus);

    if (selectedBlockedTaskId != null) {
      await prefs.setString(
          draftBlockedKey,
          selectedBlockedTaskId!);
    }
  }


  Future<void> clearDraft() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }


  /// CIRCULAR DEPENDENCY CHECK

  bool createsCircularDependency(
      String currentTaskId,
      String? blockedTaskId,
      List<Task> allTasks) {

    if (blockedTaskId == null) return false;

    String? nextId = blockedTaskId;

    while (nextId != null) {

      if (nextId == currentTaskId) return true;

      final nextTask = allTasks.firstWhere(
        (task) => task.id == nextId,
        orElse: () => Task(
          id:"",
          title:"",
          description:"",
          dueDate:DateTime.now(),
          status:"To-Do",
        ),
      );

      if (nextTask.id == "") return false;

      nextId = nextTask.blockedBy;
    }

    return false;
  }


  @override
  void initState() {

    super.initState();

    if (widget.task != null) {

      isEditMode = true;

      titleController.text =
          widget.task!.title;

      descriptionController.text =
          widget.task!.description;

      selectedDate =
          widget.task!.dueDate;

      selectedStatus =
          widget.task!.status;

      selectedBlockedTaskId =
          widget.task!.blockedBy;

    } else {

      loadDraft();

    }
  }


  @override
  void dispose() {

    saveDraft();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final taskProvider =
        Provider.of<TaskProvider>(context);

    final allTasks =
        taskProvider.getTasks();

    final existingTasks =
        allTasks.where((task) =>
            widget.task == null ||
            task.id != widget.task!.id)
            .toList();


    /// REMOVE INVALID DEPENDENCY VALUE

    if (selectedBlockedTaskId != null &&
        !existingTasks.any(
            (task) =>
                task.id ==
                selectedBlockedTaskId)) {

      selectedBlockedTaskId = null;
    }


    return Scaffold(

      appBar: AppBar(
        title: Text(
            isEditMode
                ? "Edit Task"
                : "Create Task"),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller:
              titleController,
              decoration:
              const InputDecoration(
                labelText: "Title",
              ),
            ),

            const SizedBox(height:10),

            TextField(
              controller:
              descriptionController,
              decoration:
              const InputDecoration(
                labelText:
                "Description",
              ),
            ),

            const SizedBox(height:10),

            ElevatedButton(

              onPressed: () async {

                final picked =
                await showDatePicker(
                  context:context,
                  firstDate:
                  DateTime.now(),
                  lastDate:
                  DateTime(2100),
                  initialDate:
                  selectedDate ??
                  DateTime.now(),
                );

                if(picked!=null){
                  setState(() {
  selectedDate = picked;
});
                }
              },

              child: Text(
                  selectedDate==null
                      ?"Select Due Date"
                      :selectedDate!
                      .toString()
                      .split(" ")[0]),
            ),

            const SizedBox(height:10),

            DropdownButtonFormField(

              initialValue:selectedStatus,

              items:statusOptions
                  .map((status)=>
                  DropdownMenuItem(
                    value:status,
                    child:Text(status),
                  ))
                  .toList(),

              onChanged:(value){
                setState(() {
  selectedStatus = value!;
});
              },
            ),

            const SizedBox(height:20),

            existingTasks.isEmpty

                ?const Text(
              "No tasks available for dependency",
              style:
              TextStyle(
                  color:Colors.grey),
            )

                :DropdownButtonFormField<String>(

              initialValue:
              selectedBlockedTaskId,

              hint:
              const Text(
                  "Blocked By (Optional)"),

              items:
              existingTasks.map((task){

                return DropdownMenuItem(
                  value:task.id,
                  child:Text(task.title),
                );

              }).toList(),

              onChanged:(value){
                setState(() {
  selectedBlockedTaskId = value;
});
              },
            ),

            const SizedBox(height:20),

            ElevatedButton(

              onPressed:isSaving
                  ?null
                  :() async {

                if(titleController.text.isEmpty||
                    descriptionController.text.isEmpty||
                    selectedDate==null){

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      const SnackBar(
                          content:
                          Text("Fill all fields")));

                  return;
                }


                if(isEditMode &&
                    createsCircularDependency(
                        widget.task!.id,
                        selectedBlockedTaskId,
                        allTasks)){

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      const SnackBar(
                          content:
                          Text("Circular dependency detected")));

                  return;
                }


                setState(() {
  isSaving = true;
});


                if(isEditMode){

                  await taskProvider.updateTask(

                      Task(
                        id:widget.task!.id,
                        title:titleController.text,
                        description:descriptionController.text,
                        dueDate:selectedDate!,
                        status:selectedStatus,
                        blockedBy:selectedBlockedTaskId,
                      ));

                }else{

                  await taskProvider.addTask(

                      Task(
                        id:
                        const Uuid().v4(),
                        title:titleController.text,
                        description:
                        descriptionController.text,
                        dueDate:selectedDate!,
                        status:selectedStatus,
                        blockedBy:selectedBlockedTaskId,
                      ));
                }


                await clearDraft();

                if (!mounted) return;
                
                setState(() {
  isSaving = false;
});
Navigator.pop(context);
              },

              child: isSaving

    ? const SizedBox(

        height: 18,

        width: 18,

        child: CircularProgressIndicator(

          strokeWidth: 2,

          color: Colors.white,

        ),

      )

    : Text(

        isEditMode

            ? "Update Task"

            : "Save Task",

      ),

),
          ],
        ),
      ),
    );
  }
}