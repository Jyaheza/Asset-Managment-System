import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/asset_model.dart';
import 'package:ocassetmanagement/models/building_model.dart';
import 'package:provider/provider.dart';

import '../models/room_model.dart';
import '../models/tableable.dart';
import '../services/firestore_storage.dart';
import '../view_models/create_new_screen.dart';
import '../widgets/data_table.dart';

// ignore: must_be_immutable
class ViewBuildingPage extends StatefulWidget {
  Building? building;
  ViewBuildingPage(
      {super.key,
      required this.building,
      required this.isReadOnly,
      required this.callBack});
  final void Function(Room?, bool) callBack;
  late bool isReadOnly;

  @override
  // ignore: library_private_types_in_public_api
  _ViewBuildingPageState createState() => _ViewBuildingPageState();
}

class _ViewBuildingPageState extends State<ViewBuildingPage> {
  final nameController = TextEditingController();
  final roomNumController = TextEditingController();
  final assetTotalController = TextEditingController();

// ignore: unused_field
  @override
  initState() {
    super.initState();
  }

  dispose() {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    notifier.completeBuildingPage();
    super.dispose();
  }

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Building Info'),
    Tab(text: 'Rooms'),
    Tab(text: "HVAC"),
    Tab(text: "Assets"),
  ];

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.building!.name;
    roomNumController.text = widget.building!.roomNum.toString();
    assetTotalController.text = widget.building!.assetTotal.toString();
    List<Object> roomsList = [Room(roomNum: "205"), Room(roomNum: "105")];
    // print("Rooms below:");
    // print(widget.building!.rooms);
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(
              width: 100,
              child:
                  //Back Button
                  IconButton(
                      onPressed: () {
                        dispose();
                      },
                      icon: const Icon(Icons.arrow_back))),
          title: Text(widget.building!.name),
          bottom: const TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: [
                Row(children: [
                  const Spacer(),
                  Visibility(
                    visible: widget.isReadOnly,
                    child: Container(
                      padding: const EdgeInsets.only(right: 15),
                      width: 50,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.isReadOnly = false;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          style: IconButton.styleFrom(
                              //backgroundColor: const Color.fromARGB(255, 76, 200, 63),
                              )),
                    ),
                  ),
                ]),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 200,
                      child: TextFormField(
                        readOnly: widget.isReadOnly,
                        decoration: const InputDecoration(
                          labelText: 'Building Name',
                        ),
                        controller: nameController,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 200,
                      child: TextFormField(
                        readOnly: widget.isReadOnly,
                        decoration: const InputDecoration(
                          labelText: 'Building roomNum',
                        ),
                        controller: roomNumController,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 200,
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Building Asset Count',
                        ),
                        controller: assetTotalController,
                      ),
                    )
                  ],
                ),
                Row(
                  // ignore: sized_box_for_whitespace
                  children: [Container(width: 200, child: const TextField())],
                ),
                const Spacer(),
                Visibility(
                  visible: !widget.isReadOnly,
                  child: Row(children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.isReadOnly = true;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          //if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Saved Room'),
                          ));
                          Building upbuilding = Building(
                              name: nameController.text,
                              roomNum: int.parse(roomNumController.text),
                              assetTotal: int.parse(assetTotalController.text));
                          upbuilding.id = widget.building!.id;
                          FirestoreStorage().updateBuilding(upbuilding);
                          setState(() {
                            widget.isReadOnly = true;
                            widget.building = upbuilding;
                          });
                        },
                        // },
                        child: const Text('Submit'),
                      ),
                    ),
                  ]),
                )
              ])),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22.0, left: 20),
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          onChanged: (value) => setState(() {
                            // _filter(value);
                          }),
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AssetDataTable(
                    data: roomsList, //widget.building!.rooms,
                    onViewMore: (room) => _viewInfoRoom(context, room as Room),
                    onEdit: (room) => _editRoom(context, room as Room)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22.0, left: 20),
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          onChanged: (value) => setState(() {
                            // _filter(value);
                          }),
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // AssetDataTable(data: widget.building!.assets.hvac,
                //     onViewMore: (hvac ) => _viewInfoHvac(context, hvac as Asset),
                //     onEdit: (hvac ) => _editRoom(context, hvac as Asset)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22.0, left: 20),
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          onChanged: (value) => setState(() {
                            // _filter(value);
                          }),
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AssetDataTable(
                    data: widget.building!.assets,
                    onViewMore: (asset) =>
                        _viewInfoAsset(context, asset as Asset),
                    onEdit: (asset) => _editAsset(context, asset as Asset)),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _viewInfoRoom(BuildContext context, Room room) {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    widget.callBack(room, true);
    notifier.roomScreen(room: room);
  }

  void _viewInfoHvac(BuildContext context, Asset hvac) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('HVAC Details'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.3),
            child: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                _buildDetailRow('Hvac Vendor:', hvac.description),
                _buildDetailRow('Hvac Description:', hvac.description),
                _buildDetailRow('Hvac Maintance:', hvac.description),
              ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              // ignore: sort_child_properties_last
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                  foregroundColor: Colors.white),
            ),
          ],
        );
      },
    );
  }

  void _viewInfoAsset(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Asset Details'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.3),
            child: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                _buildDetailRow('Description:', asset.description),
                _buildDetailRow('Category:', asset.description),
                _buildDetailRow('Type:', asset.description),
                _buildDetailRow('Assigned User:', asset.description),
                _buildDetailRow('Status:', asset.description),
                _buildDetailRow('Vendor', asset.description),
                _buildDetailRow('Maintenance:', asset.description),
              ]),
            ),
          ),
          actions: <Widget>[
            TextButton(
              // ignore: sort_child_properties_last
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                  foregroundColor: Colors.white),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
                text: value,
                style: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _editHvac(BuildContext context, Asset asset) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: asset.description);

    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Edit Asset'),
    //         content: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: SingleChildScrollView(
    //             child: Form(
    //               key: _formKey,
    //               child: ListBody(
    //                 children: <Widget>[
    //                   TextFormField(
    //                     controller: nameController,
    //                     decoration: const InputDecoration(labelText: 'Vendor Name'),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'Please enter a Vendor Name';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                   TextFormField(
    //                     controller: typeController,
    //                     decoration:
    //                         const InputDecoration(labelText: 'Type'),
    //                     // Add validator if needed
    //                   ),
    //                   // Add other fields as necessary
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('Cancel'),
    //             onPressed: () {
    //               _refreshVendors();
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           TextButton(
    //             // ignore: sort_child_properties_last
    //             child: const Text('Save'),
    //             onPressed: () {
    //               if (_formKey.currentState!.validate()) {
    //                 _updateVendor(
    //                   vendor,
    //                   vendor.vendorId,
    //                   nameController.text,
    //                   typeController.text,
    //                 );
    //                 _refreshVendors();
    //                 Navigator.of(context).pop();
    //               }
    //             },
    //             style: TextButton.styleFrom(
    //                 backgroundColor: const Color.fromARGB(199, 108, 13, 13),
    //                 foregroundColor: Colors.white),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  void _editRoom(BuildContext context, Room room) {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    widget.callBack(room, false);
    notifier.roomScreen(room: room);
  }

  void _editAsset(BuildContext context, Asset asset) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: asset.description);

    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Edit Asset'),
    //         content: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: SingleChildScrollView(
    //             child: Form(
    //               key: _formKey,
    //               child: ListBody(
    //                 children: <Widget>[
    //                   TextFormField(
    //                     controller: nameController,
    //                     decoration: const InputDecoration(labelText: 'Vendor Name'),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'Please enter a Vendor Name';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                   TextFormField(
    //                     controller: typeController,
    //                     decoration:
    //                         const InputDecoration(labelText: 'Type'),
    //                     // Add validator if needed
    //                   ),
    //                   // Add other fields as necessary
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('Cancel'),
    //             onPressed: () {
    //               _refreshVendors();
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           TextButton(
    //             // ignore: sort_child_properties_last
    //             child: const Text('Save'),
    //             onPressed: () {
    //               if (_formKey.currentState!.validate()) {
    //                 _updateVendor(
    //                   vendor,
    //                   vendor.vendorId,
    //                   nameController.text,
    //                   typeController.text,
    //                 );
    //                 _refreshVendors();
    //                 Navigator.of(context).pop();
    //               }
    //             },
    //             style: TextButton.styleFrom(
    //                 backgroundColor: const Color.fromARGB(199, 108, 13, 13),
    //                 foregroundColor: Colors.white),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}
