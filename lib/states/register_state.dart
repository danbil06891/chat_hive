import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterState extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  


  File? selectImage;
  String? _selectedType;
  String? get selectedType => _selectedType;

  void selectType(String? value){
   _selectedType = value;
   notifyListeners();
  }

  void selectImageFile(File? image) async {

    if (image != null) {
      selectImage = image;
      notifyListeners();
    } else {
      selectImage = null;
      notifyListeners();
    }
  }
}
