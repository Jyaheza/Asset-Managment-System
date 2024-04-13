import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ocassetmanagement/models/misc_model.dart';
//import 'package:ocassetmanagement/models/user_group_model.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';
import '../view_models/cells/dropdown_cell.dart';
import 'tableable.dart';

class User implements Tableable {
  User({String? userId, int? schoolId})
      : userId = userId ?? '',
        name = '',
        email = '',
        userGroup = '',
        schoolId = schoolId ?? 0 {
    fetchUserGroupNames(); // Fetch user groups when an instance is created
  }

  User.fromFirestore(DocumentSnapshot snapshot)
      : email = snapshot['email'] ?? '',
        userGroup = snapshot['userGroup'] ?? '',
        name = snapshot['name'] ?? '',
        schoolId = snapshot['schoolId'] ?? 0,
        userId = snapshot['userId'] ?? '' {
    fetchUserGroupNames(); // Fetch user groups when an instance is created
  }

  // Below is recommended from Griffin
//   static final List<String> userGroupOptions = [];

//   static init() async {
//     final userGroups = await FirestoreStorage().getUserGroups();
//     final names = userGroups.map<String>((e) => e.name);
//     userGroupOptions.addAll(names);
//   }

  late String userGroup;
  late String name;
  late String email;
  late String userId;
  late int schoolId;
  late List<Misc> userGroups;

  Future<List<Misc>> fetchUserGroupNames() async {
    return userGroups = await FirestoreStorage().getUserG();
  }

  @override
  List<String> header() {
    return ['School ID', 'Name', 'Email', 'User Group'];
  }

  @override
  List<Object?> asRow() {
    List<String> userGroupOptions = userGroups.map((e) => e.name).toList();
    return [
      schoolId,
      name,
      email,
      DropdownCell(
        value: userGroup,
        items: userGroupOptions,
        updateValue: updateUserGroup,
      )
    ];
  }

  void updateUserGroup(String? value) {
    if (value != null) {
      userGroup = value;
      FirestoreStorage().updateUser(this);
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'userGroup': userGroup,
      'schoolId': schoolId,
    };
  }
}
