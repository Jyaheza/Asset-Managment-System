import 'package:uuid/uuid.dart';

class AssetType {
  AssetType({this.description = '', String? id})
      : 
        id = id ?? _uuid.v1();
      
  static const _uuid = Uuid();
  final String description;
  final String id;
}
