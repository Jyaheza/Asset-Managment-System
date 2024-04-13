import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/maintenance_log.dart';
import 'package:ocassetmanagement/pages/maintenance_log.dart';
import 'package:ocassetmanagement/pages/new_check_out_page.dart';
import 'package:ocassetmanagement/constants/constants.dart';
import 'package:ocassetmanagement/view_models/create_asset_profile.dart';
import 'package:ocassetmanagement/widgets/asset_list_data_table.dart';
import 'package:ocassetmanagement/widgets/data_table.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../services/firestore_storage.dart';

class AllAssetsPage extends StatefulWidget {
  const AllAssetsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AllAssetsPageState();
}

class _AllAssetsPageState extends State<AllAssetsPage>
    with WidgetsBindingObserver {
  Future<List<Asset>> _assetListFuture = FirestoreStorage().getAssets();
    String _filterCriteria = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshAssets();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAssets();
    }
  }

  void _refreshAssets() {
    setState(() {
      _assetListFuture = FirestoreStorage().getAssets();
    });
  }

  List<Asset> _filter(List<Asset> allAssets) {
    if (_filterCriteria.isEmpty) {
      return allAssets;
    }
    return allAssets
        .where((asset) => asset.description.toLowerCase().contains(_filterCriteria)||
        asset.assetType.toLowerCase().contains(_filterCriteria)||
        asset.status.toLowerCase().contains(_filterCriteria)||
        asset.category.toLowerCase().contains(_filterCriteria))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('All Assets'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: _refreshAssets,
      //     ),
      //   ],
      // ),
      body: FutureBuilder<List<Asset>>(
          future: _assetListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No assets found.'));
            }
            else {
            final data = _filter(snapshot.data!);
              return Material(

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    const Center(
                        child: const Text(
                      "All Assets",
                      style: TextStyle(fontSize: 30.0),
                      textAlign: TextAlign.center,
                    )),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 22.0, left: 20),
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
                        SizedBox(
                          width: 100,
                          child: ElevatedButton.icon(
                        onPressed: () {
                          final notifier = Provider.of<CreateAssetNotifier>(
                              context,
                              listen: false);
                          notifier.completeAllAssetScreen();
                        },
                        icon: const Icon( Icons.add, color: Colors.white,),
                        label: const Text("add", style: TextStyle(color: Colors.white)),
                        style: IconButton.styleFrom(
                          backgroundColor: addGreen,
                          //textStyle: const TextStyle(color: Colors.white),
                        )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: AssetDataTable(
                            data: data,
                            onViewMore: (asset) =>
                                _viewMoreInfo(context, asset as Asset),
                            onEdit: (asset) =>
                                _editAsset(context, asset as Asset),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            }
          }),
    );
  }

  void _viewMoreInfo(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (asset.assetType == 'Laptop') {
          return AlertDialog(
            title: const Text('Asset Details'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.7),
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    _buildDetailRow('Description:', asset.description),
                    _buildDetailRow('Type:', asset.assetType),
                    _buildDetailRow(
                        'Serial Number:', asset.serialNum.toString()),
                    _buildDetailRow('Status:', asset.status),
                    _buildDetailRow('Category:', asset.category),
                    _buildDetailRow('Model:', asset.model),
                    _buildDetailRow('Memory:', asset.memory),
                    _buildDetailRow('Hard Drive:', asset.hardDrive),
                    _buildDetailRow('Processor:', asset.processor),
                    // _buildDetailRow(
                    //     'External Accessories:', asset.externalAccessories),
                    // _buildDetailRow('Internal Features:', asset.internalFeatures),
                    // _buildDetailRow('Wireless NIC:', asset.wirelessNIC),
                  ],
                ),
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
              TextButton(
                // ignore: sort_child_properties_last
                child: const Text('View Maintenance Logs'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MaintenanceLogPage(asset: asset),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              )
            ],
          );
        } else if (asset.assetType == 'Printer') {
          return AlertDialog(
            title: const Text('Asset Details'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.7),
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    _buildDetailRow('Description:', asset.description),
                    _buildDetailRow('Type:', asset.assetType),
                    _buildDetailRow(
                        'Serial Number:', asset.serialNum.toString()),
                    _buildDetailRow('Status:', asset.status),
                    _buildDetailRow('Category:', asset.category),
                    _buildDetailRow('Model:', asset.model),
                    _buildDetailRow('Toner:', asset.toner),
                  ],
                ),
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
              TextButton(
                // ignore: sort_child_properties_last
                child: const Text('View Maintenance Logs'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MaintenanceLogPage(asset: asset),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              )
            ],
          );
        } else if (asset.assetType == 'Key') {
          return AlertDialog(
            title: const Text('Asset Details'),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.7),
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    _buildDetailRow('Description:', asset.description),
                    _buildDetailRow('Type:', asset.assetType),
                    _buildDetailRow('Status:', asset.status),
                    _buildDetailRow('Category:', asset.category),
                    _buildDetailRow('Key Number:', asset.keyNumber),
                    _buildDetailRow('Key Room Number:', asset.keyRoomNumber),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                // ignore: sort_child_properties_last
                child: const Text('View Maintenance Logs'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MaintenanceLogPage(asset: asset),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              ),
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
        } else {
          return AlertDialog();
        }
      },
    );
  }

  // void _updateAsset(
  //   String id,
  //   Map<String, dynamic> =
  //   // String externalAccessories,
  //   // String internalFeatures,
  //   // String wirelessNIC
  // ) {
  //   FirestoreStorage().updateAsset(id, {
  //     'assetType': type,
  //     'category': category,
  //     'description': description,
  //     'serialNum': serialNum,
  //     'status': status,
  //     // 'wirelessNIC': wirelessNIC,
  //     // 'internalFeatures': internalFeatures,
  //     // 'externalAccessories': externalAccessories,
  //   }).then((_) {
  //     _refreshAssets();
  //     return "Success";
  //   }).catchError((error) {
  //     return "$error occurred while updating";
  //   });
  // }

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
    final TextEditingController descriptionController =
        TextEditingController(text: asset.description);
    String selectedCategory = asset.category;
    String selectedStatus = asset.status;
    String selectedType = asset.assetType;
    final TextEditingController serialNumController =
        TextEditingController(text: asset.serialNum.toString());

    final TextEditingController modelController =
        TextEditingController(text: asset.model);
    final TextEditingController memoryController =
        TextEditingController(text: asset.memory);
    final TextEditingController processorController =
        TextEditingController(text: asset.processor);
    final TextEditingController hardDriveController =
        TextEditingController(text: asset.hardDrive);
    final TextEditingController tonerController =
        TextEditingController(text: asset.toner);
    final TextEditingController keyNumberController =
        TextEditingController(text: asset.keyNumber);
    final TextEditingController keyRoomNumberController =
        TextEditingController(text: asset.keyRoomNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (asset.assetType == 'Laptop') {
          // final TextEditingController externalAccessoriesController =
          //     TextEditingController(text: asset.externalAccessories);
          // final TextEditingController internalFeaturesController =
          //     TextEditingController(text: asset.internalFeatures);
          // final TextEditingController wirelessNICController =
          //     TextEditingController(text: asset.wirelessNIC);
          return AlertDialog(
            title: const Text('Edit Asset'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: [
                        'In Inventory',
                        'Checked Out',
                        'Available',
                        'Recycled'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedStatus = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      // TODO: Get list of types from Firestore and populate here.
                      items: ['Laptop', 'Printer', 'Key']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedType = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      // TODO: Get list of categories from Firestore and populate here.
                      items: ['Network', 'Machinery', 'Office', 'Secret']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedCategory = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    TextFormField(
                      controller: serialNumController,
                      decoration:
                          const InputDecoration(labelText: 'Serial Number'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(labelText: 'Model'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: memoryController,
                      decoration: const InputDecoration(labelText: 'Memory'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: processorController,
                      decoration: const InputDecoration(labelText: 'Processor'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: hardDriveController,
                      decoration:
                          const InputDecoration(labelText: 'Hard Drive'),
                      // Add validator if needed
                    ),

                    // TextFormField(
                    //   controller: externalAccessoriesController,
                    //   decoration: const InputDecoration(
                    //       labelText: 'External Accessories'),
                    //   // Add validator if needed
                    // ),
                    // TextFormField(
                    //   controller: internalFeaturesController,
                    //   decoration:
                    //       const InputDecoration(labelText: 'Internal Features'),
                    //   // Add validator if needed
                    // ),
                    // TextFormField(
                    //   controller: wirelessNICController,
                    //   decoration:
                    //       const InputDecoration(labelText: 'Wireless NIC'),
                    //   // Add validator if needed
                    // ),
                    // Add other fields as necessary
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _refreshAssets();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                // ignore: sort_child_properties_last
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    firestoreStorage.updateAsset(asset.id, {
                      'assetType': selectedType,
                      'serialNum': int.parse(serialNumController.text),
                      'category': selectedCategory,
                      'description': descriptionController.text,
                      'status': selectedStatus,
                      'model': modelController.text,
                      'memory': memoryController.text,
                      'processor': processorController.text,
                      'hardDrive': hardDriveController.text
                    }
                        // wirelessNICController.text,
                        // externalAccessoriesController.text,
                        // internalFeaturesController.text,
                        );
                    _refreshAssets();
                    Navigator.of(context).pop();
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              ),
            ],
          );
        } else if (asset.assetType == 'Printer') {
          return AlertDialog(
            title: const Text('Edit Asset'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: [
                        'In Inventory',
                        'Checked Out',
                        'Available',
                        'Recycled'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedStatus = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      // TODO: Get list of types from Firestore and populate here.
                      items: ['Laptop', 'Printer', 'Key']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedType = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      // TODO: Get list of categories from Firestore and populate here.
                      items: ['Network', 'Machinery', 'Office', 'Secret']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedCategory = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    TextFormField(
                      controller: serialNumController,
                      decoration:
                          const InputDecoration(labelText: 'Serial Number'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: modelController,
                      decoration: const InputDecoration(labelText: 'Model'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: tonerController,
                      decoration: const InputDecoration(labelText: 'Toner'),
                      // Add validator if needed
                    ),
                    // Add other fields as necessary
                  ],
                ),
              ),
            ),

            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _refreshAssets();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                // ignore: sort_child_properties_last
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    firestoreStorage.updateAsset(asset.id, {
                      'assetType': selectedType,
                      'serialNum': int.parse(serialNumController.text),
                      'category': selectedCategory,
                      'description': descriptionController.text,
                      'status': selectedStatus,
                      'model': modelController.text,
                      'toner': tonerController.text
                    });
                    _refreshAssets();
                    Navigator.of(context).pop();
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              ),
            ],
          );
        } else if (asset.assetType == 'Key') {
          return AlertDialog(
            title: const Text('Edit Asset'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: [
                        'In Inventory',
                        'Checked-Out',
                        'Available',
                        'Recycled'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedStatus = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      // TODO: Get list of types from Firestore and populate here.
                      items: ['Laptop', 'Printer', 'Key']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedType = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      // TODO: Get list of categories from Firestore and populate here.
                      items: ['Network', 'Machinery', 'Office', 'Secret']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedCategory = newValue!;
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    TextFormField(
                      controller: keyNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Key Number'),
                      // Add validator if needed
                    ),
                    TextFormField(
                      controller: keyRoomNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Key Room Number'),
                      // Add validator if needed
                    ),
                    // Add other fields as necessary
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  _refreshAssets();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Maintain'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String? selectedType;
                      DateTime? selectedDate = DateTime.now();
                      String description = '';

                      return AlertDialog(
                        title: Text('Add Maintenance'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  description = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'Description'),
                              ),
                              DropdownButtonFormField<String>(
                                value: selectedType,
                                decoration:
                                    const InputDecoration(labelText: 'Type'),
                                items: <String>[
                                  'Preventative',
                                  'Emergency',
                                  'Other'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  selectedType = newValue!;
                                },
                              ),
                              TextButton(
                                child: Text(selectedDate != null
                                    ? '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}'
                                    : 'Select Date'),
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2025),
                                  );
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    selectedDate = picked;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Add'),
                            onPressed: () {
                              MaintenanceLog log = MaintenanceLog(
                                description: description,
                                type: selectedType!,
                                date: selectedDate!.toString(),
                              );
                              FirestoreStorage()
                                  .insertMaintenanceLog(asset, log)
                                  .then((_) {
                                Navigator.of(context).pop();
                              }).catchError((error) {
                                print("Error adding maintenance log: $error");
                              });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(199, 108, 13, 13),
                                foregroundColor: Colors.white),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              ),
              TextButton(
                // ignore: sort_child_properties_last
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    firestoreStorage.updateAsset(asset.id, {
                      'assetType': selectedType,
                      'category': selectedCategory,
                      'description': descriptionController.text,
                      'status': selectedStatus,
                      'keyNumber': keyNumberController.text,
                      'keyRoomNumber': keyRoomNumberController.text
                    });
                    _refreshAssets();
                    Navigator.of(context).pop();
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(199, 108, 13, 13),
                    foregroundColor: Colors.white),
              ),
            ],
          );
        } else {
          return AlertDialog();
        }
      },
    );
  }
}
