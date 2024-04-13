import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/asset_instance.dart';
import 'package:provider/provider.dart';

import '../models/asset_instance.dart';
import '../models/asset_model.dart';
import '../models/user_model.dart';
import '../services/firestore_storage.dart';
import '../view_models/logged_user.dart';
import '../widgets/data_table.dart';

class HomePage extends StatefulWidget {
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
late Future<List<Asset>> _assetListFuture;

initState() {
    _assetListFuture = FirestoreStorage().getAssets();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return FutureBuilder<List<Asset>>(
        future: _assetListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No users found.');
          } else {
            //final data = _filter(snapshot.data!);
    return Material(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                    // Text("Welcome $name", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    const Text("Overdue Check-Outs ", style: TextStyle( fontSize: 30.0), textAlign: TextAlign.center), //${userGroup}
                    AssetDataTable(data: (checkedOutAssets(snapshot) ),
                    //&& snapshot.returnBy < DateTime.now()),
                     onViewMore: (Object ) {  },
                      onEdit: (Object ) {  }, ), 
                ]
            ),
       )
    );
  }
}
     );

  }

List<Object> checkedOutAssets(AsyncSnapshot<List<Asset>> snapshot ){
  List<Object> entries = [];
  for(Asset entry in snapshot.data!){
    if(entry.status == "Checked-Out"){
    entries.add(entry);}
  }
  return entries;

}
}

