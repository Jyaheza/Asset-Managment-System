import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/permissions_model.dart';
import 'package:ocassetmanagement/pages/web_auth_page.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';
import 'package:ocassetmanagement/view_models/logged_user.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
    this.labelType = NavigationRailLabelType.all,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.userPerms,
  });

  final NavigationRailLabelType labelType;
  final int selectedIndex;
  final Permission userPerms;
  final void Function(int) onDestinationSelected;
  //late Future userPerms;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 1500))
        .then((value) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPerms = FirestoreStorage().getUserPermission();
    // List<NavigationRailDestination>? navigationDestinations = [];
    List<NavigationRailDestination> navigationDestinations = [];
    navigationDestinations.add(const NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text('Home'),
    ));
    navigationDestinations.add(const NavigationRailDestination(
      icon: Icon(Icons.list),
      label: Text('All Assets'),
    ));
    navigationDestinations.add(const NavigationRailDestination(
      icon: Icon(Icons.checklist),
      label: Text("Check In/Out"),
    ));
    navigationDestinations.add(const NavigationRailDestination(
      icon: Icon(Icons.notifications),
      label: Text("Reservations"),
    ));
    if (userPerms.userManage) {
      navigationDestinations.add(const NavigationRailDestination(
        icon: Icon(Icons.person),
        label: Text('Users'),
      ));
    }
    if (userPerms.reportGen) {
      navigationDestinations.add(const NavigationRailDestination(
        icon: Icon(Icons.query_stats),
        label: Text('Reports'),
      ));
    }
    if (userPerms.maintScreens) {
      navigationDestinations.add(const NavigationRailDestination(
        icon: Icon(Icons.settings),
        label: Text('Maintenance'),
      ));
    }

    return NavigationRail(
      indicatorColor: const Color.fromARGB(111, 108, 13, 13),
      selectedIndex: widget.selectedIndex,
      labelType: widget.labelType,
      elevation: 5,
      onDestinationSelected: widget.onDestinationSelected,
      destinations: navigationDestinations,
    );
  }

  void signOut() {
    final notifier = Provider.of<LoggedUserNotifier>(context, listen: false);
    notifier.loggedUserOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TempWebAuthPage()),
        (_) => false);
  }
}
