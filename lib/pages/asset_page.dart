import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocassetmanagement/pages/new_check_out_page.dart';
//import 'package:ocassetmanagement/models/asset_profile.dart';
import '/services/firestore_storage.dart';
import '/models/asset_model.dart';
import 'package:provider/provider.dart';
import '../view_models/create_asset_profile.dart';

final _formKey = GlobalKey<FormState>();
Asset newAsset = Asset();
bool profileFilled = false;

// Generic asset fields
String description = "";
String selectedAssetType = '';

// Specific asset type fields.
String memory = '';
String hardDrive = '';
String processor = '';
String model = '';
int serialNum = 0;
String toner = '';
String keyNumber = '';
String keyRoomNumber = '';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key, this.profile});
  final String? profile;

  //final _assetProfile = FirestoreStorage().getAsset(serialNum);

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final _profileNameController = TextEditingController();


  @override
  void initState() {
    _profileNameController.text = widget.profile ?? 'None';
    super.initState();
  }

  @override
  void dispose() {
    final notifier = Provider.of<CreateAssetNotifier>(context, listen: false);
    notifier.completeAssetSelectScreen();
    super.dispose();
  }

  void checkProfileFilled() {
    if (_profileNameController.text != 'None') {
      profileFilled = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    checkProfileFilled();

    // return FutureBuilder<List<AssetInstance>>(
    //   future: _assetProfile,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // While the future is still running, show a loading indicator or placeholder
    //       return const CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       // If there's an error, display an error message
    //       return Text('Error: ${snapshot.error}');
    //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //       // If there's no data or the data is empty, display a message
    //       return const Text('No users found.');
    //     } else {

    return Material(
      // child: Center(
      child: Form(
          // TODO: Display a widget form for selected Asset Type
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 50, right: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const Row(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  'Asset Info',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 200,
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                  ),
                                  onSaved: (String? value) {
                                    //debugPrint('value for field $index saved as "$value"');
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter description';
                                    }
                                    description = value;
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                          Row(
                            children: [
                              FutureBuilder(
                                future: firestoreStorage.getAssetTypes(),
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    width: 200,
                                    child: DropdownButtonFormField(
                                      value: selectedAssetType,
                                      decoration: const InputDecoration(
                                        labelText: 'Asset Type',
                                      ),
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Enter Type';
                                        }
                                        selectedAssetType = value.toString();
                                        return null;
                                      },
                                      items: snapshot.data,
                                      onChanged: (value) => setState(() {
                                        selectedAssetType = value;
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          // TODO: Display widget that contains form fields for the selected asset type instead of declaring all specific fields in this file.
                          // Display the form fields for the 'Laptop' asset type.
                          selectedAssetType == 'Laptop'
                              ? Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Serial Number',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter serial number';
                                              }
                                              serialNum = int.parse(value);
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Model',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter model';
                                              }
                                              model = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Memory',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter memory';
                                              }
                                              memory = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Hard Drive',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter hard drive';
                                              }
                                              hardDrive = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Processor',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter processor';
                                              }
                                              processor = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          // Display the form fields for the 'Printer' asset type.
                          selectedAssetType == 'Printer'
                              ? Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Serial Number',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter serial number';
                                              }
                                              serialNum = int.parse(value);
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Model',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter model';
                                              }
                                              model = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Toner',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter toner';
                                              }
                                              toner = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          // Display the form fields for the 'Key' asset type.
                          selectedAssetType == 'Key'
                              ? Row(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Key Number',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter key number';
                                              }
                                              keyNumber = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Key Room Number',
                                            ),
                                            onSaved: (String? value) {
                                              //debugPrint('value for field $index saved as "$value"');
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter key room number';
                                              }
                                              keyRoomNumber = value;
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    //const Spacer(),
                    Expanded(
                      flex: 4,
                      child: Card(
                        child: Column(
                          children: [
                            const Row(
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Profile Info',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Profile Name',
                                    ),
                                    onSaved: (String? value) {
                                      //debugPrint('value for field $index saved as "$value"');
                                    },
                                    controller: _profileNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Must have Specific Profile or None';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 220,
                                  child: ElevatedButton(
                                    child:
                                        const Text('Change or Remove Profile'),
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                    child: const Text('Edit Profile'),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Manufacturer',
                                    ),
                                    readOnly: profileFilled,
                                    //initialValue: _assetManufacturer,
                                    // if (AssetProfile.fromFirestore().manufacturer.isNotEmpty){
                                    // initialValue: AssetProfile.fromFirestore(snapshot).manufacturer,
                                    // },
                                    onSaved: (String? value) {
                                      //debugPrint('value for field $index saved as "$value"');
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter something';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              //Route back to checked out list
                              selectedAssetType = '';
                              dispose();
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Asset Saved!'),
                                ));

                                newAsset.description = description;
                                newAsset.status = "In Inventory";
                                newAsset.assetType = selectedAssetType;
                                if (selectedAssetType == 'Laptop') {
                                  newAsset.serialNum = serialNum;
                                  newAsset.memory = memory;
                                  newAsset.hardDrive = hardDrive;
                                  newAsset.processor = processor;
                                  newAsset.model = model;
                                } else if (selectedAssetType == 'Printer') {
                                  newAsset.serialNum = serialNum;
                                  newAsset.model = model;
                                  newAsset.toner = toner;
                                } else if (selectedAssetType == 'Key') {
                                  newAsset.keyNumber = keyNumber;
                                  newAsset.keyRoomNumber = keyRoomNumber;
                                }
                                FirestoreStorage().insertAsset(newAsset);
                              }
                              dispose();
                            },
                            child: const Text('Submit'),
                          ),
                          //Remove elevated button below after checking
                          //  ElevatedButton(
                          //   onPressed: () {
                          //     if (_formKey.currentState!.validate()) {
                          //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //         content: Text('Printed!'),
                          //       ));
                          //       FirestoreStorage().getAsset(serialNum);
                          //     }
                          //   },
                          //   child: const Text('Get'),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
