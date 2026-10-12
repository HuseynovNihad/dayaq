import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/family_details_entity.dart';
import 'detail_common_widgets.dart';

class FamilyDocumentsTab extends StatelessWidget {
  const FamilyDocumentsTab({super.key, required this.details});
  final FamilyDetailsEntity details;
  bool _isPdf(String path) => path.toLowerCase().contains('.pdf');
  String _fileName(String path) {
    final uri = Uri.tryParse(path);
    final segments = uri?.pathSegments ?? [];
    if (segments.isEmpty) return path;
    return Uri.decodeComponent(segments.last);
  }

  Future<void> _openDocument(BuildContext context, String path) async {
    final uri = Uri.tryParse(path);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sənəd üçün açıq keçid mövcud deyil.')),
      );
      return;
    }
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sənədi açmaq mümkün olmadı.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Əlavə edilmiş sənədlər',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        if (details.documents.isEmpty)
          const DetailEmptySection(
            icon: Icons.folder_open_rounded,
            message: 'Əlavə edilmiş sənəd yoxdur.',
          )
        else
          ...details.documents.map((document) {
            final file = document.file.trim();
            final pdf = _isPdf(file);
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: DetailCard(
                child: Row(
                  children: [
                    Container(
                      width: 46.r,
                      height: 46.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: pdf
                            ? const Color(0xFFFFE9EB)
                            : const Color(0xFFE7F0FF),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        pdf
                            ? Icons.picture_as_pdf_rounded
                            : Icons.insert_drive_file_rounded,
                        color: pdf
                            ? const Color(0xFFD82430)
                            : const Color(0xFF1642B7),
                        size: 25.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _fileName(file),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (file.isNotEmpty)
                      IconButton(
                        tooltip: 'Sənədi aç',
                        onPressed: () => _openDocument(context, file),
                        icon: Icon(
                          Icons.visibility_outlined,
                          size: 21.r,
                          color: const Color(0xFF1745B7),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: Text(
                'Sosial işçinin qeydləri',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '${details.notes.length} qeyd',
              style: context.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF777777),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (details.notes.isEmpty)
          const DetailEmptySection(
            icon: Icons.notes_rounded,
            message: 'Sosial işçi qeydi yoxdur.',
          )
        else
          ...details.notes.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFE4E4E4)),
                ),
                child: Text(
                  item.note,
                  style: context.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
