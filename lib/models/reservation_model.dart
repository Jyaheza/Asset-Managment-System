import 'package:cloud_firestore/cloud_firestore.dart';
import '../view_models/cells/dropdown_cell.dart';
import 'tableable.dart';

class Reservations implements Tableable {
  Reservations({
    required this.schoolId,
    required this.name,
    required this.email,
    required this.assetType,
    required this.date
  }): id = '0';

  Reservations.fromFirestore(DocumentSnapshot snapshot)
      : email = snapshot['email'] ?? '',
        assetType = snapshot['assetType'] ?? '',
        name = snapshot['name'] ?? '',
        schoolId = snapshot['userId'] ?? 0,
        date = snapshot['date'] ?? 0,
        id = snapshot.id;

  String assetType;
  String name;
  String email;
  final String id;
  int schoolId;
  DateTime date;

  static final assetTypeOptions = <String>[
    'Laptop',
    'Projector',
    'Calculator',
  ];

  @override
  List<String> header() {
    return ['Request for', 'Email', 'Date Requested', 'Name', 'School ID', 'Actions'];
  }

  @override
  List<Object?> asRow() {
    return [
      DropdownCell(
        value: assetType,
        items: assetTypeOptions,
        updateValue: updateAssetType,
      ),
      email,
      date,
      name,
      schoolId,
      
      
    ];
  }

  void updateAssetType(String? value) {
    if (value != null) {
      assetType = value;
    }
  }
}
