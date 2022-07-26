import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../pages/home/lender/evaluasi_pinjaman.dart';

class NotifPeminjamanTerdokumentasi extends StatelessWidget {
  NotifPeminjamanTerdokumentasi({Key? key}) : super(key: key);

  static const nameRoute = '/pagepinjamanterdokumentasi';

  Future openFile({required String url, String? fileName}) async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    var status2 = await Permission.storage.status;
    if (!status2.isGranted) {
      await Permission.storage.request();
    }
    final file = await downloadFile(url, fileName!);
    if (file == null) return;
    print('Path: ${file.path}');
    return file.path;
  }

  Future<File?> downloadFile(String url, String name) async {
    final appStorage = Directory('/storage/emulated/0/Download');

    final file = File('${appStorage.path}/$name');

    try {
      final response2 = await http.get(Uri.parse(url));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response2.bodyBytes);
      await raf.close();

      return file;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(EvaluasiPinjaman.nameRoute),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Image.asset(
            "img/secondary-background.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "U",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " T A N G I N . C O M",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selamat",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.celebration,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  Text(
                    "peminjamanmu telah terdokumentasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Cek riwayat peminjamanmu untuk mengetahui kondisi terbaru atas peminjamanmu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      var kdt = prefs.getString('kdt');
                      openFile(
                              url:
                                  'https://apiutangin.hendrikofirman.com/User/Transaksi/Cetak_Laporan/$kdt',
                              fileName: '$kdt.pdf')
                          .then(
                        (value) => showDialog(
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
                                Icons.celebration,
                                size: 40,
                                color: Colors.red,
                              ),
                              content: Text(
                                "Laporan tersimpan di folder Download.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    OpenFile.open(value);
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'Buka File',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'Tutup',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 112, 110, 110),
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Download Kontrak Peminjaman",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context)
                          .pushReplacementNamed(EvaluasiPinjaman.nameRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Kembali Ke Beranda",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
