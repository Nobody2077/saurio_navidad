import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoService {
  PhotoService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pickAndSavePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 88,
      maxWidth: 1600,
    );
    if (picked == null) {
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/saurio_photos');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final extension = picked.path.split('.').last.toLowerCase();
    final safeExtension = extension.length <= 5 ? extension : 'jpg';
    final target =
        '${folder.path}/memory_${DateTime.now().microsecondsSinceEpoch}.$safeExtension';
    final saved = await File(picked.path).copy(target);
    return saved.path;
  }
}
