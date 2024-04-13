import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/create_new_screen.dart';

class MaintenancePage extends StatefulWidget {

  const MaintenancePage({super.key, required this.callBack});
  final void Function() callBack;

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}



class _MaintenancePageState extends State<MaintenancePage> {
static const List<String>  _list = [
  "Vendors",
  "Buildings & Rooms",
  "User Groups",
  "Asset Categories"
];
// ignore: annotate_overrides
Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance", style: TextStyle(fontSize: 30),),),
      body:  SizedBox(
                height: 500,
                child: ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildCards(context, index,), ),
              ),

   

      // Material(
      //     child: Center(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
                  
      //               children: [
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: ElevatedButton(onPressed: () {
      //                 final notifier = Provider.of<CreateNewScreenNotifier>(context, listen: false);
      //                             notifier.allVendorScreen();
      //               }, child: const Text("Vendors")),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: ElevatedButton(onPressed: () {
      //                 final notifier = Provider.of<CreateNewScreenNotifier>(context, listen: false);
      //                             notifier.allBuildingScreen();
      //               }, child: const Text("Buildings & Rooms")),
      //             )
      //             ],
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
                  
      //               children: [
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: ElevatedButton(onPressed: () {
      //                 final notifier = Provider.of<CreateNewScreenNotifier>(context, listen: false);
      //                             notifier.allUGScreen();
      //               }, child: const Text("User Groups")),
      //             ),
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: ElevatedButton(onPressed: () {}, child: const Text("Hold")),
      //             )
      //             ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),

      // ),
    );

}


Widget buildCards(BuildContext context, int index){
   return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      
                      title: Text(
                        _list[index],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                           final notifier = Provider.of<CreateNewScreenNotifier>(context,listen: false);
                        if(_list[index] == "Vendors")
                        notifier.allVendorScreen();
                        else if (_list[index] == "Buildings & Rooms"){
                          notifier.allBuildingScreen();
                        }
                        else if (_list[index] == "User Groups"){
                          notifier.allUGScreen();
                        }
                      
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
}


}