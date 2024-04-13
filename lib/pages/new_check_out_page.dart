import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/person_model.dart';
import 'package:provider/provider.dart';
import '../view_models/create_check_out.dart';
import '/services/firestore_storage.dart';
import '/models/asset_instance.dart';

final _formKey = GlobalKey<FormState>();
String description = "";
int serialNum = 0;
String wirelessNIC = "";
AssetInstance newAsset = AssetInstance();

final firestoreStorage = FirestoreStorage();

List<DropdownMenuItem>? rooms;
String selectedPerson = '';
String selectedBuildingName = '';
String selectedRoomName = '';

bool isNewPerson = false;
bool isTemporary = false;

class NewCheckOutPage extends StatefulWidget {
  const NewCheckOutPage({super.key, this.asset});
  final Object? asset;

  @override
  State<NewCheckOutPage> createState() => _NewCheckOutPageState();
}

class _NewCheckOutPageState extends State<NewCheckOutPage> {
  TextEditingController _personNameController = TextEditingController();
  TextEditingController _personEmailController = TextEditingController();
  TextEditingController _personSchoolIDController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _assetSerialController = TextEditingController();

  @override
  void dispose() {
    // implement dispose
    final notifier =
        Provider.of<CreateCheckOutNotifier>(context, listen: false);
    notifier.completeAssetCheckOutSelectScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: [
        const Text(
          "Check Out Device Form",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Check-Out Details",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("New Person"),
                          Checkbox(
                              value: isNewPerson,
                              onChanged: (_) => setState(() {
                                    isNewPerson = !isNewPerson;
                                  })),
                        ],
                      ),
                      isNewPerson
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _personNameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Person Name',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _personEmailController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Person Email',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _personSchoolIDController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Person School ID',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      !isNewPerson
                          ? Row(
                              children: [
                                FutureBuilder(
                                  future: firestoreStorage
                                      .getPeopleAsDropdownMenuItems(),
                                  builder: (context, snapshot) {
                                    return SizedBox(
                                      width: 200,
                                      child: DropdownButtonFormField(
                                        value: selectedPerson,
                                        decoration: const InputDecoration(
                                          labelText: 'Person',
                                        ),
                                        validator: (value) {
                                          if (selectedPerson == '' &&
                                              selectedBuildingName == '' &&
                                              _personEmailController.text ==
                                                  '' &&
                                              _personNameController.text ==
                                                  '' &&
                                              _personSchoolIDController.text ==
                                                  '') {
                                            return 'Building or person needed';
                                          }
                                          description = value.toString();
                                          return null;
                                        },
                                        items: snapshot.data,
                                        onChanged: (value) => setState(() {
                                          selectedPerson = value;
                                        }),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          FutureBuilder(
                            future: firestoreStorage
                                .getBuildingsAsDropdownMenuItems(),
                            builder: (context, snapshot) {
                              return SizedBox(
                                width: 200,
                                child: DropdownButtonFormField(
                                  value: selectedBuildingName,
                                  decoration: const InputDecoration(
                                    labelText: 'Building',
                                  ),
                                  validator: (value) {
                                    if (selectedBuildingName == '' &&
                                        selectedPerson == '' &&
                                        _personEmailController.text == '' &&
                                        _personNameController.text == '' &&
                                        _personSchoolIDController.text == '') {
                                      return 'Building or person needed';
                                    }
                                    description = value.toString();
                                    return null;
                                  },
                                  items: snapshot.data,
                                  onChanged: (value) => setState(() {
                                    setBuildingAndGetRooms(value);
                                  }),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: DropdownButtonFormField(
                              value: selectedRoomName,
                              decoration: const InputDecoration(
                                labelText: 'Room',
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Enter Room';
                                }
                                description = value.toString();
                                return null;
                              },
                              items: rooms,
                              onChanged: (value) => selectedRoomName = value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Text("Temporary Assignment"),
                          Checkbox(
                              value: isTemporary,
                              onChanged: (_) => setState(() {
                                    isTemporary = !isTemporary;
                                  })),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isTemporary
                          ? SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  labelText: 'RETURN DATE',
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                ),
                                readOnly: true,
                                onTap: () {
                                  _selectDate();
                                },
                              ),
                            )
                          : const SizedBox(height: 1),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 300,
                  ),
                  Column(
                    // TODO: Different assets have different kinds of identifiers other than serial number, such as keys (key-ID).
                    // Need to account for those. Maybe by dropdown field of asset types which controls the type of asset identifier needed?
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                            controller: _assetSerialController,
                            validator: (value) {
                              if (value == null || value == '') {
                                return "Enter serial number";
                              }
                            },
                            decoration: const InputDecoration(
                                labelText: 'Serial Number')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 80,
        ),
        Row(
          children: [
            const Spacer(),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    rooms = [];
                    selectedPerson = '';
                    selectedBuildingName = '';
                    selectedRoomName = '';
                    _assetSerialController.text = '';

                    isNewPerson = false;
                    isTemporary = false;
                  });
                  //Route back to checked out list
                  dispose();
                },
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            //Remove elevated button below after checking
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String returnDate =
                        _dateController.text.toString().split(" ")[0];

                    // If entering a new person's data, insert the person into the database before checking-out the asset.
                    if (isNewPerson) {
                      Person newPerson = Person();
                      newPerson.name = _personNameController.text;
                      newPerson.email = _personEmailController.text;
                      newPerson.schoolId =
                          int.parse(_personSchoolIDController.text);

                      // Insert new person into database.
                      firestoreStorage.insertPerson(newPerson);

                      // Check-out selected asset
                      try {
                        await firestoreStorage.assignAsset(
                            //TODO: Display error if invalid asset identifier.
                            int.parse(_assetSerialController.text),
                            newPerson.schoolId,
                            selectedBuildingName,
                            selectedRoomName,
                            returnDate);
                      } catch (e) {
                        print("This is the check-out error $e");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Failed check-out: Asset does not exist with specified identifier'),
                        ));
                      } finally {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Successful Check-out'),
                        ));
                      }
                    }
                    // If selecting existing person, parse schoolID from text field and check-out asset.
                    else {
                      int? selectedPersonSchoolID;
                      if (selectedPerson != '') {
                        selectedPersonSchoolID =
                            int.parse(selectedPerson.split(" ")[2]);
                      }
                      try {
                        await firestoreStorage.assignAsset(
                            //TODO: Display error if invalid asset identifier.
                            int.parse(_assetSerialController.text),
                            selectedPersonSchoolID,
                            selectedBuildingName,
                            selectedRoomName,
                            returnDate);
                      } catch (e) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Failed check-out: Asset does not exist with specified identifier'),
                        ));
                      } finally {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Successful Check-out'),
                        ));
                      }
                    }

                    // Clear fields and reset values to default
                    setState(() {
                      rooms = [];
                      selectedPerson = '';
                      selectedBuildingName = '';
                      selectedRoomName = '';
                      _assetSerialController.clear();

                      isNewPerson = false;
                      isTemporary = false;
                    });
                  }
                  dispose();
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        )
      ]),
    ));
  }

  Future<void> setBuildingAndGetRooms(value) async {
    rooms =
        await firestoreStorage.getRoomsForBuildingAsDropdownMenuItems(value);
    setState(() {
      selectedBuildingName = value;
      selectedRoomName = '';
    });
  }

  Future<void> _selectDate() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateController.text = _pickedDate.toString().split(" ")[0];
      });
    }
  }

  // Widget setupAssetListContainer() {
  //   return FutureBuilder<List<Asset>>(
  //       future: FirestoreStorage().getAssets(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //           return const Center(child: Text('No assets found.'));
  //         } else {
  //           return Material(
  //               child: Padding(
  //                   padding: const EdgeInsets.all(10.0),
  //                   child: SizedBox(
  //                     height: 600,
  //                     width: 1200,
  //                     child: ListView.builder(
  //                       itemCount: snapshot.data!.length,
  //                       itemBuilder: (context, index) {
  //                         return ListTile()
  //                       },
  //                       children: [
  //                         Text("Assets", style: TextStyle(fontSize: 20.0)),
  //                         AssetDataTable(data: snapshot.data!),
  //                       ],
  //                     ),
  //                   )));
  //         }
  //       });
  // }
}
