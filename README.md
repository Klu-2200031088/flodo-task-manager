# 📱 Flodo Task Manager – Flutter Assignment

This project is a **Task Management mobile application built using Flutter** as part of the Flodo AI Take-Home Assignment.

The objective of this application was not just to implement CRUD operations, but to design a structured and usable task workflow system that supports:

• task dependencies  
• persistent storage  
• smooth UI interactions  
• draft recovery  
• search and filtering  
• safe deletion with undo  
• realistic async save behaviour  

This README explains both **how the application works** and **why specific technical decisions were made during development**.


---

# 🎯 Project Objective

The assignment required building a Flutter application with:

✅ structured task data  
✅ dependency logic between tasks  
✅ persistent storage  
✅ search functionality  
✅ filtering support  
✅ draft recovery  
✅ simulated async save delay  
✅ clean and responsive UI  

I implemented the application using:

- Flutter (UI framework)
- Provider (state management)
- Hive (local database persistence)


---

# 🧱 Task Data Model

Each task includes:

• Title  
• Description  
• Due Date  
• Status (To-Do / In Progress / Done)  
• Blocked By (optional dependency on another task)

The **Blocked By** feature allows one task to depend on another before it becomes actionable. This makes the app behave more like a lightweight workflow manager rather than a simple checklist.


---

# ✏️ Task Creation and Editing

Users can create and edit tasks through a structured form containing:

• title input  
• description input  
• due date picker  
• status dropdown  
• dependency selector  

The form also supports **draft persistence** if the user leaves before saving.


---

# 🔒 Dependency-Based Task Locking

If Task B depends on Task A:

Task B remains visually disabled until Task A is marked **Done**.

Additional safeguards implemented:

✅ self-dependency prevention  
✅ circular dependency detection  
✅ deleted dependency safety handling  

These checks maintain correct task relationships and prevent invalid workflow states.


---

# 💾 Persistent Local Storage

The application uses **Hive** as a lightweight local database.

Hive was chosen because:

• fast read/write performance  
• simple Flutter integration  
• works offline  
• no native configuration required  

All tasks remain saved even after restarting the application.


---

# 📝 Draft Recovery Support

If a user starts creating a task and leaves the screen before saving:

their progress is automatically restored when reopening the form.

This prevents accidental data loss and improves usability.


---

# 🔎 Search with Debounced Matching (Stretch Goal)

The search bar filters tasks by title.

Enhancements implemented:

✅ debounced filtering  
✅ highlighted matching characters  
✅ instant UI updates  

This improves performance and readability when the task list grows larger.


---

# 📂 Status-Based Filtering

Tasks can be filtered by:

• To-Do  
• In Progress  
• Done  

This allows users to quickly focus on a specific workflow stage.


---

# 🗑️ Delete with Undo Support

Instead of deleting immediately:

a snackbar appears with an **Undo** option.

This protects against accidental deletion and improves overall user experience.


---

# ⏳ Simulated Network Delay Handling

The assignment required simulating backend-like behaviour during save operations.

Implemented using:

• 2-second async delay  
• loading indicator  
• disabled save button during processing  

This ensures the UI remains responsive while preventing duplicate submissions.


---

# 🎨 UI / UX Improvements

Since Track B focuses heavily on interface quality, additional improvements were added:

✨ animated page transitions  
✨ floating action button entry animation  
✨ dependency lock indicator icon  
✨ status color badges  
✨ Material-3 typography styling  
✨ snackbar recovery interaction  
✨ clean spacing and layout consistency  

The goal was to keep the interface simple but intentional and user-friendly.


---

# 🧠 State Management Choice

**Provider** was selected because:

• lightweight architecture  
• clean separation between UI and logic  
• scalable for medium-sized Flutter apps  
• easy integration with Flutter widgets  

TaskProvider handles:

• task creation  
• task updates  
• deletion  
• filtering  
• dependency validation  
• UI refresh notifications


---

# 🛡️ Dependency Integrity Protection

Additional validation beyond assignment requirements:

✅ prevents selecting a task as its own dependency  
✅ prevents circular dependency chains  
✅ prevents invalid references after deletion  

These checks help maintain consistent task relationships.


---



# ⚙️ How to Run the Project

Clone repository: git clone https://github.com/Klu-2200031088/flodo-task-manager.git

Move into project directory: cd flodo-task-manager

Install dependencies: flutter pub get

Run application: flutter run

Build release APK: flutter build apk --release




---

# 🧭 Track Selection

Track B – Mobile Specialist

The application uses local persistence instead of a backend service and focuses strongly on UI responsiveness and interaction quality.


---

# ⭐ Stretch Goal Implemented

Debounced autocomplete search with highlighted matching text inside task titles.


---

# 🤖 AI Usage Report

AI tools were used as development assistants for:

• debugging dropdown dependency logic  
• improving UI transitions  
• refining validation structure  
• strengthening edge-case handling  

During development, an incorrect dropdown dependency implementation initially caused duplicate-value errors. This issue was resolved by validating selected dependency values against existing task IDs before rendering dropdown options.

All generated suggestions were reviewed and manually adapted before integration.


---

# 👩‍💻 Author

Bhavya  
KL University


# 📁 Folder Structure Overview
