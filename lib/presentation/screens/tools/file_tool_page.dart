
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';

@RoutePage()
class FileToolPage extends StatefulWidget {
  const FileToolPage({super.key});

  @override
  State<FileToolPage> createState() => _FileToolPageState();
}

class _FileToolPageState extends State<FileToolPage> {
  PlatformFile? _pickedFile;
  String? _conversionFrom;
  String? _conversionTo;
  bool _isConverting = false;
  String _status = '';

  // Daftar konversi yang mungkin
  final Map<String, List<String>> _supportedConversions = {
    'pdf': ['txt', 'jpg'],
    'txt': ['pdf'],
    // Konversi berikut ini sangat kompleks dan biasanya memerlukan server
    'docx': ['pdf', 'txt'],
    'pptx': ['pdf'],
    'xlsx': ['pdf', 'csv'],
    'html': ['pdf'],
    // ZIP/RAR adalah pengarsipan, bukan konversi format langsung
    'zip': ['unzip'],
    'rar': ['unrar'],
  };

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        _conversionFrom = _pickedFile!.extension?.toLowerCase();
        _conversionTo = null; // Reset pilihan konversi
        _status = 'File selected: ${_pickedFile!.name}';
      });
    }
  }

  Future<void> _convertFile() async {
    if (_pickedFile == null || _conversionFrom == null || _conversionTo == null) {
      return;
    }

    setState(() {
      _isConverting = true;
      _status = 'Converting...';
    });

    try {
      Uint8List? outputFileBytes;
      String outputFileName = '${_pickedFile!.name.split('.').first}.$_conversionTo';

      // === Logika Konversi ===
      if (_conversionFrom == 'pdf' && _conversionTo == 'txt') {
        outputFileBytes = await _convertPdfToTxt(_pickedFile!.bytes!);
      } else if (_conversionFrom == 'txt' && _conversionTo == 'pdf') {
        outputFileBytes = await _convertTxtToPdf(_pickedFile!.bytes!);
      } else {
        // Placeholder untuk konversi yang memerlukan backend
        await _handleComplexConversion();
        return; // Keluar karena ditangani secara terpisah
      }

      await FileSaver.instance.saveFile(
        name: outputFileName,
        bytes: outputFileBytes,
      );
      _status = 'Conversion successful! File saved as $outputFileName';
        } catch (e) {
      _status = 'An error occurred: $e';
    } finally {
      setState(() {
        _isConverting = false;
      });
    }
  }

  // --- Implementasi Konversi Sisi Klien ---

  Future<Uint8List> _convertPdfToTxt(Uint8List pdfBytes) async {
    // NOTE: Paket `pdf` tidak secara langsung mengekstrak teks dengan mudah.
    // Implementasi ini adalah placeholder.
    // Untuk ekstraksi teks nyata, Anda mungkin memerlukan paket seperti `syncfusion_flutter_pdf` (berbayar)
    // atau mengirimnya ke backend.
    // Kode ini hanya akan membuat file txt dengan pesan placeholder.
    final String placeholderText =
        "Text extraction from PDF is complex on the client-side. This is a placeholder.";
    return Uint8List.fromList(placeholderText.codeUnits);
  }

  Future<Uint8List> _convertTxtToPdf(Uint8List txtBytes) async {
    final pdf = pw.Document();
    final textContent = String.fromCharCodes(txtBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Paragraph(text: textContent);
        },
      ),
    );

    return pdf.save();
  }

  // --- Placeholder untuk Konversi Kompleks ---
  Future<void> _handleComplexConversion() async {
    // Simulasi panggilan API ke backend
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _status =
          'This conversion type ($_conversionFrom to $_conversionTo) requires a server-side process which is not implemented in this demo.';
      _isConverting = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final possibleDestinations = _supportedConversions[_conversionFrom] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Converter Tools'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Pick a File'),
              onPressed: _pickFile,
            ),
            if (_pickedFile != null) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected File:', style: Theme.of(context).textTheme.titleMedium),
                      Text(_pickedFile!.name),
                      Text('Size: ${(_pickedFile!.size / 1024).toStringAsFixed(2)} KB'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _conversionFrom,
                      items: const [], // Dibuat statis karena sudah ditentukan dari file
                      onChanged: null, // Tidak bisa diubah
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward),
                  ),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _conversionTo,
                      hint: const Text('Select'),
                      items: possibleDestinations
                          .map((to) => DropdownMenuItem(value: to, child: Text(to.toUpperCase())))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _conversionTo = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_pickedFile == null || _conversionTo == null || _isConverting)
                    ? null
                    : _convertFile,
                child: _isConverting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Convert'),
              ),
              const SizedBox(height: 20),
              if (_status.isNotEmpty) ...[
                Text(
                  _status,
                  textAlign: TextAlign.center,
                ),
              ]
            ],
          ],
        ),
      ),
    );
  }
}
