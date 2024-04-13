import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:ocassetmanagement/constants/constants.dart';
import 'package:ocassetmanagement/view_models/create_new_screen.dart';
import 'package:provider/provider.dart';
import '../models/asset_model.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '/services/firestore_storage.dart';

final _formKey = GlobalKey<FormState>();
bool userMana = false;
FirestoreStorage firestore = FirestoreStorage();

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, this.report});
  final Report? report;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _selections = [false, false, false, false, false, false];
   User? user;
   Asset? asset;

  @override
  void dispose() {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    notifier.completeReportScreen();
    super.dispose();
  }


  void changeCheck(int i){
    return setState((){
      _selections[i] = !_selections[i];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 50, right: 50),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          const Center(
                            child: Text("Report Creation", style: TextStyle(fontSize: 30),)
                          ),
                          const Row(
                            children: [
                                SizedBox(
                                width: 200,
                                child: TextField(
                                 decoration:  InputDecoration(
                                 label: Text("Report Name") 
                                 )
                                ),
                              ),
                            ]
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Report Type',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Text("Asset"),
                              Checkbox(value: _selections[0], onChanged: (bool? newValue) {
                              setState(() {
                                _selections[0] = newValue!;
                                   }
                              );
                              }
                              ),
                           
                              const Text("Building"),
                              Checkbox(value: _selections[1], onChanged: (bool? newValue) {
                              setState(() {
                                _selections[1] = newValue!;
                                   }
                              );
                              }
                              ),
                              const Text("Users"),
                              Checkbox(value: _selections[2], onChanged: (bool? newValue) {
                              setState(() {
                                _selections[2] = newValue!;
                                   }
                              );
                              }
                              ),
                              const Text("Vendors"),
                              Checkbox(value: _selections[3], onChanged: (bool? newValue) {
                              setState(() {
                                _selections[3] = newValue!;
                                   }
                              );
                              }
                              ),
                            ],
                          ),

                          //Asset
                          Visibility(
                            visible: _selections[0],
                            child: const SizedBox(
                              height: 20,
                            ),
                          ),
                          Visibility(
                            visible: _selections[0],
                            child: const Divider()),
                          Visibility(
                            visible: _selections[0],
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      'Asset Selections',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _selections[0],
                            child: const Row(
                              children: [
                                // SizedBox(
                                //   width: 100,
                                //   child: MultiSelect(
                                //    dataSource: 
                                //    //asset!.assetTypeId.toList(),
                                //    [{"display": "Laptop", "value": "Laptop"}],
                                //    textField: 'display',
                                //    valueField: 'value',
                                //     filterable: true,),
                                // ),
                                 SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("Asset Type") 
                                   )
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                 SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("Asset Category") 
                                   )
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                 SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("Asset Status") 
                                   )
                                  ),
                                ),
                            
                                
                              ],
                            ),
                          ),

                          //Buildings
                          Visibility(
                            visible: _selections[1],
                            child: const SizedBox(
                              height: 20,
                            ),
                          ),
                          Visibility(
                            visible: _selections[1],
                            child: const Divider()),
                          Visibility(
                            visible: _selections[1],
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      'Building Selections',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _selections[1],
                             child: Row(
                              children: [
                                 const SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("Building Name") 
                                   )
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                 const Text("Building Hvac's"),
                                  Checkbox(value: _selections[5], onChanged: (bool? newValue) {
                                setState(() {
                                  _selections[5] = newValue!;
                                     }
                                );
                                }
                                ),
                                 const  SizedBox(
                                  width: 20,
                                ),
                                 const SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("Asset Status") 
                                   )
                                  ),
                                ),
                              ],
                                                       ),
                           ),

                          //User
                          Visibility(
                            visible: _selections[2],
                            child: const SizedBox(
                              height: 20,
                            ),
                          ),
                          Visibility(
                            visible: _selections[2],
                            child: const Divider()),
                          Visibility(
                            visible: _selections[2],
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      'User Selections',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                           Visibility(
                            visible: _selections[2],
                             child: const Row(
                              children: [
                                                     
                                  SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("User Name") 
                                   )
                                  ),
                                ),
                                 SizedBox(
                                  width: 20,
                                ),
                                  SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text(" User Group") 
                                   )
                                  ),
                                ),
                                 SizedBox(
                                  width: 20,
                                ),
                                  SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("School ID") 
                                   )
                                  ),
                                ),
                              ],
                                                       ),
                           ),


                          //Vendor
                          Visibility(
                            visible: _selections[3],
                            child: const SizedBox(
                              height: 20,
                            ),
                          ),
                          Visibility(
                            visible: _selections[3],
                            child: const Divider()),
                          Visibility(
                            visible: _selections[3],
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      'Vendor Selections',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                           Visibility(
                            visible: _selections[3],
                             child: const Row(
                              children: [
                                  SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text("Vendor Name") 
                                   )
                                  ),
                                ),
                                 SizedBox(
                                  width: 20,
                                ),
                                  SizedBox(
                                  width: 200,
                                  child: TextField(
                                   decoration:  InputDecoration(
                                   label: Text(" Vendor Status") 
                                   )
                                  ),
                                ),
                                 SizedBox(
                                  width: 20,
                                ),
                                 
                                                       
                                
                              ],
                                                       ),
                           ),
                        ],
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
                              //Route back to ug List
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
                                  content: Text('Permissions Saved!'),
                                ));
                                // FirestoreStorage().editPermissions(
                                //     widget.report, _permissions);
                              }
                              dispose();
                            },
                            child: const Text('Submit'),
                          ),
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

