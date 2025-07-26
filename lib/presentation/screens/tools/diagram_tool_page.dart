import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jokita/presentation/screens/tools/widget/schema_diagram.dart';
import 'package:jokita/presentation/screens/tools/widget/schema_editor.dart';

@RoutePage()
class DiagramToolPage extends StatefulWidget {
  const DiagramToolPage({super.key});

  @override
  State<DiagramToolPage> createState() => _DiagramToolPageState();
}

class _DiagramToolPageState extends State<DiagramToolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter DB Schema Designer'),
          backgroundColor: Colors.blueGrey[800],
        ),
        body: const Row(
          children: [
            Expanded(
              flex: 1,
              child: SchemaEditor(), // Panel Kiri: Text Editor
            ),
            VerticalDivider(width: 1),
            Expanded(
              flex: 2,
              child: SchemaDiagram(), // Panel Kanan: Diagram
            ),
          ],
        ),
      );
  }
}