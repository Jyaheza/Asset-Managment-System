import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/tableable.dart';
import '../models/asset_model.dart';

class MyDataSource extends DataTableSource {
  MyDataSource({
    required this.data,
    required this.onViewMore,
    required this.onEdit,
  });

  final List<Asset> data;
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

    // ignore: unnecessary_type_check
    if (row is Tableable) {
      List<DataCell> cells = row.asRow().map<DataCell>((item) {
        return DataCell(item is Widget ? item : Text(item?.toString() ?? ''));
      }).toList();

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
    } else {
      if (kDebugMode) print('$row doesn\'t implement Tableable.');
      // Fallback for non-Tableable data
      return DataRow(cells: List.filled(5, const DataCell(Placeholder())));
    }
  }
}

class AssetListDataTable extends StatelessWidget {
  const AssetListDataTable({
    Key? key,
    required this.data,
    required this.onViewMore,
    required this.onEdit,
  }) : super(key: key);

  final List<Asset> data;
  final Function(Asset) onViewMore;
  final Function(Asset) onEdit;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Text('Table is empty');

    final asset = data.first;

    // ignore: unnecessary_type_check
    if (asset is Tableable) {
      return PaginatedDataTable(
        columns: data.first
            .header()
            .map((label) => DataColumn(label: Text(label)))
            .toList(),
        source:
            MyDataSource(data: data, onViewMore: onViewMore, onEdit: onEdit),
      );
    }

    return Text("$asset not tableable");
  }

  DataColumn columnHeader(String label) {
    return DataColumn(label: Text(label.toString()));
  }
}
