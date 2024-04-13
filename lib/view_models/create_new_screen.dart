import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/building_model.dart';

import '../models/report_model.dart';
import '../models/room_model.dart';

class CreateNewScreenNotifier extends ChangeNotifier {
  bool isMaintenancescreen = true;
  bool isAllReportsScreen = true;
  bool isNewVendorPage = false;
  bool isAllVendors = false;
  bool isAllUserGroupsPage = false;
  bool isNewUserGroup = false;
  bool isPermissionsPage = false;
  bool isReportPage = false;
  Report? selectedReport;

  bool isAllBuildings = false;
  bool isNewBuilding = false;
  bool isViewBuilding = false;
  bool isRoomPage = false;
  Building? selectedBuilding;
  Room? selectedRoom;
  String permName = "No Data";

  Future<void> resetMaintenance() async {
    isAllVendors = false;
    isNewBuilding = false;
    isNewUserGroup = false;
    isNewVendorPage = false;
    isAllBuildings = false;
    isAllUserGroupsPage = false;
    isPermissionsPage = false;
    isAllVendors = false;
    isRoomPage = false;
    isViewBuilding = false;
    isMaintenancescreen = true;
    notifyListeners();
  }

  Future<void> allVendorScreen() async {
    isAllVendors = true;
    isMaintenancescreen = false;
    notifyListeners();
  }

  Future<void> newVendor() async {
    isNewVendorPage = true;
    isAllVendors = false;
    notifyListeners();
  }

  Future<void> allBuildingScreen() async {
    isAllBuildings = true;
    isMaintenancescreen = false;
    notifyListeners();
  }

  Future<void> newBuilding() async {
    isAllBuildings = false;
    isNewBuilding = true;
    notifyListeners();
  }

  Future<void> buildingScreen({required Building? building}) async {
    //print(building?.name);
    isAllBuildings = false;
    isViewBuilding = true;
    if (building == null) {
      selectedBuilding = null;
    } else {
      //int value = await FirestoreStorage().getValue();
      //assetProfile = '$value';
      selectedBuilding = building;
    }
    notifyListeners();
  }

  Future<void> roomScreen({required Room room}) async {
    isViewBuilding = false;
    isRoomPage = true;
    //  if (room == null) {
    //   selectedRoom = null;
    // } else {
    //int value = await FirestoreStorage().getValue();
    //assetProfile = '$value';
    selectedRoom = room;
    //}
    notifyListeners();
  }

  Future<void> reportScreen({required Report report}) async{
   isAllReportsScreen = false;
    isReportPage = true;
    selectedReport = report;
    notifyListeners();
  }

 void completeReportScreen(){
   isAllReportsScreen = true;
  isReportPage = false;
  notifyListeners();
 }

  void completeNewVScreen() {
    isMaintenancescreen = false;
    isAllVendors = true;
    isNewVendorPage = false;
    notifyListeners();
  }

  void completeAllVendorPage() {
    isMaintenancescreen = true;
    isAllVendors = false;
    isNewVendorPage = false;
    notifyListeners();
  }

  void completeRoomPage() {
    isRoomPage = false;
    isViewBuilding = true;
    notifyListeners();
  }
  void completeAllBuildingsPage() {
    isAllBuildings = false;
    isMaintenancescreen = true;
    notifyListeners();
  }

  void completeBuildingPage() {
    isViewBuilding = false;
    isAllBuildings = true;
    notifyListeners();
  }

  void completeAllUGPage() {
    isMaintenancescreen = true;
    isAllUserGroupsPage = false;
    isNewUserGroup = false;
    notifyListeners();
  }

  Future<void> newUserGroup() async {
    isNewUserGroup = true;
    isAllUserGroupsPage = false;
    notifyListeners();
  }

  Future<void> allUGScreen() async {
    isAllUserGroupsPage = true;
    isMaintenancescreen = false;
    notifyListeners();
  }

  Future<void> permissionScreen(String userGroup) async {
    isAllUserGroupsPage = false;
    isPermissionsPage = true;
    permName = userGroup;
    notifyListeners();
  }

  Future<void> completPermissionScreen() async {
    isAllUserGroupsPage = true;
    isPermissionsPage = false;
    notifyListeners();
  }

  void completeNewUGScreen() {
    isMaintenancescreen = false;
    isAllUserGroupsPage = true;
    isNewUserGroup = false;
    notifyListeners();
  }
}
