import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Ganti path ini sesuai struktur proyek Anda
import 'package:jokita/presentation/screens/tools/widget/schema_notifier.dart'; 

class SchemaEditor extends ConsumerStatefulWidget {
  const SchemaEditor({super.key});
  @override
  ConsumerState<SchemaEditor> createState() => _SchemaEditorState();
}

class _SchemaEditorState extends ConsumerState<SchemaEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Contoh teks awal dengan berbagai kasus valid dan error
    const initialText = '''
// Relasi yang Benar
Table users {
  id integer [pk]
  name varchar
}

Table profiles {
  id integer [pk]
  user_id integer [unique] // Benar untuk one-to-one
  bio text
}

Ref: profiles.user_id - users.id // Relasi one-to-one

Table posts {
  id integer [pk]
  author_id integer
  title varchar
}

Ref: posts.author_id > users.id // Relasi one-to-many

// --- CONTOH ERROR DI BAWAH ---

Table products {
    id integer [pk]
    seller_id varchar // Tipe data salah
}

// Error: Tipe data tidak cocok (varchar vs integer)
Ref: products.seller_id > users.id

Table orders {
    id integer [pk]
    product_name varchar // Bukan PK atau Unique
}

// Error: Target relasi bukan PK atau Unique
Ref rel_salah: products.id > orders.product_name

// Error: Nama relasi 'rel_salah' sudah dipakai
Ref rel_salah: posts.id > users.id
''';
    _controller = TextEditingController(text: initialText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(schemaProvider.notifier).processText(initialText);
    });

    _controller.addListener(() {
      ref.read(schemaProvider.notifier).processText(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errors = ref.watch(schemaProvider.select((s) => s.errors));
    
    return Container(
      color: const Color(0xFF1e1e1e),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          // Panel Error
          if (errors.isNotEmpty)
            Container(
              height: 160,
              width: double.infinity,
              color: const Color(0xFF5f2120),
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: errors.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "❌ ${errors[index].message}",
                      style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
