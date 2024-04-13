import 'package:flutter/material.dart';

abstract class AssetCell extends ChangeNotifier {
  DataCell toDataCell();
}
