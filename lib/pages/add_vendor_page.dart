import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/vendor_model.dart';
import 'package:provider/provider.dart';
import '../view_models/create_new_screen.dart';
import '/services/firestore_storage.dart';

final _formKey = GlobalKey<FormState>();
String name = "";
String type = "";
Vendor newVendor = Vendor();

class AddVendorPage extends StatefulWidget {
const AddVendorPage({super.key});


  @override
State<AddVendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<AddVendorPage> {
@override
void initState() {
  super.initState();
}

@override
void dispose() {
    // implement dispose
    final notifier = Provider.of<CreateNewScreenNotifier>(context, listen: false);
    notifier.completeNewVScreen();
    super.dispose();
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
                      child: 
                        Column(
                          children: [
                            const Row(
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text('Vendor Info', style: TextStyle(fontSize: 25),),
                                        ),
                                      ],
                                    ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                    onSaved: (String? value) {
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter a Name';
                                      }
                                      name = value;
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Type of Vendor',
                                    ),
                                    onSaved: (String? value) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Vendor Type';
                                      }
                                      type = value;
                                      return null;
                                    },
                                  ),
                                ),
                            ],
                          ),        
                          ],
                        ),
                    ),      
                  ],
                ),
              ),
              const SizedBox(height: 30,), 
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
                      onPressed: () { //Route back to Vendor List
                      dispose();
                      },
                      child: const Text('Cancel'),
                    ),
                        ),
                        const SizedBox(width: 20,),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text('Vendor Saved!'),
                                            ));
                                            newVendor.name = name;
                                            newVendor.type = type;
                                            FirestoreStorage().insertVendor(newVendor);
                                            newVendor = Vendor();
                                          }
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
          )
            ),
  );

}
}