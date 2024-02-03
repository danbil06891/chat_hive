import 'package:flutter/material.dart';

class ImageDialogWidget extends StatelessWidget {
  final Function onClick;

  const ImageDialogWidget({Key? key,required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: const Text(
                'Camera',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => onClick('camera'),
            ),
            const SizedBox(
                height: 40
            ),
            InkWell(
              child: const Text(
                'Gallery',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                onClick('gallery');
              },
            ),
          ],
        ),
      ),
    );
  }
}
