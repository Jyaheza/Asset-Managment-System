import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import '../view_models/cells/dropdown_cell.dart';
import 'tableable.dart';

class CheckedOut implements Tableable {
  CheckedOut({
    required this.schoolId,
    required this.name,
    required this.email,
    required this.asset,
  }) : id = '0';

  CheckedOut.fromFirestore(DocumentSnapshot snapshot)
      : email = snapshot['email'] ?? '',
        asset = snapshot['assetType'] ?? '',
        name = snapshot['name'] ?? '',
        schoolId = snapshot['userId'] ?? 0,
        id = snapshot.id;

  Object asset;
  String name;
  String email;
  final String id;
  int schoolId;

  @override
  List<String> header() {
    return ['School ID', 'Name', 'Email', 'Asset'];
  }

  @override
  List<Object?> asRow() {
    return [schoolId, name, email, asset];
  }
}
