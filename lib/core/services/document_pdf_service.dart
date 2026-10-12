import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentPdfService {
  DocumentPdfService._();

  static const int maxPdfBytes = 15 * 1024 * 1024;
  static int _sequence = 0;

  static Future<Directory> _documentDirectory() async {
    final root = await getApplicationSupportDirectory();
    final dir = Directory('${root.path}/family_registration_documents');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<File> _newDestination() async {
    final directory = await _documentDirectory();
    final id = '${DateTime.now().microsecondsSinceEpoch}_${_sequence++}';
    return File('${directory.path}/document_$id.pdf');
  }

  static Future<File> createFromImages(List<String> imagePaths) async {
    if (imagePaths.isEmpty) {
      throw ArgumentError('Ən azı bir şəkil seçilməlidir.');
    }

    final pdf = pw.Document(compress: true);
    for (final path in imagePaths) {
      final file = File(path);
      if (!await file.exists()) throw StateError('Şəkil tapılmadı: $path');

      final decoded = img.decodeImage(await file.readAsBytes());
      if (decoded == null) throw StateError('Şəkil oxuna bilmədi.');

      // Bake EXIF orientation and reduce image dimensions for smaller PDFs.
      final oriented = img.bakeOrientation(decoded);
      final scaled = oriented.width > 1800 || oriented.height > 1800
          ? img.copyResize(
              oriented,
              width: oriented.width >= oriented.height ? 1800 : null,
              height: oriented.height > oriented.width ? 1800 : null,
            )
          : oriented;
      final jpgBytes = img.encodeJpg(scaled, quality: 78);
      final memoryImage = pw.MemoryImage(jpgBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(18),
          build: (_) =>
              pw.Center(child: pw.Image(memoryImage, fit: pw.BoxFit.contain)),
        ),
      );
    }

    final output = await _newDestination();
    try {
      await output.writeAsBytes(await pdf.save(), flush: true);
      final size = await output.length();
      if (size == 0 || size > maxPdfBytes) {
        throw StateError('PDF 15 MB limitini aşır və ya boşdur.');
      }
      return output;
    } catch (_) {
      if (await output.exists()) await output.delete();
      rethrow;
    }
  }

  static Future<File> importPdf(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) throw StateError('PDF faylı tapılmadı.');
    final size = await source.length();
    if (size <= 0 || size > maxPdfBytes) {
      throw StateError('PDF 0-dan böyük və ən çox 15 MB olmalıdır.');
    }
    final output = await _newDestination();
    try {
      await source.copy(output.path);
      return output;
    } catch (_) {
      if (await output.exists()) await output.delete();
      rethrow;
    }
  }

  static Future<void> deleteStoredFile(String path) async {
    final dir = await _documentDirectory();
    final base = dir.absolute.path;
    final candidate = File(path).absolute.path;
    if (!candidate.startsWith('$base${Platform.pathSeparator}')) return;
    final file = File(candidate);
    if (await file.exists()) await file.delete();
  }
}
