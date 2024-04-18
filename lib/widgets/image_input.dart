import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
// import 'package:sisaku/colors.dart';
import 'package:tangan/pages/setting_page.dart';

class ImageInput extends StatefulWidget {
  final Function imagesaveat;
  // ImageInput(this.imagesaveat);
  const ImageInput({super.key, required this.imagesaveat});
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _imageFile;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (imageFile == null) {
      return;
    }

    setState(() {
      _imageFile = File(imageFile.path);
    });

    final apDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final saveImagepath = await _imageFile!.copy('${apDir.path}/$fileName');

    widget.imagesaveat(saveImagepath);
  }

  Future<void> _galleryPicture() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (imageFile == null) {
      return;
    }

    setState(() {
      _imageFile = File(imageFile.path);
    });

    final apDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final saveImagepath = await _imageFile!.copy('${apDir.path}/$fileName');

    widget.imagesaveat(saveImagepath);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration:
                BoxDecoration(border: Border.all(width: 2, color: primary)),
            // ignore: unnecessary_null_comparison
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : Center(
                    child: Text(
                      (lang == 0) ? 'Belum ada gambar' : 'No image',
                      style: TextStyle(color: isDark ? base : Colors.black),
                    ),
                  ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: _galleryPicture,
                  icon: Icon(
                    Icons.image,
                    color: primary,
                  ),
                  label: Text(
                    (lang == 0) ? 'Ambil dari galeri' : 'From Gallery',
                    style: TextStyle(color: primary),
                  )),
              TextButton.icon(
                  onPressed: _takePicture,
                  icon: Icon(
                    Icons.camera,
                    color: primary,
                  ),
                  label: Text(
                    (lang == 0) ? 'Gunakan kamera' : "Use Camera",
                    style: TextStyle(color: primary),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
