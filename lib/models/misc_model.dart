import 'package:cloud_firestore/cloud_firestore.dart';
import 'tableable.dart';

class Misc implements Tableable {
  Misc({this.name = ''});

  Misc.fromFirestore(DocumentSnapshot snapshot) : name = snapshot['name'] ?? '';
  String name;

  @override
  List<String> header() {
    return ['Name', 'Actions'];
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
