import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/tableable.dart';
import 'package:uuid/uuid.dart';

class Asset implements Tableable {
  Asset({
    String? id,

  })  : category = "Secret",
        description = '',
        serialNum = 0,
        status = '',
        assetType = '',
        assetProfileId = 0,
        externalAccessories = '',
        internalFeatures = '',
        wirelessNIC = '',
        memory = '',
        hardDrive = '',
        processor = '',
        model = '',
        toner = '',
        keyNumber = '',
        keyRoomNumber = '',
        id = id ?? const Uuid().v1();

  Asset.fromFirestore(DocumentSnapshot snapshot)
      : id = snapshot['id'],
        status = snapshot['status'] ?? 'In Inventory',
        description = snapshot['description'] ?? '',
        assetType = snapshot['assetType'],
        assetProfileId = snapshot.data().toString().contains('assetProfileId')
            ? snapshot['assetProfileId']
            : 0,
        serialNum = snapshot.data().toString().contains('serialNum')
            ? snapshot['serialNum']
            : 0,
        //externalAccessories = snapshot['externalAccessories'] ?? '',
        //internalFeatures = snapshot['internalFeatures'] ?? '',
        //wirelessNIC = snapshot['wirelessNIC'] ?? '',
        category = snapshot.data().toString().contains('category')
            ? snapshot['category']
            : '',
        memory = snapshot.data().toString().contains('memory')
            ? snapshot['memory']
            : '',
        hardDrive = snapshot.data().toString().contains('hardDrive')
            ? snapshot['hardDrive']
            : '',
        processor = snapshot.data().toString().contains('processor')
            ? snapshot['processor']
            : '',
        model = snapshot.data().toString().contains('model')
            ? snapshot['model']
            : '',
        toner = snapshot.data().toString().contains('toner')
            ? snapshot['toner']
            : '',
        keyNumber = snapshot.data().toString().contains('keyNumber')
            ? snapshot['keyNumber']
            : '',
        keyRoomNumber = snapshot.data().toString().contains('keyRoomNumber')
            ? snapshot['keyRoomNumber']
            : '';

  late String assetType;
  late int assetProfileId;
  late int serialNum;
  late String status;
  late String externalAccessories;
  late String internalFeatures;
  late String wirelessNIC;
  late String description;
  late String id;
  late String category;
  late String memory;
  late String hardDrive;
  late String processor;
  late String model;
  late String toner;
  late String keyNumber;
  late String keyRoomNumber;

  @override
  // TODO: Change to display description, asset type, category, status, and action.
  List<String> header() {
    return ['Description', 'Asset Type', 'Category', 'Status', 'Action'];
  }

// TODO: Change to display description, asset type, category, status, and action.
  @override
  List<Object?> asRow() {
    return [description, assetType, category, status];
  }

  Map<String, dynamic> toMap() {
    if (assetType == 'Laptop') {
      return <String, dynamic>{
        'id': id,
        'description': description,
        'assetType': assetType,
        'category': category,
        'status': status,
        'assetProfileId': assetProfileId,
        'serialNum': serialNum,
        'memory': memory,
        'model': model,
        'hardDrive': hardDrive,
        'processor': processor,
      };
    } else if (assetType == 'Printer') {
      return <String, dynamic>{
        'id': id,
        'description': description,
        'assetType': assetType,
        'category': category,
        'status': status,
        'assetProfileId': assetProfileId,
        'serialNum': serialNum,
        'model': model,
        'toner': toner
      };
    } else if (assetType == 'Key') {
      return <String, dynamic>{
        'id': id,
        'description': description,
        'assetType': assetType,
        'category': category,
        'status': status,
        'assetProfileId': assetProfileId,
        'keyNumber': keyNumber,
        'keyRoomNumber': keyRoomNumber
      };
    } else {
      return <String, dynamic>{};
    }
  }
}

class ActionCell {
  final VoidCallback onViewMore;
  final VoidCallback onEdit;

  ActionCell({required this.onViewMore, required this.onEdit});

  DataCell toDataCell() {
    return DataCell(Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: onViewMore,
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ],
    ));
  }
}
