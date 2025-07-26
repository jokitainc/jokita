import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

// --- MODELS ---

class ColumnModel {
  final String name;
  final String dataType;
  bool isPrimaryKey; // Diubah menjadi var untuk composite key
  final bool isUnique;
  final bool isNotNull;

  ColumnModel({
    required this.name,
    required this.dataType,
    this.isPrimaryKey = false,
    this.isUnique = false,
    this.isNotNull = false,
  });
}

class TableModel {
  final String name;
  final List<ColumnModel> columns;
  TableModel({required this.name, required this.columns});

  ColumnModel? findColumn(String name) {
    return columns.firstWhereOrNull((c) => c.name.toLowerCase() == name.toLowerCase());
  }
}

enum RelationType { oneToOne, oneToMany, manyToOne }

class RelationModel {
  final String? name;
  final String fromTable;
  final String fromColumn;
  final String toTable;
  final String toColumn;
  final RelationType type;

  RelationModel({
    this.name,
    required this.fromTable,
    required this.fromColumn,
    required this.toTable,
    required this.toColumn,
    required this.type,
  });
}

class ValidationError {
  final String message;
  final int? lineNumber; // Untuk referensi di masa depan
  ValidationError(this.message, {this.lineNumber});
}

class SchemaState {
  final List<TableModel> tables;
  final List<RelationModel> relations;
  final List<ValidationError> errors;

  const SchemaState({
    this.tables = const [],
    this.relations = const [],
    this.errors = const [],
  });

  SchemaState copyWith({
    List<TableModel>? tables,
    List<RelationModel>? relations,
    List<ValidationError>? errors,
  }) {
    return SchemaState(
      tables: tables ?? this.tables,
      relations: relations ?? this.relations,
      errors: errors ?? this.errors,
    );
  }
}


// --- NOTIFIER & PROVIDER ---

class SchemaNotifier extends StateNotifier<SchemaState> {
  SchemaNotifier() : super(const SchemaState());

  void processText(String text) {
    final tables = _parseTables(text);
    final relations = _parseRelations(text);
    final errors = _validateSchema(tables, relations);

    // Hanya relasi yang valid yang akan digambar
    final validRelations = relations.where((rel) {
        final fromTable = tables.firstWhereOrNull((t) => t.name == rel.fromTable);
        final toTable = tables.firstWhereOrNull((t) => t.name == rel.toTable);
        if (fromTable == null || toTable == null) return false;
        if (fromTable.findColumn(rel.fromColumn) == null || toTable.findColumn(rel.toColumn) == null) return false;
        return true;
    }).toList();


    state = state.copyWith(tables: tables, relations: validRelations, errors: errors);
  }

  List<TableModel> _parseTables(String text) {
    final tables = <TableModel>[];
    final tableRegex = RegExp(r'Table\s+(\w+)\s*\{([^}]+)\}', caseSensitive: false, multiLine: true);

    for (final tableMatch in tableRegex.allMatches(text)) {
      final tableName = tableMatch.group(1)!;
      final tableContent = tableMatch.group(2)!;
      final columns = <ColumnModel>[];
      List<String> compositeKeys = [];
      
      // Cari composite primary key dulu
      final pkRegex = RegExp(r'\[primary key:\s*\[([^\]]+)\]\]', caseSensitive: false);
      final pkMatch = pkRegex.firstMatch(tableContent);
      if (pkMatch != null) {
        compositeKeys = pkMatch.group(1)!.split(',').map((k) => k.trim()).toList();
      }

      final columnLines = tableContent.trim().split('\n');
      for (final line in columnLines) {
        if (line.trim().isEmpty || line.trim().startsWith('[')) continue;
        
        final colRegex = RegExp(r'(\w+)\s+(\w+)\s*(.*)');
        final colMatch = colRegex.firstMatch(line.trim());
        if (colMatch != null) {
          final colName = colMatch.group(1)!;
          final attributes = colMatch.group(3) ?? '';
          
          columns.add(ColumnModel(
            name: colName,
            dataType: colMatch.group(2)!,
            isPrimaryKey: attributes.contains('primary key') || attributes.contains('pk') || compositeKeys.contains(colName),
            isUnique: attributes.contains('unique'),
            isNotNull: attributes.contains('not null'),
          ));
        }
      }
      tables.add(TableModel(name: tableName, columns: columns));
    }
    return tables;
  }

  List<RelationModel> _parseRelations(String text) {
    final relations = <RelationModel>[];
    final refRegex = RegExp(r'Ref(?:\s+(\w+))?:\s*(\w+)\.(\w+)\s*([<>-])\s*(\w+)\.(\w+)', caseSensitive: false);
    
    for (final match in refRegex.allMatches(text)) {
      final typeChar = match.group(4)!;
      RelationType type;
      if (typeChar == '-') {
        type = RelationType.oneToOne;
      } else if (typeChar == '>') {
        type = RelationType.manyToOne;
      } else { // '<'
        type = RelationType.oneToMany;
      }

      relations.add(RelationModel(
        name: match.group(1),
        fromTable: match.group(2)!,
        fromColumn: match.group(3)!,
        type: type,
        toTable: match.group(5)!,
        toColumn: match.group(6)!,
      ));
    }
    return relations;
  }

  List<ValidationError> _validateSchema(List<TableModel> tables, List<RelationModel> relations) {
    final errors = <ValidationError>[];
    final tableMap = {for (var t in tables) t.name: t};
    final relationNames = <String>{};

    for (final rel in relations) {
      // Aturan 6: Cek nama relasi unik
      if (rel.name != null) {
        if (relationNames.contains(rel.name)) {
          errors.add(ValidationError("Nama relasi '${rel.name}' sudah digunakan."));
        }
        relationNames.add(rel.name!);
      }

      final fromTable = tableMap[rel.fromTable];
      final toTable = tableMap[rel.toTable];

      // Aturan 2: Cek tabel & kolom ada
      if (fromTable == null) {
        errors.add(ValidationError("Tabel '${rel.fromTable}' tidak ditemukan."));
        continue;
      }
      if (toTable == null) {
        errors.add(ValidationError("Tabel '${rel.toTable}' tidak ditemukan."));
        continue;
      }
      final fromColumn = fromTable.findColumn(rel.fromColumn);
      final toColumn = toTable.findColumn(rel.toColumn);
      if (fromColumn == null) {
        errors.add(ValidationError("Kolom '${rel.fromColumn}' tidak ada di tabel '${fromTable.name}'."));
        continue;
      }
      if (toColumn == null) {
        errors.add(ValidationError("Kolom '${rel.toColumn}' tidak ada di tabel '${toTable.name}'."));
        continue;
      }
      
      // Aturan 1: Tipe data harus sama
      if (fromColumn.dataType != toColumn.dataType) {
        errors.add(ValidationError("Tipe data tidak cocok: ${fromTable.name}.${fromColumn.name} (${fromColumn.dataType}) vs ${toTable.name}.${toColumn.name} (${toColumn.dataType})."));
      }

      // Aturan 4: Target kolom harus PK atau Unique
      final targetColumn = rel.type == RelationType.oneToMany ? fromColumn : toColumn;
      final targetTableName = rel.type == RelationType.oneToMany ? fromTable.name : toTable.name;
      if (!targetColumn.isPrimaryKey && !targetColumn.isUnique) {
        errors.add(ValidationError("Target relasi ${targetTableName}.${targetColumn.name} harus [pk] atau [unique]."));
      }

      // Aturan 3: Relasi One-to-One butuh foreign key yang unique
      if (rel.type == RelationType.oneToOne && !fromColumn.isUnique && !fromColumn.isPrimaryKey) {
        errors.add(ValidationError("Relasi One-to-One butuh kolom ${fromTable.name}.${fromColumn.name} untuk menjadi [unique]."));
      }
    }
    
    // Aturan 5: Deteksi Many-to-Many tanpa join table (Heuristik Sederhana)
    final relationCounts = <String, int>{};
    for(var rel in relations) {
        if (rel.type == RelationType.manyToOne) {
            relationCounts[rel.toTable] = (relationCounts[rel.toTable] ?? 0) + 1;
        }
    }
    for(var table in tables) {
        if((relationCounts[table.name] ?? 0) > 1) {
            final pks = table.columns.where((c) => c.isPrimaryKey).toList();
            if(pks.length < 2) {
                // errors.add(ValidationError("Potensi relasi M-M tanpa join table yang benar pada tabel '${table.name}'."));
            }
        }
    }

    return errors;
  }
}

final schemaProvider = StateNotifierProvider<SchemaNotifier, SchemaState>((ref) {
  return SchemaNotifier();
});