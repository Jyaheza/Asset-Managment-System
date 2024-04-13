import 'package:cloud_firestore/cloud_firestore.dart';

class Permission {
  Permission({String? vendorId})
      : reportGen = false,
        accessMaint = false,
        accessIT = false,
        accessSS = false,
        maintScreens = false,
        userManage = false;

  Permission.fromFirestore(DocumentSnapshot snapshot)
      : reportGen = (snapshot.data() as Map<String, dynamic>?)
                    ?.containsKey('reportGen') ??
                false
            ? snapshot['reportGen']
            : false,
        accessIT = (snapshot.data() as Map<String, dynamic>?)
                    ?.containsKey('accessIT') ??
                false
            ? snapshot['accessIT']
            : false,
        accessSS = (snapshot.data() as Map<String, dynamic>?)
                    ?.containsKey('accessSS') ??
                false
            ? snapshot['accessSS']
            : false,
        accessMaint = (snapshot.data() as Map<String, dynamic>?)
                    ?.containsKey('accessMaint') ??
                false
            ? snapshot['accessMaint']
            : false,
        userManage = (snapshot.data() as Map<String, dynamic>?)
                    ?.containsKey('userManage') ??
                false
            ? snapshot['userManage']
            : false,
        maintScreens = (snapshot.data() as Map<String, dynamic>?)
                    ?.containsKey('maintScreens') ??
                false
            ? snapshot['maintScreens']
            : false;

  late bool reportGen;
  late bool accessMaint;
  late bool accessIT;
  late bool accessSS;
  late bool maintScreens;
  late bool userManage;

  bool togglePermission(String permName) {
    switch (permName) {
      case 'userManage':
        userManage = !userManage;
        break;
      case 'reportGen':
        reportGen = !reportGen;
        break;
      case 'maintScreens':
        maintScreens = !maintScreens;
        break;
      case 'accessIT':
        accessIT = !accessIT;
        break;
      case 'accessSS':
        accessSS = !accessSS;
        break;
      case 'accessMaint':
        accessMaint = !accessMaint;
        break;
    }
    return true;
  }

  Map<String, dynamic> toMap(Permission perms) {
    Map<String, dynamic> listOfPerms = {};

    if (perms.userManage) {
      listOfPerms["userManage"] = true;
    } else {
      listOfPerms.remove("userManage");
    }

    if (perms.reportGen) {
      listOfPerms["reportGen"] = true;
    } else {
      listOfPerms.remove("reportGen");
    }

    if (perms.maintScreens) {
      listOfPerms["maintScreens"] = true;
    } else {
      listOfPerms.remove("maintScreens");
    }

    if (perms.accessIT) {
      listOfPerms["accessIT"] = true;
    } else {
      listOfPerms.remove("accessIT");
    }

    if (perms.accessSS) {
      listOfPerms["accessSS"] = true;
    } else {
      listOfPerms.remove("accessSS");
    }

    if (perms.accessMaint) {
      listOfPerms["accessMaint"] = true;
    } else {
      listOfPerms.remove("accessMaint");
    }

    return listOfPerms;
  }
}
