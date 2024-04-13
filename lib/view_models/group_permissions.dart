import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/permissions_model.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';

class GroupPermissionsNotifier extends ChangeNotifier {
  bool isLoading = true;
  late Permission permission;

  GroupPermissionsNotifier(String userGroup) {
    _initial(userGroup);
  }

  void _initial(String userGroup) async {
    permission = await FirestoreStorage().getPermissions(userGroup);
    isLoading = false;
    notifyListeners();
  }

  void updatePermissionsList(String permName) {
    final hasChanged = permission.togglePermission(permName);
    if (hasChanged) {
      notifyListeners();
    }
  }
}
