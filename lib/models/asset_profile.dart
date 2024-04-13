import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AssetProfile {
  AssetProfile({String? id})   // DocumentSnapshot snapshot(?)
      : assetTypeId = 0,
        name = '',
        model = '',
        modelNum = 0,
        domain = '',
        accessories = '',
        internalFeatures = '',
        manufacturer = '',
        memory = '',
        hasLease = false,
        hasWarranty = false,
        processor = '',
        hardDrive = '',
        keyRoom = 0,
        keyNum = 0,
        description = '',
        id = id ?? _uuid.v1();

        AssetProfile.fromFirestore(DocumentSnapshot snapshot)
        :
        assetTypeId = snapshot['assetTypeId'] ?? 0,
        name = snapshot['name'] ?? '',
        model = snapshot['model'] ?? '',
        modelNum = snapshot['modelNum'] ?? 0,
        domain = snapshot['domain'] ?? '',
        description = snapshot['description'] ?? '',
        accessories = snapshot['accessories'] ?? '',
        internalFeatures = snapshot['internalFeatures'] ?? '',
        manufacturer = snapshot['manufacturer'] ?? '',
        hasLease = snapshot['hasLease'] ?? false,
        hasWarranty = snapshot['hasWarranty'] ?? false,
        memory = snapshot['memory'] ?? '',
        processor = snapshot['processor'] ?? '',
        hardDrive = snapshot['hardDrive'] ?? '',
        keyRoom = snapshot['keyRoom'] ?? 0,
        keyNum = snapshot['keyNum'] ?? 0,
        id = snapshot.id;


  late String model;
  late int assetTypeId;
  late int userGroupId;
  late String name;
  static const _uuid = Uuid();
  late String description;
  late final String id;
  late String domain;
  late String manufacturer;
  late bool hasWarranty;
  late bool hasLease;
  late String memory;
  late String processor;
  late int modelNum;
  late String hardDrive;
  late int keyRoom;
  late int keyNum;
  late String accessories;
  late String internalFeatures;
}