import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceLog {
  String description;
  String type;
  String date;
  String? logId;

  MaintenanceLog(
      {required this.description, required this.type, required this.date});

  MaintenanceLog.fromFirestore(DocumentSnapshot snapshot)
      : description = snapshot['description'] ?? '',
        type = snapshot['type'] ?? '',
        date = snapshot['date'] ?? '',
        logId = snapshot['logId'] {}

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'type': type,
      'date': date,
      'logId': logId
    };
  }
}
