import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/evaluasi_pinjaman_services.dart';
import '../../../template/reusablewidgets.dart';

class UploadBuktiPeminjaman extends StatefulWidget {
  UploadBuktiPeminjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageuploadbuktipeminjaman';

  @override
  State<UploadBuktiPeminjaman> createState() => _UploadBuktiPeminjamanState();
}

class _UploadBuktiPeminjamanState extends State<UploadBuktiPeminjaman> {
  File? _bukti;

  void showOptionMenu(int stat) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 120,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.folder),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ReusableWidgets.openGallery(stat).then((pickedImage) {
                      if (pickedImage != null) {
                        setState(() {
                          _bukti = File(pickedImage!.path);
                        });
                      }
                    });
                  },
                  label: Text(
                    "Gallery",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ReusableWidgets.openCamera(stat).then((pickedImage) {
                      if (pickedImage != null) {
                        setState(() {
                          _bukti = File(pickedImage!.path);
                        });
                      }
                    });
                  },
                  label: Text(
                    "Kamera",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<EvaluasiPinjamanServices>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            "img/primary-background.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.white.withOpacity(0.7),
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: MediaQuery.of(context).size.height * 0.05),
            child: ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "U",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " T A N G I N . C O M",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Bukti Peminjaman",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: _bukti == null ? Text("") : Image.file(_bukti!),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    showOptionMenu(0);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 112, 110, 110),
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Upload Bukti Peminjaman",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_bukti == null) {
                      return ReusableWidgets.alertNotification(context,
                          "Bukti peminjaman belum dipilih.", Icons.error);
                    }
                    final prefs = await SharedPreferences.getInstance();
                    String? idp = await prefs.getString('idp');
                    config.konfirmasi(idp, _bukti, context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Kirim",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
