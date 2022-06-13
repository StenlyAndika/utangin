import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReusableWidgets {
  static bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static Future<dynamic> openCamera(int stat) async {
    return await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);
  }

  static Future<dynamic> openGallery(int stat) async {
    return await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
  }

  static inputField(
      String lbl, TextEditingController ctrl, TextInputType keyb) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        autocorrect: false,
        keyboardType: keyb,
        enableSuggestions: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(5),
          border: InputBorder.none,
          labelText: lbl,
          labelStyle:
              const TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
        ),
      ),
    );
  }

  static backAppBar(String judul, BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        judul,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pop();
        },
      ),
      elevation: 0,
    );
  }

  static alertNotification(BuildContext context, String? txt, IconData n) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          title: Icon(
            n,
            size: 40,
            color: Colors.red,
          ),
          content: Text(
            txt!,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
