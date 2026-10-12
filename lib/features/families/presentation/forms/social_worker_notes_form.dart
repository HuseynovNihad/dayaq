import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/document_pdf_service.dart';

class FamilyLocalDocument {
  const FamilyLocalDocument({
    required this.id,
    required this.title,
    required this.name,
    required this.path,
    required this.sizeBytes,
    this.isImage = false, 
  });

  final String id;
  final String title;
  final String name;
  final String path;
  final int sizeBytes;
  final bool isImage;

  File get file => File(path);

  FamilyLocalDocument copyWith({String? title}) => FamilyLocalDocument(
    id: id,
    title: title ?? this.title,
    name: name,
    path: path,
    sizeBytes: sizeBytes,
    isImage: isImage,
  );
}

class SocialWorkerNotesForm extends StatefulWidget {
  const SocialWorkerNotesForm({
    super.key,
    required this.notesController,
    required this.documents,
  });

  final TextEditingController notesController;
  final List<FamilyLocalDocument> documents;

  @override
  State<SocialWorkerNotesForm> createState() => _SocialWorkerNotesFormState();
}

class _SocialWorkerNotesFormState extends State<SocialWorkerNotesForm> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _busy = false;
  int _serial = 0;

  String _newId() => '${DateTime.now().microsecondsSinceEpoch}_${_serial++}';

  void _message(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _displaySize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool _isImageName(String name) {
    final lower = name.toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.webp'].any(lower.endsWith);
  }

  /// A required title for a newly created/imported PDF, or title editing.
  Future<String?> _askForTitle({
    required String fileName,
    String? currentTitle,
  }) async {
    final controller = TextEditingController(text: currentTitle ?? '');
    final formKey = GlobalKey<FormState>();
    try {
      return await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            currentTitle == null ? 'Sənədin başlığı' : 'Başlığı redaktə et',
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                TextFormField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Başlıq *',
                    hintText: 'Məsələn: Şəxsiyyət vəsiqəsi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Başlıq daxil edin.'
                      : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Ləğv et'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.pop(dialogContext, controller.text.trim());
                }
              },
              child: const Text('Yadda saxla'),
            ),
          ],
        ),
      );
    } finally {
      // Allow the dialog's exit transition to complete before disposal.
      Future<void>.delayed(
        const Duration(milliseconds: 350),
        controller.dispose,
      );
    }
  }

  Future<void> _addImagesAsOnePdf(List<String> paths) async {
    if (paths.isEmpty || !mounted) return;
    final title = await _askForTitle(fileName: '${paths.length} şəkil → 1 PDF');
    if (!mounted || title == null) return;

    try {
      final created = await DocumentPdfService.createFromImages(paths);
      if (!mounted) {
        await DocumentPdfService.deleteStoredFile(created.path);
        return;
      }
      setState(() {
        widget.documents.add(
          FamilyLocalDocument(
            id: _newId(),
            title: title,
            name: created.uri.pathSegments.last,
            path: created.path,
            sizeBytes: created.lengthSync(),
          ),
        );
      });
      _message('PDF hazırdır: ${paths.length} səhifə.');
    } catch (e) {
      _message('PDF yaratmaq mümkün olmadı: $e');
    }
  }

  Future<void> _addExistingPdf(String path, String originalName) async {
    if (!mounted) return;
    final title = await _askForTitle(fileName: originalName);
    if (!mounted || title == null) return;

    try {
      final copied = await DocumentPdfService.importPdf(path);
      if (!mounted) {
        await DocumentPdfService.deleteStoredFile(copied.path);
        return;
      }
      setState(() {
        widget.documents.add(
          FamilyLocalDocument(
            id: _newId(),
            title: title,
            name: copied.uri.pathSegments.last,
            path: copied.path,
            sizeBytes: copied.lengthSync(),
          ),
        );
      });
      _message('PDF siyahıya əlavə edildi.');
    } catch (e) {
      _message('PDF əlavə edilə bilmədi: $e');
    }
  }

  /// Capture one or more sides, then convert them into a single PDF.
  Future<void> _takePicture() async {
    if (_busy) return;
    setState(() => _busy = true);
    final paths = <String>[];
    try {
      while (mounted) {
        final photo = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (photo == null || !mounted) break;
        paths.add(photo.path);

        final choice = await showDialog<_PhotoAction>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Sənədin şəkilləri'),
            content: Text(
              '${paths.length} şəkil çəkildi. Digər üzünü/səhifəni də əlavə etmək istəyirsiniz?',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, _PhotoAction.cancel),
                child: const Text('Ləğv et'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, _PhotoAction.more),
                child: const Text('Daha bir şəkil'),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, _PhotoAction.finish),
                child: const Text('PDF yarat'),
              ),
            ],
          ),
        );
        if (!mounted || choice == _PhotoAction.cancel) return;
        if (choice == _PhotoAction.finish) {
          await _addImagesAsOnePdf(paths);
          return;
        }
      }
      // If camera was closed after capturing some pages, retain those pages.
      if (mounted && paths.isNotEmpty) await _addImagesAsOnePdf(paths);
    } catch (_) {
      _message('Kamera açıla bilmədi. İcazələri yoxlayın.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickGalleryPhotos() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final photos = await _imagePicker.pickMultiImage(imageQuality: 85);
      if (!mounted || photos.isEmpty) return;
      await _addImagesAsOnePdf(photos.map((p) => p.path).toList());
    } catch (_) {
      _message('Qalereyadan şəkil seçmək mümkün olmadı.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFiles() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );
      if (!mounted || files.isEmpty) return;

      final imagePaths = <String>[];
      final pdfFiles = <PlatformFile>[];
      for (final picked in files) {
        final path = picked.path;
        if (path == null || !await File(path).exists()) {
          _message('${picked.name}: fayla giriş mümkün deyil.');
          continue;
        }
        if (_isImageName(picked.name)) {
          imagePaths.add(path);
        } else if (picked.name.toLowerCase().endsWith('.pdf')) {
          pdfFiles.add(picked);
        }
      }
      if (imagePaths.isNotEmpty) await _addImagesAsOnePdf(imagePaths);
      for (final pdfFile in pdfFiles) {
        if (!mounted) return;
        await _addExistingPdf(pdfFile.path!, pdfFile.name);
      }
    } catch (_) {
      _message('Faylları seçmək mümkün olmadı.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _editTitle(FamilyLocalDocument document) async {
    final title = await _askForTitle(
      fileName: document.name,
      currentTitle: document.title,
    );
    if (!mounted || title == null) return;
    final index = widget.documents.indexWhere((d) => d.id == document.id);
    if (index == -1) return;
    setState(() => widget.documents[index] = document.copyWith(title: title));
  }

  Future<void> _deleteDocument(FamilyLocalDocument document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sənədi sil?'),
        content: Text('“${document.title}” siyahıdan çıxarılacaq.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('İmtina'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => widget.documents.removeWhere((d) => d.id == document.id));
    try {
      await DocumentPdfService.deleteStoredFile(document.path);
    } catch (_) {
      _message('Lokal faylı silmək mümkün olmadı.');
    }
  }

  Widget _actionButton(String label, IconData icon, VoidCallback? onPressed) {
    return SizedBox(
      height: 54.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 19.r),
        label: Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          backgroundColor: const Color(0xFFF2F2F2),
          side: const BorderSide(color: Color(0xFFCFC9C7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }

  Widget _documentCard(FamilyLocalDocument doc) => Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE2E0DF)),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Row(
      children: [
        Container(
          height: 46.r,
          width: 46.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE9EA),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Icon(
            Icons.picture_as_pdf_rounded,
            color: Color(0xFFE02027),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doc.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                doc.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${_displaySize(doc.sizeBytes)} • PDF hazırdır (göndərilməyib)',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _busy ? null : () => _editTitle(doc),
          tooltip: 'Başlığı redaktə et',
          icon: const Icon(Icons.edit_outlined, color: Color(0xFF173CBD)),
        ),
        IconButton(
          onPressed: _busy ? null : () => _deleteDocument(doc),
          tooltip: 'Sənədi sil',
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Sosial işçinin qeydləri',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Daxili istifadə',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: widget.notesController,
          minLines: 4,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText:
                'Ailənin yaşayış şəraiti, ehtiyacları və sosial vəziyyəti haqqında qeydlərinizi yazın...',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16.r),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: const BorderSide(color: Color(0xFFD8D3D0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Expanded(
              child: Text(
                'Əlavə edilmiş sənədlər (${widget.documents.length})',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Yalnız PDF',
              style: context.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF173CBD),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _actionButton(
                'Şəkil çək',
                Icons.camera_alt_rounded,
                _busy ? null : _takePicture,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _actionButton(
                'Qalereya',
                Icons.photo_library_outlined,
                _busy ? null : _pickGalleryPhotos,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: double.infinity,
          child: _actionButton(
            'Fayl seç (PDF / şəkil)',
            Icons.folder_rounded,
            _busy ? null : _pickFiles,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            color: const Color(0xFFF7F7F7),
            border: Border.all(
              color: const Color(0xFFC9C2C0),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload_rounded,
                color: const Color(0xFF737373),
                size: 34.r,
              ),
              SizedBox(height: 8.h),
              Text(
                'Şəkillər avtomatik PDF-ə çevriləcək',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Bir neçə şəkil = bir çoxsəhifəli PDF',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (_busy) ...[
          SizedBox(height: 14.h),
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ],
        SizedBox(height: 18.h),
        ...widget.documents.map(_documentCard),
        SizedBox(height: 16.h),
      ],
    );
  }
}

enum _PhotoAction { cancel, more, finish }
