import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/asset_model.dart';
import 'package:ocassetmanagement/models/maintenance_log.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';

class MaintenanceLogPage extends StatefulWidget {
  final Asset asset;

  MaintenanceLogPage({required this.asset});

  @override
  _MaintenanceLogPageState createState() => _MaintenanceLogPageState();
}

class _MaintenanceLogPageState extends State<MaintenanceLogPage> {
  List<MaintenanceLog> maintenanceLogs = [];
  final FirestoreStorage _firestoreStorage = FirestoreStorage();

  @override
  void initState() {
    super.initState();
    _fetchMaintenanceLogs();
  }

  Future<void> _fetchMaintenanceLogs() async {
    List<MaintenanceLog> logs =
        await _firestoreStorage.getMaintenanceLogs(widget.asset);
    setState(() {
      maintenanceLogs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Log for ${widget.asset.description}'),
      ),
      body: maintenanceLogs.isEmpty
          ? const Center(child: Text('No logs yet.'))
          : ListView.builder(
              itemCount: maintenanceLogs.length,
              itemBuilder: (context, index) {
                final log = maintenanceLogs[index];
                return MaintenanceItem(
                  log: log,
                  asset: widget.asset,
                  onDelete:
                      _fetchMaintenanceLogs, // Callback to refresh the list after deletion
                  onEdit:
                      _fetchMaintenanceLogs, // Callback to refresh the list after edit
                );
              },
            ),
    );
  }
}

class MaintenanceItem extends StatelessWidget {
  final MaintenanceLog log;
  final Asset asset;
  final Function onDelete;
  final Function onEdit;

  final FirestoreStorage _firestoreStorage = FirestoreStorage();

  MaintenanceItem(
      {super.key,
      required this.log,
      required this.asset,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(log.description),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              log.type,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              log.date,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editLog(context, log),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmDelete(context, log),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editLog(BuildContext context, MaintenanceLog log) async {
    TextEditingController descriptionController =
        TextEditingController(text: log.description);
    // Parse the date string back to a DateTime object for editing
    DateTime selectedDate = DateTime.parse(log.date);
    String selectedType = log.type;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Log'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: <String>['Preventative', 'Emergency', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedType = newValue!;
                  },
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextButton(
                  child: Text(selectedDate.toIso8601String().split('T')[0]),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != selectedDate) {
                      selectedDate = picked;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                log.type = selectedType;
                log.description = descriptionController.text;
                // Convert the DateTime back to a String in the desired format
                log.date = selectedDate.toIso8601String();
                await _firestoreStorage.updateMaintenanceLog(asset, log);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close the dialog
                onEdit(); // Refresh the maintenance logs list
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                  foregroundColor: Colors.white),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, MaintenanceLog log) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this log?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await _firestoreStorage.removeMaintenanceLog(asset, log);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close the confirm dialog
                onDelete(); // Refresh the maintenance logs list
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                  foregroundColor: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
