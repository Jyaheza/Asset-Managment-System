import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ocassetmanagement/models/asset_model.dart';

import '../view_models/cells/asset_cell.dart';
import '../models/tableable.dart';

class MyDataSource extends DataTableSource {
  MyDataSource({
    required this.data,
    required this.onViewMore,
    required this.onEdit,
  });

  final List<Object> data;
  final Function onViewMore;
  final Function onEdit;

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    final row = data[index];

    if (row is Tableable) {
      List<DataCell> cells = row.asRow().map(_toDataCell).toList();

      cells.add(DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => onViewMore(row),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onEdit(row),
          ),
        ],
      )));

      return DataRow(cells: cells);
      //return DataRow(cells: row.asRow().map(_toDataCell).toList());
    } else {
      if (kDebugMode) print('$row doens\'t implement tableable.');
      return DataRow(
          cells: List.filled(data.length, const DataCell(Placeholder())));
    }
  }

  DataCell _toDataCell(Object? label) {
    if (label is AssetCell) {
      label.addListener(() => notifyListeners());
      return label.toDataCell();
    } else if (label is ActionCell) {
      return label.toDataCell();
    }

    return DataCell(Text(label?.toString() ?? ''));
  }
}

class AssetDataTable extends StatelessWidget {
  AssetDataTable(
      {super.key,
      required this.data,
      required this.onViewMore,
      required this.onEdit})
      : dataSource =
            MyDataSource(data: data, onViewMore: onViewMore, onEdit: onEdit);

  final List<Object> data;
  final Function(Object) onViewMore;
  final Function(Object) onEdit;
  final DataTableSource dataSource;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Text('Table is empty');
    }
    final asset = data.first;

    if (asset is Tableable) {
      return PaginatedDataTable(
        columns: asset.header().map(columnHeader).toList(),
        source: dataSource,
      );
    }

    return Text(
        '${asset.runtimeType} does not implement Tableable. Please fix this.');
  }

  DataColumn columnHeader(String label) {
    return DataColumn(label: Text(label.toString()));
  }
}
