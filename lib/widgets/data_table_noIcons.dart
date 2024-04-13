import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../view_models/cells/asset_cell.dart';
import '../models/tableable.dart';

class MyDataSource extends DataTableSource {
  MyDataSource({required this.data});

  final List<Tableable> data;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  void sort(
      Comparable<dynamic> Function(Tableable) sortCriterion, bool ascending) {
    data.sort((Tableable a, Tableable b) {
      final Comparable<dynamic> aValue = sortCriterion(a);
      final Comparable<dynamic> bValue = sortCriterion(b);
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
    _sortAscending = ascending;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final Tableable row = data[index];
    return DataRow.byIndex(
      index: index,
      cells: row.asRow().map(_toDataCell).toList(),
    );
  }

  DataCell _toDataCell(Object? label) {
    if (label is AssetCell) {
      label.addListener(() => notifyListeners());
      return label.toDataCell();
    }
    return DataCell(Text(label?.toString() ?? ''));
  }

  @override
  int get rowCount => data.length;
  @override
  bool get isRowCountApproximate => false;
  @override
  int get selectedRowCount => 0;
}

class DataTableNoIcons extends StatefulWidget {
  const DataTableNoIcons({Key? key, required this.data}) : super(key: key);

  final List<Tableable> data;

  @override
  State<DataTableNoIcons> createState() => _DataTableNoIconsState();
}

class _DataTableNoIconsState extends State<DataTableNoIcons> {
  late final MyDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = MyDataSource(data: widget.data);
  }

  void _sort(int columnIndex, bool ascending) {
    _dataSource.sort((Tableable d) {
      final value = d.asRow()[columnIndex];
      return value is Comparable ? value : '';
    }, ascending);

    setState(() {
      _dataSource._sortColumnIndex = columnIndex;
      _dataSource._sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const Text('Table is empty');

    final columns = widget.data.first
        .header()
        .asMap()
        .map((index, label) => MapEntry(
            index,
            DataColumn(
              label: Text(label),
              onSort: (columnIndex, ascending) => _sort(columnIndex, ascending),
            )))
        .values
        .toList();

    return PaginatedDataTable(
      columns: columns,
      source: _dataSource,
      sortColumnIndex: _dataSource._sortColumnIndex,
      sortAscending: _dataSource._sortAscending,
    );
  }
}

class VendorDataTable extends DataTableNoIcons {
  const VendorDataTable({Key? key, required List<Tableable> data})
      : super(key: key, data: data);
}
