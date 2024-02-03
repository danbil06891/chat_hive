import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utills/snippets.dart';
import 'circular_image_view.dart';
import 'dialog_widget.dart';

// ignore: must_be_immutable
class ImagePickerWidget extends StatelessWidget {
  File? image;
  final String? initialUrl;
  final void Function(File) onImageSelected;

  ImagePickerWidget({
    Key? key,
    required this.image,
    required this.onImageSelected,
    this.initialUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(children: [
        CircularImageView(
          size: 120,
          child: image != null
              ? Image.file(image!, fit: BoxFit.cover)
              : initialUrl != null
                  ? Image.network(initialUrl!, fit: BoxFit.cover)
                  : Image.asset(
                      'assets/images/dummy_house.jpeg',
                      scale: .5,
                    ),
        ),
        Positioned.fill(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(60),
          ),
        )),
        Positioned.fill(
          child: IconButton(
            icon: Icon(
              image != null ? Icons.camera_alt_outlined : Icons.add_a_photo,
              size: 32,
            ),
            onPressed: () {
              showDialogOf(context, ImageDialogWidget(
                onClick: (ref) async {
                  if (ref.toString().contains("camera")) {
                    pickImage(ImageSource.camera);
                  } else {
                    pickImage(ImageSource.gallery);
                  }
                  pop(context);
                },
              ));
            },
          ),
        ),
      ]),
    );
  }

  void pickImage(ImageSource source) async {
    final pickedImage =
        await ImagePicker().pickImage(source: source, imageQuality: 30);
    if (pickedImage == null) return;
    onImageSelected(File(pickedImage.path));
  }
}
