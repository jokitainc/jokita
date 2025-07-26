import 'package:flutter/material.dart';

// Model sederhana untuk menampung data tabel yang sudah diparsing
class TableModel {
  final String name;
  final List<String> columns;
  TableModel({required this.name, required this.columns});
}

class SchemaViewModel extends ChangeNotifier {
  String _rawText = '';
  List<TableModel> _tables = [];

  String get rawText => _rawText;
  List<TableModel> get tables => _tables;

  void updateText(String newText) {
    _rawText = newText;
    _parseText();
    notifyListeners(); // Beri tahu widget lain bahwa ada perubahan!
  }

  // Parser yang sangat sederhana menggunakan Regular Expression
  void _parseText() {
    _tables = [];
    // Regex untuk menemukan blok 'table nama_tabel { ... }'
    final tableRegex = RegExp(r'table\s+(\w+)\s*\{([^}]+)\}', caseSensitive: false);
    final matches = tableRegex.allMatches(_rawText);

    for (final match in matches) {
      final tableName = match.group(1)!;
      final tableContent = match.group(2)!;

      // Regex untuk menemukan kolom di dalam blok tabel
      final columnRegex = RegExp(r'(\w+)\s+\w+');
      final columnMatches = columnRegex.allMatches(tableContent);
      final columns = columnMatches.map((c) => c.group(1)!).toList();

      _tables.add(TableModel(name: tableName, columns: columns));
    }
  }
}