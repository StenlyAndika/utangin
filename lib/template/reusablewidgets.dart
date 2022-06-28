import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';
import '../pages/home/user/data_rekening.dart';

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
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 184, 174, 174)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: ctrl,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        autocorrect: false,
        keyboardType: keyb,
        enableSuggestions: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          border: InputBorder.none,
          labelText: lbl,
          labelStyle: TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
        ),
      ),
    );
  }

  static inputReadOnlyField(
      String lbl, TextEditingController ctrl, TextInputType keyb) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 184, 174, 174)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: ctrl,
        style: TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 53, 51, 51),
        ),
        readOnly: true,
        cursorColor: Colors.black,
        autocorrect: false,
        keyboardType: keyb,
        enableSuggestions: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(5),
          border: InputBorder.none,
          labelText: lbl,
          labelStyle: TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
        ),
      ),
    );
  }

  static backAppBar(String judul, BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        judul,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      leading: IconButton(
        icon: Icon(
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
        duration: Duration(milliseconds: 1500),
        child: AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
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

  static menuPengaturan(context) {
    final auth = Provider.of<AuthServices>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 0),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "U",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " T A N G I N . C O M",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Pengaturan",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(DataRekening.nameRoute);
                },
                child: Text("Data Rekening"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                ),
              ),
              Divider(),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  auth.logout(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  static notificationMessage(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }
}
