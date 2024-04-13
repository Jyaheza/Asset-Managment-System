import 'package:flutter/material.dart';
import 'package:ocassetmanagement/view_models/create_new_screen.dart';
import 'package:ocassetmanagement/view_models/group_permissions.dart';
import 'package:provider/provider.dart';
import '/services/firestore_storage.dart';

final _formKey = GlobalKey<FormState>();
bool userMana = false;
FirestoreStorage firestore = FirestoreStorage();

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key, required this.userGroup});
  final String userGroup;

  @override
  State<PermissionPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionPage> {
  final _permissions = [false, false, false, false, false, false];

  @override
  void dispose() {
    final notifier =
        Provider.of<CreateNewScreenNotifier>(context, listen: false);
    notifier.completPermissionScreen();
    super.dispose();
  }

  void Function(bool) updatePermissions(int i) {
    return (bool isChecked) => _permissions[i] = isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupPermissionsNotifier>(
      create: (BuildContext context) =>
          GroupPermissionsNotifier(widget.userGroup),
      builder: (context, _) {
        final notifier =
            Provider.of<GroupPermissionsNotifier>(context, listen: true);
        if (notifier.isLoading) {
          return const SizedBox();
        }
        final permission = notifier.permission;

        return Material(
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25.0, left: 50, right: 50),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      'User Group Info for ${widget.userGroup}',
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Has Access to User Management"),
                                  CheckboxExample(
                                    callBack: () => notifier
                                        .updatePermissionsList("userManage"),
                                    isActive: permission.userManage,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Has Access to Report Generation"),
                                  CheckboxExample(
                                    callBack: () => notifier
                                        .updatePermissionsList("reportGen"),
                                    isActive: permission.reportGen,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                      "Has Access to General Maintenance Screens (Vednors, User Groups, Buildings/Rooms, etc.)"),
                                  CheckboxExample(
                                    callBack: () => notifier
                                        .updatePermissionsList("maintScreens"),
                                    isActive: permission.maintScreens,
                                  ),
                                ],
                              ),
                              const Divider(),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      'Asset Access',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Has Access to 'IT' typed Assets"),
                                  CheckboxExample(
                                    callBack: () => notifier
                                        .updatePermissionsList("accessIT"),
                                    isActive: permission.accessIT,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                      "Has Access to 'Support Central' typed Assets"),
                                  CheckboxExample(
                                    callBack: () => notifier
                                        .updatePermissionsList("accessSS"),
                                    isActive: permission.accessSS,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                      "Has Access to 'Maintenance' typed Assets"),
                                  CheckboxExample(
                                    callBack: () => notifier
                                        .updatePermissionsList("accessMaint"),
                                    isActive: permission.accessMaint,
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
                                      content: Text('Permissions Saved!'),
                                    ));
                                    FirestoreStorage().editPermissions(
                                        widget.userGroup, permission);
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
      },
    );
  }
}

// ignore: must_be_immutable
class CheckboxExample extends StatefulWidget {
  CheckboxExample({super.key, required this.callBack, required this.isActive});

  final void Function() callBack;
  bool isActive;

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool perm = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
        MaterialState.selected,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color.fromARGB(255, 84, 179, 88);
      }
      return Colors.red;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.isActive,
      onChanged: (bool? value) {
        setState(() {
          perm = !perm;
          value = value!;
          widget.callBack();
        });
      },
    );
  }
}
