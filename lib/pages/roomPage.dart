import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/building_model.dart';
import 'package:ocassetmanagement/models/room_model.dart';
import 'package:provider/provider.dart';

import '../models/asset_model.dart';
import '../view_models/create_new_screen.dart';
import '../widgets/data_table.dart';

class RoomPage extends StatefulWidget {
  RoomPage({super.key, required this.room, required this.isReadOnly});
//final void Function(Room?, bool) callBack;
  final Room? room;
  late bool isReadOnly;

  @override
  // ignore: library_private_types_in_public_api
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  @override
  initState() {
    super.initState();
  }

  dispose() {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    notifier.completeRoomPage();
    super.dispose();
  }

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Room Info'),
    Tab(text: 'Assets'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            leading: SizedBox(
                width: 100,
                child: IconButton(
                    onPressed: () {
                      dispose();
                    },
                    icon: const Icon(Icons.arrow_back))),
            title: Text("Room Num: ${widget.room!.roomNum}"),
            bottom: const TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
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
                            style: IconButton.styleFrom()),
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
                            labelText: 'Room Number:',
                          ),
                          initialValue: widget.room?.roomNum.toString(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: 200,
                        child: TextFormField(
                          readOnly: widget.isReadOnly,
                          decoration: const InputDecoration(
                            labelText: 'Number of Assets:',
                          ),
                          initialValue: widget.room?.assets.length.toString(),
                        ),
                      )
                    ],
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
                            setState(() {
                              widget.isReadOnly = true;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Saved Building'),
                            ));

                            //TODO Firestore
                            //FirestoreStorage().setRoom(widget.room);
                          },
                          // },
                          child: const Text('Submit'),
                        ),
                      ),
                    ]),
                  )
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 22.0, left: 20),
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
                        data: widget.room!.assets,
                        onViewMore: (asset) =>
                            _viewInfoAsset(context, asset as Asset),
                        onEdit: (asset) => _editAsset(context, asset as Asset)),
                  ],
                ),
              ),
            ],
          ),
        ));
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
