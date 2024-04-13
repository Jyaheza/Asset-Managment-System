import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import '../view_models/cells/dropdown_cell.dart';
import 'tableable.dart';

class Room implements Tableable {
  Room({
    required this.roomNum,
  })  : id = '0',
        assets = [];

  Room.fromFirestore(DocumentSnapshot snapshot)
      : roomNum = snapshot['roomNum'] ?? '',
        assets = snapshot['assets'] ?? '',
        id = snapshot.id;

  String roomNum;
  List<Object> assets;
  final String id;

  @override
  List<String> header() {
    return ['Room Number', 'Actions'];
  }

  @override
  List<Object?> asRow() {
    return [
      roomNum,
    ];
  }
}
