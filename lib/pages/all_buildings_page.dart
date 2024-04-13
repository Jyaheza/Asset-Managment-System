import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/building_model.dart';
import 'package:ocassetmanagement/models/room_model.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../services/firestore_storage.dart';
import '../view_models/create_new_screen.dart';
import '../widgets/data_table.dart';

class AllBuildingsPage extends StatefulWidget {
  const AllBuildingsPage({super.key, required this.callBack});
  final void Function(Building?, bool) callBack;

  @override
  // ignore: library_private_types_in_public_api
  _AllBuildingsPageState createState() => _AllBuildingsPageState();
}

class _AllBuildingsPageState extends State<AllBuildingsPage> {
  late Future<List<Building>> _buildingListFuture;

  String _filterCriteria = '';
  // final _checkedOut = <Building>[
  //   Building(
  //       name: 'Prince Engineering Center (PEC)',
  //       roomNum: 30,
  //       assetTotal: 235,
  //       rooms: [
  //         Room(roomNum: 205, assets: ["none", "none"]),
  //         Room(roomNum: 105, assets: ["none", "none"])
  //       ],
  //       assets: [])
  // ];

  //List<Tableable> _filtered = [];
  @override
  initState() {
    //_filtered = _checkedOut;
    _buildingListFuture = FirestoreStorage().getBuildings();

    super.initState();
  }
  dispose(){
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    notifier.completeAllBuildingsPage();
    super.dispose();
  }

  List<Building> _filter(List<Building> allBuildings) {
    if (_filterCriteria.isEmpty) {
      return allBuildings;
    }
    return allBuildings
        .where((building) => building.name.contains(_filterCriteria))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Building>>(
        future: _buildingListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No users found.');
          } else {
            final data = _filter(snapshot.data!);
            return Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: 
                          IconButton(onPressed: () {
                            dispose();
                          } , icon: const Icon(Icons.arrow_back))),
                        const Center(
                          child:  Text(
                            "    Buildings List ",
                            style: TextStyle(
                              fontSize: 30.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],

                    ),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22.0, left: 20),
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                            onChanged: (value) => setState(() {
                              _filterCriteria = value;
                            }),
                            decoration: const InputDecoration(
                              labelText: 'Search',
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SizedBox(
                            width: 100,
                            child: ElevatedButton.icon(
                                onPressed: (){
                          final notifier = Provider.of<CreateNewScreenNotifier>(context, listen: false);
                                notifier.newBuilding();
                                }, 
                              icon: const Icon(Icons.add, color: Colors.white,), 
                              label: const Text("add", style: TextStyle(color: Colors.white,)),
                              style: IconButton.styleFrom(
                                backgroundColor: addGreen,
                                //textStyle: const TextStyle(color: Colors.white),
                              )),
                                ),

                      ),
                    ]),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: AssetDataTable(
                              data: data,
                              onViewMore: (building) =>
                                  _viewMoreInfo(context, building as Building),
                              onEdit: (building) =>
                                  _editBuilding(context, building as Building)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
  }

  void _viewMoreInfo(BuildContext context, Building building) {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    widget.callBack(building, true);
    notifier.buildingScreen(building: building);
  }

  void _editBuilding(BuildContext context, Building building) {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    widget.callBack(building, false);
    notifier.buildingScreen(building: building);
  }
}
