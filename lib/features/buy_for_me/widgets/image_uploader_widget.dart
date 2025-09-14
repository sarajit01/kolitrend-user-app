// lib/features/buy_for_me/widgets/image_uploader_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import '../../../localization/language_constrants.dart';
import '../../../utill/dimensions.dart';
import '../domain/models/image_upload_model.dart';
// Add other necessary imports: Dimensions, getTranslated, etc.
// You might need to move ImageUploadModel and ImageUploadStatus here or to a common models file.


class ImageUploaderWidget extends StatefulWidget {
  final String uploadUrl;
  final Dio dioInstance;// Pass your configured Dio instance  final Function(List<String> uploadedUrls) onUploadComplete; // Callback
  final Function(List<String> uploadedUrls) onUploadComplete; // <--- DEFINED HERE
  final int? maxImages; // Optional: to limit image count

  const ImageUploaderWidget({
    Key? key,
    required this.uploadUrl,
    required this.dioInstance,
    required this.onUploadComplete,
    this.maxImages,
  }) : super(key: key);

  @override
  _ImageUploaderWidgetState createState() => _ImageUploaderWidgetState();
}

class _ImageUploaderWidgetState extends State<ImageUploaderWidget> {
  List<ImageUploadModel> _imageUploads = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    // Cancel any ongoing uploads when the widget is disposed
    for (var model in _imageUploads) {
      if (model.status == ImageUploadStatus.uploading) {
        model.cancelToken.cancel("Upload cancelled due to widget disposal");
      }
    }
    super.dispose();
  }


  Future<void> _pickImages() async {
    if (widget.maxImages != null && _imageUploads.length >= widget.maxImages!) {
      // Show a message that max images reached
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated("Maximum images reached", context)!), // Make sure getTranslated is accessible
      ));
      return;
    }

    final List<XFile> selectedFiles = await _picker.pickMultiImage(
      imageQuality: 50, // Optional: configure image quality
    );

    if (selectedFiles.isNotEmpty) {
      List<ImageUploadModel> newUploads = [];
      for (var file in selectedFiles) {
        if (widget.maxImages != null && (_imageUploads.length + newUploads.length) >= widget.maxImages!) {
          break; // Stop if adding this file exceeds max
        }
        final newImageUpload = ImageUploadModel(file: file);
        newUploads.add(newImageUpload);
      }
      setState(() {
        _imageUploads.addAll(newUploads);
      });
      for (var newUpload in newUploads) {
        _uploadImage(newUpload);
      }
    }
  }

  void _removeImage(ImageUploadModel imageToRemove) {
    if (imageToRemove.status == ImageUploadStatus.uploading) {
      imageToRemove.cancelToken.cancel("Upload cancelled by user");
    }
    setState(() {
      _imageUploads.remove(imageToRemove);
      _notifyParent(); // Update parent with current list of completed URLs
    });
  }

  Future<void> _uploadImage(ImageUploadModel imageModel) async {
    // ... (Similar to the _uploadImage function previously discussed)
    // Use widget.uploadUrl and widget.dioInstance
    // Use imageModel.cancelToken in the dio.post call
    // On success: imageModel.uploadedUrl = ..., then call _notifyParent()
    // On failure: imageModel.error = ...
    // Ensure setState is called to update UI for progress, completion, or failure.

    setState(() {
      imageModel.status = ImageUploadStatus.uploading;
      imageModel.progress = 0.0;
    });

    String fileName = imageModel.file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageModel.file.path, filename: fileName),
      // "user_id": "123", // Example: if your API needs other data
    });

    try {
      print("upload url is " + widget.uploadUrl);
      Response response = await widget.dioInstance.post(
        widget.uploadUrl,
        data: formData,
        cancelToken: imageModel.cancelToken,
        onSendProgress: (int sent, int total) {
          if (total != 0) {
            setState(() {
              imageModel.progress = sent / total;
            });
          }
        },
      );

      print("Image upload response is ");
      print(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        setState(() {
          imageModel.status = ImageUploadStatus.completed;
          imageModel.uploadedUrl = responseData['url'] ?? responseData['file_path']; // Adjust to your API
          imageModel.progress = 1.0;
        });
        _notifyParent();
      } else {
        setState(() {
          imageModel.status = ImageUploadStatus.failed;
          imageModel.error = "Upload failed. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      print("Upload error");
      print(e.toString());
      if (e is DioException && e.type == DioExceptionType.cancel) {
        setState(() {
          imageModel.status = ImageUploadStatus.failed;
          imageModel.error = getTranslated("Upload cancelled", context); // Ensure getTranslated is accessible
        });
      } else {
        setState(() {
          imageModel.status = ImageUploadStatus.failed;
          imageModel.error = e.toString();
        });
      }
    }
  }


  void _notifyParent() {
    List<String> successfullyUploadedUrls = _imageUploads
        .where((model) => model.status == ImageUploadStatus.completed && model.uploadedUrl != null)
        .map((model) => model.uploadedUrl!)
        .toList();
    widget.onUploadComplete(successfullyUploadedUrls);
  }


  @override
  Widget build(BuildContext context) {
    // UI logic to display images, progress, status, pick button, remove button
    // This will be similar to the GridView/ListView.separated part we built before.
    // Example:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageUploads.isNotEmpty)
          Container(
            height: 120, // Or dynamic height
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _imageUploads.length,
              itemBuilder: (context, index) {
                final imageModel = _imageUploads[index];
                // Build your Stack with Image.file, CircularProgressIndicator, status icons, remove button
                // based on imageModel.status, imageModel.progress, etc.
                // (This UI part is largely the same as what we discussed for BuyForMeFormScreen)
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100, height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // Use your Dimensions.radiusSmall
                        child: Image.file(File(imageModel.file.path), fit: BoxFit.cover),
                      ),
                    ),
                    if (imageModel.status == ImageUploadStatus.uploading)
                      CircularProgressIndicator(value: imageModel.progress),
                    if (imageModel.status == ImageUploadStatus.completed)
                      Icon(Icons.check_circle, color: Colors.green, size: 40),
                    if (imageModel.status == ImageUploadStatus.failed)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 30),
                          if (imageModel.error != null && imageModel.error!.isNotEmpty)
                            Tooltip(
                              message: imageModel.error!,
                              child: Text(getTranslated("Failed", context)!, style: TextStyle(color: Colors.white, fontSize: 10, backgroundColor: Colors.black54)),
                            )
                          else
                            Text(getTranslated("Failed", context)!, style: TextStyle(color: Colors.white, fontSize: 10, backgroundColor: Colors.black54)),
                          // Optional: Add a retry button
                          // InkWell(onTap: () => _uploadImage(imageModel), child: Icon(Icons.refresh, color: Colors.blue, size: 20)),
                        ],
                      ),
                    Positioned(
                      top: 2, right: 2,
                      child: InkWell(
                        onTap: () => _removeImage(imageModel),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => SizedBox(width: 8),
            ),
          ),
        SizedBox(height: Dimensions.paddingSizeSmall), // Use your Dimensions
        InkWell(
          onTap: _pickImages,
          child: Container( /* Your "Upload Photos" / "Add More Photos" button UI */
              padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: Theme.of(context).primaryColor),
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(
                    _imageUploads.isEmpty ? getTranslated("Upload Photos", context)! : getTranslated("Add More Photos", context)!,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }
}