import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocassetmanagement/models/tableable.dart';

class Person implements Tableable {
  Person({String? name, String? email, int? schoolId})
      : name = name ?? '',
        email = email ?? '',
        schoolId = schoolId ?? 0;

  Person.fromFirestore(DocumentSnapshot snapshot)
      : name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        schoolId = snapshot['schoolId'] ?? 0;

  late String name;
  late String email;
  late int schoolId;

  get personName => name;
  get personEmail => email;
  get personSchoolId => schoolId;

  @override
  List<String> header() {
    return ['Name', 'Email', 'School ID'];
  }

  @override
  List<Object?> asRow() {
    return [name, email, schoolId];
  }
}
