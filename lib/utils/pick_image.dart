import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: imageSource);

  if (file != null) {
    return await file.readAsBytes();
  }

  debugPrint('No image selected');
}
