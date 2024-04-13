import 'package:cloud_firestore/cloud_firestore.dart';

class Report  {
  Report({
     this.name,
     this.delete
   
  }): id = '0';

  Report.fromFirestore(DocumentSnapshot snapshot)
      :
        name = snapshot['name'] ?? '',
        delete = snapshot["delete"] ?? '',
        id = snapshot.id;

  String? name;
  bool? delete;
  final String id;


}
