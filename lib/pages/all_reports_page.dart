import 'package:flutter/material.dart';
import 'package:ocassetmanagement/constants/constants.dart';
import 'package:ocassetmanagement/services/firestore_storage.dart';
import 'package:provider/provider.dart';
import '../models/check_out_model.dart';
import '../models/report_model.dart';
import '../models/tableable.dart';
import '../view_models/create_new_screen.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportsPage createState() => _ReportsPage();
}

String _filterCriteria = '';

class _ReportsPage extends State<ReportsPage> {
  final List<Report> _reports = [
    Report(name: "PEC Assets", delete: false),
    Report(name: "Assets Checked Out", delete: false)
  ];
  bool isDelete = false;
  bool _selected = false;

// ignore: unused_field
  List<Report> _filtered = [];
  @override
  initState() {
    _filtered = _filter(_reports);
    super.initState();
  }

  List<Report> _filter(List<Report> allReports) {
    if (_filterCriteria.isEmpty) {
      return allReports;
    }
    return allReports
        .where((report) =>
            report.name!.toLowerCase().toString().contains(_filterCriteria))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    _filtered = _filter(_reports);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports ", style: TextStyle(fontSize: 30.0)),
      ),
      body: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
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
                  const Spacer(),
                  Visibility(
                    visible: !isDelete,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isDelete = !isDelete;
                          });
                        },
                        icon: const Icon( Icons.cancel, color: Colors.white,),
                        label: const Text("select to delete", style: TextStyle(color: Colors.white)),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          //textStyle: const TextStyle(color: Colors.white),
                        )),
                  ),
                 const SizedBox(
                    width: 5,
                  ),
                  Visibility(
                    visible: !isDelete,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          final notifier = Provider.of<CreateNewScreenNotifier>(
                              context,
                              listen: false);
                          notifier.reportScreen(report: Report());
                        },
                        icon: const Icon( Icons.add, color: Colors.white,),
                        label: const Text("add", style: TextStyle(color: Colors.white)),
                        style: IconButton.styleFrom(
                          backgroundColor: addGreen,
                          //textStyle: const TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 500,
                child: ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildReportCards(
                          context,
                          index,
                        ), ),
              ),
              Visibility(
                visible: isDelete,
                child: Row(
                  children: [
                    const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                 isDelete= !isDelete;
                                 for(var i = 0; i < _filtered.length; i++ )
                                 {if(_filtered[i].delete == true){
                                  _filtered[i].delete = false;
                                 }}
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                                //TODO Firestore
                              //FirestoreStorage().removeReport(_filtered[index].delete == true);
                              setState(() {
                                 isDelete= !isDelete;
                              });
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Deleted Report(s)'),
                              ));
                
                            },
                            child: const Text('Delete'),
                          ),
                        ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget buildReportCards(BuildContext context, int index) {
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
                  Visibility(
                    visible: isDelete,
                    child: Checkbox(value: _filtered[index].delete, onChanged: (bool? value) { 
                     setState(() {
                      _filtered[index].delete = !_filtered[index].delete!;

                     });
                     },),
                  ),
                  Expanded(
                    child: ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: () {},
                      ),
                      title: Text(
                        _filtered[index].name.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      trailing: Visibility(
                        visible: !isDelete,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                    final notifier = Provider.of<CreateNewScreenNotifier>(
                              context,
                              listen: false);
                          notifier.reportScreen(report: _filtered[index]);

                          },
                        ),
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
