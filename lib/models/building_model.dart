import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import '../view_models/cells/dropdown_cell.dart';
import 'room_model.dart';
import 'tableable.dart';

class Building implements Tableable {
  Building({
    required this.name,
    required this.roomNum,
    required this.assetTotal,
    //required this.maintenanceNotes,

  })  : id = '0',
        assets = [],
        rooms = [];

  Building.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : roomNum = snapshot['roomNum'] ?? '',
        assetTotal = snapshot['assetTotal'] ?? '',
        name = snapshot['name'] ?? '',
        rooms =
            snapshot['rooms'].map<String>((room) => room.toString()).toList(),
        assets = [],
        // maintenanceNotes = snapshot['maintenanceNotes'] ?? '',
        id = snapshot.id;

  String name;
  int roomNum;
  int assetTotal;
  //String? maintenanceNotes;
  List<Object> rooms;
  List<Object> assets;
  String id;

  @override
  List<String> header() {
    return ['Name', 'Number of Rooms', "Total Asset's assigned", 'Actions'];
  }

  @override
  List<Object?> asRow() {
    return [
      name,
      roomNum,
      assetTotal,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'roomNum': roomNum,
      'assetTotal': assetTotal
    };
  }
}
