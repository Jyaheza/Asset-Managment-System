import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: unused_import
import '../constants/constants.dart';
import '../models/asset_instance.dart';

import '../models/reservation_model.dart';
import '../view_models/create_new_screen.dart';
import '../widgets/data_table.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({super.key});

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  @override
  String _filterCriteria = '';

  Widget build(BuildContext context) {
     return Material(
           child: Padding(
            padding: const EdgeInsets.all(10.0),
              child: ListView(
                children:[
                    const Text("Reservations", style: TextStyle( fontSize: 30.0), textAlign: TextAlign.center,),

                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22.0, left: 20),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: SizedBox(
                            width: 100,
                            child: ElevatedButton.icon(
                                onPressed: (){
                          final notifier = Provider.of<CreateNewScreenNotifier>(context, listen: false);
                                //notifier.newBuilding();
                                }, 
                              icon: const Icon(Icons.add, color: Colors.white,), 
                              label: const Text("add", style: TextStyle(color: Colors.white,)),
                              style: IconButton.styleFrom(
                                backgroundColor: addGreen,
                                //textStyle: const TextStyle(color: Colors.white),
                              )),
                                ),
                      ),
                    ]),
                    AssetDataTable(data: _reservations, onViewMore: (Object ) {  }, onEdit: (Object ) {  },), //${userGroup}
                ]
            ),
       )
    );
  }
}

final _reservations = [
  Reservations(name: 'Daniel', email: 'dan@oc.edu', schoolId: 234897, assetType: 'Laptop', date: DateTime.now())
];

