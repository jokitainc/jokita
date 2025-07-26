import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:js_interop' as js;
import 'package:web/web.dart' as web;

@RoutePage()
class ImageToolPage extends StatefulWidget {
  const ImageToolPage({super.key});

  @override
  State<ImageToolPage> createState() => _ImageToolPageState();
}

class _ImageToolPageState extends State<ImageToolPage> {
  Uint8List? _imageBytes;
  Uint8List? _convertedBytes;
  String _selectedFormat = 'jpg';
  bool _isProcessing = false;
  String? _outputPath;
  
  final List<String> _formats = ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'tiff'];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 4096,
        maxHeight: 4096,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final Uint8List bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _convertedBytes = null;
          _outputPath = null;
        });
      }
    } catch (e) {
      String errorMessage = 'Error picking image';
      if (e.toString().contains('MissingPluginException')) {
        errorMessage = 'Image picker not properly configured. Please check platform setup.';
      } else if (e.toString().contains('Permission')) {
        errorMessage = 'Permission denied. Please allow gallery access.';
      }
      _showError('$errorMessage: $e');
    }
  }

  Future<void> _convertImage() async {
    if (_imageBytes == null) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // Decode image dengan optimasi memory
      final img.Image? image = await _decodeImageInBackground(_imageBytes!);
      
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Encode ke format baru
      final Uint8List convertedBytes = await _encodeImageInBackground(image, _selectedFormat);
      
      // Save file
      final String outputPath = await _saveConvertedImage(convertedBytes, _selectedFormat);
      
      setState(() {
        _convertedBytes = convertedBytes;
        _outputPath = outputPath;
        _isProcessing = false;
      });
      
      _showSuccess('Image converted successfully!');
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showError('Conversion failed: $e');
    }
  }

  Future<img.Image?> _decodeImageInBackground(Uint8List bytes) async {
    return await Future.microtask(() {
      return img.decodeImage(bytes);
    });
  }

  Future<Uint8List> _encodeImageInBackground(img.Image image, String format) async {
    return await Future.microtask(() {
      switch (format.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          return Uint8List.fromList(img.encodeJpg(image, quality: 85));
        case 'png':
          return Uint8List.fromList(img.encodePng(image));
        case 'webp':
        case 'bmp':
          return Uint8List.fromList(img.encodeBmp(image));
        case 'gif':
          return Uint8List.fromList(img.encodeGif(image));
        case 'tiff':
          return Uint8List.fromList(img.encodeTiff(image));
        default:
          return Uint8List.fromList(img.encodeJpg(image, quality: 85));
      }
    });
  }

  Future<String> _saveConvertedImage(Uint8List bytes, String format) async {
    if (kIsWeb) {
      // For web, we'll return a data URL or use a temporary approach
      return 'web_converted_image.$format';
    } else {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'converted_$timestamp.$format';
      final String filePath = '${appDir.path}/$fileName';
      
      final File outputFile = File(filePath);
      await outputFile.writeAsBytes(bytes);
      
      return filePath;
    }
  }

  Future<void> _shareImage() async {
    if (kIsWeb && _convertedBytes != null) {
      _downloadImageWeb(_convertedBytes!, _selectedFormat);
    } else if (_outputPath != null) {
      final params = ShareParams(
        text: 'Converted image - $_selectedFormat format',
        files: [XFile(_outputPath!)],
      );
      
      final result = await SharePlus.instance.share(params);
      
      if (result.status == ShareResultStatus.success) {
        _showSuccess('Image shared successfully!');
      }
    }
  }

  void _downloadImageWeb(Uint8List bytes, String format) {
    final String mimeType = _getMimeType(format);
    final web.Blob blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mimeType));
    final String url = web.URL.createObjectURL(blob);
    
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'converted_image_$timestamp.$format';
    
    final web.HTMLAnchorElement _ = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..click();
    
    web.URL.revokeObjectURL(url);
    _showSuccess('Image downloaded successfully!');
  }

  String _getMimeType(String format) {
    switch (format.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'gif':
        return 'image/gif';
      case 'tiff':
        return 'image/tiff';
      default:
        return 'image/jpeg';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Formatter'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imageBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _imageBytes!,
                        fit: BoxFit.contain,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No image selected', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
            ),
            
            SizedBox(height: 24),
            
            // Pick Image Button
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_library),
              label: Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            
            SizedBox(height: 24),
            
            // Format Selection
            Text('Select Output Format:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _selectedFormat,
                isExpanded: true,
                underline: SizedBox(),
                items: _formats.map((format) {
                  return DropdownMenuItem(
                    value: format,
                    child: Text(format.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFormat = value!;
                  });
                },
              ),
            ),
            
            SizedBox(height: 24),
            
            // Convert Button
            ElevatedButton.icon(
              onPressed: _imageBytes != null && !_isProcessing ? _convertImage : null,
              icon: _isProcessing 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.transform),
              label: Text(_isProcessing ? 'Converting...' : 'Convert Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Share Button
            if (_outputPath != null || (_convertedBytes != null && kIsWeb))
              ElevatedButton.icon(
                onPressed: _shareImage,
                icon: Icon(kIsWeb ? Icons.download : Icons.share),
                label: Text(kIsWeb ? 'Download Image' : 'Share Converted Image'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
