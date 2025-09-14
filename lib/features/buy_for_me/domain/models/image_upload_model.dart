
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
enum ImageUploadStatus {
  idle, uploading, completed, failed
}

class ImageUploadModel {
  final XFile file; // The image file picked
  ImageUploadStatus status;
  double progress; // 0.0 to 1.0
  String? uploadedUrl; // URL after successful upload
  String? error; // Error message if failed
  CancelToken cancelToken; // For cancelling uploads

  ImageUploadModel({
    required this.file,
    this.status = ImageUploadStatus.idle,
    this.progress = 0.0,
    this.uploadedUrl,
    this.error,
  }) : cancelToken = CancelToken();
}