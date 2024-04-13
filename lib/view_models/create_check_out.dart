import 'package:flutter/material.dart';
//import 'package:ocassetmanagement/services/firestore_storage.dart';

class CreateCheckOutNotifier extends ChangeNotifier {
  bool isCheckOutScreen = true;
  Object? asset;

  Future<void> newCheckOutScreen({Object? asset}) async {
    isCheckOutScreen = false;
    //if (asset == null) {
      asset = null;
    // } else {
    //   int value = await FirestoreStorage().getValue();
    //   asset = '$value';
    // }

    notifyListeners();
  }

  void completeAssetCheckOutSelectScreen() {
    isCheckOutScreen = true;
    asset = null;
    notifyListeners();
  }
}