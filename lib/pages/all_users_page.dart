import 'package:flutter/material.dart';
import 'package:ocassetmanagement/constants/constants.dart';
import 'package:ocassetmanagement/models/misc_model.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';
import 'package:ocassetmanagement/utils/string_validator.dart';
import 'package:ocassetmanagement/widgets/data_table_noIcons.dart';

import '../models/user_model.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  late Future<List<User>> _userListFuture;
  late final Future<List<Misc>> _userGroupsFuture =
      User().fetchUserGroupNames();
  String _filterCriteria = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userListFuture = FirestoreStorage().getUsers();
  }

  List<User> _filter(List<User> allUsers) {
    if (_filterCriteria.isEmpty) {
      return allUsers;
    }
    return allUsers
        .where(
          (user) =>
              user.email.contains(_filterCriteria) ||
              user.name.contains(_filterCriteria) ||
              user.schoolId.toString().contains(_filterCriteria),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: _userListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users found.');
        } else {
          final data = _filter(snapshot.data!);
          return FutureBuilder<List<Misc>>(
            future: _userGroupsFuture,
            builder: (context, userGroupSnapshot) {
              if (userGroupSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (userGroupSnapshot.hasError) {
                return Text('Error: ${userGroupSnapshot.error}');
              } else if (!userGroupSnapshot.hasData ||
                  userGroupSnapshot.data!.isEmpty) {
                return const Text('No user groups found.');
              } else {
                return Scaffold(
                  // appBar: AppBar(
                  //   title:  ,
                  // ),
                  body: Material(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView(
                        children: [
                          const Text('Users', style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 22.0, left: 20),
                                child: SizedBox(
                                  width: 200,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Search',
                                      prefixIcon: Icon(Icons.search),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _filterCriteria = value;

                                      });
                                    },
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: SizedBox(
                                  width: 100,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: const Text("add", style: TextStyle(color: Colors.white)),

                                    onPressed: () {
                                      _showAddUserDialog(
                                          context, userGroupSnapshot.data!);
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: addGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DataTableNoIcons(data: data),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  addUser(User user) async {
    await FirestoreStorage().addNewUser(user);
  }

  void _showAddUserDialog(BuildContext context, List<Misc> userGroups) {
    TextEditingController emailController = TextEditingController();
    TextEditingController idNumberController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    Misc? selectedUserGroup;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add User'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: validateEmailAddress,
                      ),
                      TextFormField(
                        controller: idNumberController,
                        decoration:
                            const InputDecoration(labelText: 'ID Number'),
                        validator: validateSchoolID,
                        keyboardType: TextInputType.number,
                      ),
                      TextFormField(
                        controller: firstNameController,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                      DropdownButtonFormField<Misc>(
                        value: selectedUserGroup,
                        items: userGroups.map((userGroup) {
                          return DropdownMenuItem<Misc>(
                            value: userGroup,
                            child: Text(userGroup.name),
                          );
                        }).toList(),
                        onChanged: (userGroup) {
                          setState(() {
                            selectedUserGroup = userGroup;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'User Group',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User newUser = User();
                      newUser.email = emailController.text;
                      newUser.name =
                          '${firstNameController.text} ${lastNameController.text}';
                      newUser.schoolId = int.parse(idNumberController.text);
                      newUser.userGroup = selectedUserGroup?.name ?? 'IT';
                      await addUser(newUser);
                      setState(() {});

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
