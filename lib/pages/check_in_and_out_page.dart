import 'package:flutter/material.dart';
import 'package:ocassetmanagement/constants/constants.dart';
//import 'package:ocassetmanagement/pages/new_check_out_page.dart';
import 'package:ocassetmanagement/view_models/create_check_out.dart';
import 'package:ocassetmanagement/widgets/data_table_noIcons.dart';
import 'package:provider/provider.dart';

import '../models/check_out_model.dart';
import '../models/tableable.dart';
import '../services/firestore_storage.dart';
import '../widgets/data_table.dart';

class CheckInandOutPage extends StatefulWidget {
  const CheckInandOutPage({super.key, required this.callBack});
  final void Function(Object?) callBack;

  @override
  // ignore: library_private_types_in_public_api
  _CheckInandOutPageState createState() => _CheckInandOutPageState();
}

class _CheckInandOutPageState extends State<CheckInandOutPage> {
  final _checkedOut = [
    CheckedOut(
        name: 'Dan', email: 'dan@oc.edu', schoolId: 234897, asset: 'Laptop')
  ];
     //final _checkedOutListFuture  = FirestoreStorage().getCheckOuts();


// ignore: unused_field
  List<Tableable> _filtered = [];
  @override
  initState() {
    _filtered = _checkedOut;
    super.initState();
  }

  void _filter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      _filtered = _checkedOut;
    } else {
      _filtered = _checkedOut
          .where((row) => row.asRow().any((cell) =>
              cell
                  ?.toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ??
              false))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<CheckedOut>>(
    //     future: _checkedOutListFuture,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const CircularProgressIndicator();
    //       } else if (snapshot.hasError) {
    //         return Text('Error: ${snapshot.error}');
    //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    //         return const Text('No users found.');
    //       } else {
    //         final data = _filter(snapshot.data!);
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            const Text(
              "    Checked Out Assets ",
              style: TextStyle(
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0, left: 20),
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    onChanged: (value) => setState(() {
                      _filter(value);
                    }),
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        final notifier = Provider.of<CreateCheckOutNotifier>(
                            context,
                            listen: false);
                        notifier.newCheckOutScreen(asset: null);
                        //notifier.completeProfileSelectionScren(assetName: selectedIcon?.label);

                        // Navigator.of(
                        //   context
                        // ).push(MaterialPageRoute(builder: (context) => const NewCheckOutPage()));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text("add", style: TextStyle(color: Colors.white)),
                      style: IconButton.styleFrom(
                        backgroundColor: addGreen,
                      )),
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: DataTableNoIcons(data: _filtered),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
        }
//     );
// }
// }