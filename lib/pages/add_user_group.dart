import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/user_group_model.dart';
import '/services/firestore_storage.dart';

final _formKey = GlobalKey<FormState>();
String name = "";
String type = "";
UserGroup newUserGroup = UserGroup();
FirestoreStorage firestore = FirestoreStorage();

class AddUGPage extends StatefulWidget {
  const AddUGPage({super.key});

  @override
  State<AddUGPage> createState() => _UserGroupPageState();
}

class _UserGroupPageState extends State<AddUGPage> {
  @override
  void initState() {
    super.initState();
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
                          const Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text(
                                  'User Group Info',
                                  style: TextStyle(fontSize: 25),
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
                                    labelText: 'Name',
                                  ),
                                  onSaved: (String? value) {},
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
                                  content: Text('User Group Saved!'),
                                ));
                                newUserGroup.name = name;

                                firestore.insertUserGroup(newUserGroup);
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
          )),
    );
  }
}
