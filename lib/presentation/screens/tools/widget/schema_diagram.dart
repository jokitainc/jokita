import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';
import 'package:jokita/presentation/screens/tools/widget/schema_notifier.dart';

class SchemaDiagram extends ConsumerWidget {
  const SchemaDiagram({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemaState = ref.watch(schemaProvider);
    final graph = Graph();
    final builder = FruchtermanReingoldAlgorithm();

    // Buat map untuk akses cepat dari nama tabel ke Node object
    final Map<String, Node> tableNodeMap = {};
    for (var table in schemaState.tables) {
      final node = Node.Id(table.name);
      tableNodeMap[table.name] = node;
      graph.addNode(node);
    }

    // BAGIAN BARU: Tambahkan Edge berdasarkan data relasi
    for (var relation in schemaState.relations) {
      final fromNode = tableNodeMap[relation.fromTable];
      final toNode = tableNodeMap[relation.toTable];

      // Pastikan kedua node ada sebelum membuat edge
      if (fromNode != null && toNode != null) {
        graph.addEdge(fromNode, toNode);
      }
    }

    // Jika tidak ada node, tampilkan pesan
    if (schemaState.tables.isEmpty) {
      return const Center(child: Text('Diagram akan muncul di sini'));
    }

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      child: GraphView(
        graph: graph,
        algorithm: builder,
        paint: Paint()
          ..color = Colors.grey
          ..strokeWidth = 1,
        builder: (Node node) {
          String tableName = node.key!.value as String;
          return _buildTableNode(tableName);
        },
      ),
    );
  }

  Widget _buildTableNode(String tableName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey, width: 2),
      ),
      child: Text(tableName, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}