import 'package:cloud_firestore/cloud_firestore.dart';
import 'tableable.dart';

class UserGroup implements Tableable {
  UserGroup({String? name})
      : name = '';

  UserGroup.fromFirestore(DocumentSnapshot snapshot)
      : name = snapshot['name'] ?? '';

  late String name;

  @override
  List<String> header() {
    return ['Name', 'Type'];
  }


  @override
  List<Object?> asRow() {
    return [
      name,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
  
}
