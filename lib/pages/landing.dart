import 'package:flutter/material.dart';
import 'package:ocassetmanagement/constants/constants.dart';
import 'package:ocassetmanagement/models/building_model.dart';
import 'package:ocassetmanagement/models/user_model.dart';
import 'package:ocassetmanagement/pages/add_user_group.dart';
import 'package:ocassetmanagement/pages/add_vendor_page.dart';
import 'package:ocassetmanagement/pages/all_assets.dart';
import 'package:ocassetmanagement/pages/all_user_groups_page.dart';
import 'package:ocassetmanagement/pages/all_users_page.dart';
import 'package:ocassetmanagement/pages/all_vendors_page.dart';
import 'package:ocassetmanagement/pages/asset_page.dart';
import 'package:ocassetmanagement/pages/asset_profile_selection_page.dart';
import 'package:ocassetmanagement/pages/new_check_out_page.dart';
import 'package:ocassetmanagement/pages/permissions_page.dart';
import 'package:ocassetmanagement/pages/all_reports_page.dart';
import 'package:ocassetmanagement/pages/report_page.dart';
import 'package:ocassetmanagement/pages/reservation_page.dart';
import 'package:ocassetmanagement/pages/view_building_page.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';
import 'package:ocassetmanagement/view_models/create_new_screen.dart';
import 'package:provider/provider.dart';
import 'package:ocassetmanagement/view_models/create_asset_profile.dart';
import 'package:ocassetmanagement/view_models/logged_user.dart';
import '../models/room_model.dart';
import '../view_models/create_check_out.dart';
import 'all_buildings_page.dart';
import 'check_in_and_out_page.dart';
//import 'reservation_page.dart';

import 'home_page.dart';
import '../sidebar.dart';
import 'maintenance_page.dart';
import 'roomPage.dart';
import 'web_auth_page.dart';


class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;
  bool _showNavigationBar = true;
  bool readOnly = true;
  String? _attachedprofile;
  Building? _attachedbuilding;
  Room? _attachedroom;
  Object? _attachedasset;
  String _attachedGroup = "No Data";
  // ignore: unused_field
  bool _isOnAssetProfilePage = false;
  // ignore: unused_field
  bool _isOnCheckOutPage = false;
  // ignore: unused_field
  bool _isOnMaintenancePage = false;
  // ignore: unused_field
  bool _isOnPermissionPage = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoggedUserNotifier>(context, listen: true);
    final name = provider.name;

    FirestoreStorage().loadPermissions(provider.userGroup);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ocMaroon,
        title: const Text(
          'OC Asset Management',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _showNavigationBar = !_showNavigationBar;
            });
          },
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  // PopupMenuButton(
                  //   icon: Icon(Icons.person),
                  //   itemBuilder: (BuildContext context) =>
                  //     buildProfileCard(context),
                  // )

                  IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Container(
                            padding: EdgeInsets.only(
                              top: 30,
                            ),
                            margin: EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Spacer(),
                                    AlertDialog(
                                      content: Container(
                                        width: 300,
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              "Welcome ${name}",
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                            Expanded(
                                                child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(Icons.logout),
                                                  label: const Text("Sign Out"),
                                                  onPressed: signOut,
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                      });
                },
                style: IconButton.styleFrom(backgroundColor: Colors.white),
                //textStyle: const TextStyle(color: Colors.white),
              )),
        ],
      ),
      // body: Placeholder(),
      body: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_showNavigationBar)
            Container(
              margin: const EdgeInsets.only(right: 30),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                )
              ]),
              child: SideBar(
              userPerms: provider.userPerms,
              //userGroup: userGroup,
              selectedIndex: _selectedIndex,
              onDestinationSelected: onDestinationSelected,

            ),
            ),
          Expanded(child: _mainContent()),
        ],
      ),
    );
  }

  Widget _mainContent() {
    if (_selectedIndex == 1) {
      final notifier = Provider.of<CreateAssetNotifier>(context);

      if (notifier.isAllAssets) {
        return const AllAssetsPage();
      } else if (notifier.isProfileSelectionScreen) {
        return AssetProfileSelectionPage(
            callBack: _navigateToAddAndEditAssetPage);
      } else if (notifier.isNewAsset) {
        return AssetPage(
          profile: _attachedprofile,
        );
      }
      // return notifier.isProfileSelectionScreen
      //     ? AssetProfileSelectionPage(callBack: _navigateToAddAndEditAssetPage)
      //     : AssetPage(profile: _attachedprofile);
    } else if (_selectedIndex == 2) {
      final notifierTwo = Provider.of<CreateCheckOutNotifier>(context);

      return notifierTwo.isCheckOutScreen
          ? CheckInandOutPage(callBack: _navigateToAddAndEditCheckOutPage)
          : NewCheckOutPage(
              asset: _attachedasset,
            );

    } else if (_selectedIndex == 3) {
      return const ReservationsPage();
    } else if (_selectedIndex == 4) {
      return const AllUsersPage();
    } else if (_selectedIndex == 5) {
      final notifierGeneric = Provider.of<CreateNewScreenNotifier>(context);
      if (notifierGeneric.isAllReportsScreen) {
        return const ReportsPage();
      } else if (notifierGeneric.isReportPage) {
        return const ReportPage();
      }
    } else if (_selectedIndex == 6) {
      final notifierGeneric = Provider.of<CreateNewScreenNotifier>(context);
      // notifierGeneric.resetMaintenance();
      if (notifierGeneric.isMaintenancescreen) {
        return MaintenancePage(callBack: _navigateToMaintenancePage);
      } else if (notifierGeneric.isAllVendors) {
        return const AllVendorsPage();
      } else if (notifierGeneric.isNewVendorPage) {
        return const AddVendorPage();
      } else if (notifierGeneric.isAllUserGroupsPage) {
        return AllUserGroupsPage(
          callBack: _navigateToPermissionsPage,
        );
      } else if (notifierGeneric.isNewUserGroup) {
        return const AddUGPage();
      } else if (notifierGeneric.isPermissionsPage) {
        return PermissionPage(userGroup: _attachedGroup);
      } else if (notifierGeneric.isAllBuildings) {
        return AllBuildingsPage(callBack: _navigateToViewandEditBuildingPage);
      } else if (notifierGeneric.isViewBuilding) {
        return ViewBuildingPage(
            building: _attachedbuilding,
            isReadOnly: readOnly,
            callBack: _navigateToViewandEditRoomPage);
      } else if (notifierGeneric.isRoomPage) {
        return RoomPage(
          room: _attachedroom,
          isReadOnly: readOnly,
        );
      }
      // else if (notifierGeneric.isNewBuilding){
      //   return const AddBuildingPage();
      // }
      //const MaintenancePage();
    }

    return const HomePage();
  }

  void _navigateToAddAndEditAssetPage(String? profile) {
    setState(() {
      _isOnAssetProfilePage = true;
      _attachedprofile = profile;
    });
  }

  void _navigateToAddAndEditCheckOutPage(Object? asset) {
    setState(() {
      _isOnCheckOutPage = true;
      _attachedasset = asset;
    });
  }

  void _navigateToMaintenancePage() {
    setState(() {
      _isOnMaintenancePage = true;
    });
  }

  void _navigateToPermissionsPage(String userGroup) {
    setState(() {
      _isOnPermissionPage = true;
      _attachedGroup = userGroup;
    });
  }

  void _navigateToViewandEditBuildingPage(Building? building, bool viewOrEdit) {
    setState(() {
      _attachedbuilding = building;
      readOnly = viewOrEdit;
    });
  }

  void _navigateToViewandEditRoomPage(Room? room, bool viewOrEdit) {
    setState(() {
      _attachedroom = room;
      readOnly = viewOrEdit;
    });
  }

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
