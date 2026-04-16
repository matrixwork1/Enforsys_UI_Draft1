import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Shared image picker helper used by create_opn_popup and new_offence_screen.
/// Consolidates the nearly identical pick-from-gallery / pick-from-camera logic.
class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();

  ImagePickerUtils._();

  /// Picks an image from the gallery, respecting [maxImages] limit.
  /// Returns the picked [File], or null if cancelled / at capacity.
  static Future<File?> pickFromGallery({
    required int currentCount,
    int maxImages = 3,
  }) async {
    if (currentCount >= maxImages) return null;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Unable to access gallery: $e');
    }
    return null;
  }

  /// Picks an image from the camera, respecting [maxImages] limit.
  /// Returns the picked [File], or null if cancelled / at capacity.
  static Future<File?> pickFromCamera({
    required int currentCount,
    int maxImages = 3,
  }) async {
    if (currentCount >= maxImages) return null;
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Unable to access camera: $e');
    }
    return null;
  }

  /// Shows a standard image-source picker bottom sheet (Camera / Gallery).
  static void showImageSourcePicker(
    BuildContext context, {
    required int currentCount,
    int maxImages = 3,
    required ValueChanged<File> onImagePicked,
  }) {
    if (currentCount >= maxImages) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.camera_alt_outlined,
                      color: Color(0xFFF5A623), size: 22),
                ),
                title: const Text('Camera',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final file = await pickFromCamera(
                    currentCount: currentCount,
                    maxImages: maxImages,
                  );
                  if (file != null) onImagePicked(file);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.photo_library_outlined,
                      color: Color(0xFFF5A623), size: 22),
                ),
                title: const Text('Gallery',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final file = await pickFromGallery(
                    currentCount: currentCount,
                    maxImages: maxImages,
                  );
                  if (file != null) onImagePicked(file);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
