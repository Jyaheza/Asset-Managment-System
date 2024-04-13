import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'tableable.dart';

class Vendor implements Tableable {
  Vendor({String? vendorId})
      : vendorId = vendorId ?? _uuid.v1(),
        name = '',
        type = '';

  Vendor.fromFirestore(DocumentSnapshot snapshot)
      : name = snapshot['name'] ?? '',
        type = snapshot['type'] ?? 0,
        vendorId = snapshot['vendorId'] ?? snapshot.id;

  late String name;
  late String type;
  late String vendorId;
  static const _uuid = Uuid();


  @override
  List<String> header() {
    return ['Name', 'Type', 'Actions'];
  }

  @override
  List<Object?> asRow() {
    return [
      name,
      type,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vendorId': vendorId,
      'name': name,
      'type': type,
    };
  }
  
}
