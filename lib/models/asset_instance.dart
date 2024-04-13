import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocassetmanagement/models/tableable.dart';
import 'package:uuid/uuid.dart';

class AssetInstance implements Tableable {
  AssetInstance({String? id}) // DocumentSnapshot snapshot(?)
      : assetType = '',
        assetProfileId = 0,
        serialNum = 0,
        status = '',
        userGroup = '',
        description = '',
        externalAccessories = '',
        internalFeatures = '',
        wirelessNIC = '',
        id = id ?? _uuid.v1();

  //        AssetInstance({
  //   required this.assetType,
  //   required this.assetProfileId,
  //   required this.serialNum,
  //   required this.userGroup,
  // }): id = '0';

  AssetInstance.fromFirestore(DocumentSnapshot snapshot)
      : assetProfileId = snapshot['assetProfileId'] ?? 0,
        assetType = snapshot['assetTypeId'] ?? '',
        serialNum = snapshot['serialNum'] ?? 0,
        status = snapshot['status'] ?? '',
        userGroup = snapshot['userGroup'] ?? '',
        description = snapshot['description'] ?? '',
        externalAccessories = snapshot['externalAccessories'] ?? '',
        internalFeatures = snapshot['internalFeatures'] ?? '',
        wirelessNIC = snapshot['wirelessNIC'] ?? '',
        id = snapshot.id;
  late String assetType;
  late int assetProfileId;
  late int serialNum;
  late String status;
  late String userGroup;
  late String externalAccessories;
  late String internalFeatures;
  late String wirelessNIC;
  static const _uuid = Uuid();
  late String description;
  late final String id;

  @override
  List<String> header() {
    return ['Description', 'Type', 'User Group', 'Status'];
  }

  @override
  List<Object?> asRow() {
    return [
      description,
      assetType,
      userGroup,
      status,
    ];
  }
}
