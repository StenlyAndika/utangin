import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/evaluasi_pinjaman_services.dart';
import '../../../pages/home/lender/detail_permohonan.dart';
import 'lender_riwayat.dart';
import 'upload_bukti_peminjaman.dart';
import '../../../pages/home/menu_login.dart';
import '../../../template/reusablewidgets.dart';
import 'menu_lender.dart';

class EvaluasiPinjaman extends StatefulWidget {
  EvaluasiPinjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageEvaluasiPinjaman';

  @override
  State<EvaluasiPinjaman> createState() => _EvaluasiPinjamanState();
}

class _EvaluasiPinjamanState extends State<EvaluasiPinjaman> {
  int selected = 1;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(MenuLender.nameRoute);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(RiwayatLender.nameRoute);
        break;
      case 3:
        ReusableWidgets.menuPengaturan(context);
        break;
    }
  }

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
  void initState() {
    getListPinjaman();
    super.initState();
  }

  getListPinjaman() async {
    final session =
        Provider.of<EvaluasiPinjamanServices>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    await session.getListPinjaman(ktp!);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.18),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
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
                  "Pengajuan Pinjaman",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.21,
                        child: Text(
                          "Tanggal",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        width: width * 0.33,
                        child: Text(
                          "Nama Peminjam",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        width: width * 0.22,
                        child: Text(
                          "Jumlah",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        width: width * 0.2,
                        child: Text(
                          "Status",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            Consumer<EvaluasiPinjamanServices>(
              builder: (context, value, child) => Column(
                children: [
                  for (var i = 0; i < value.datapinjaman.length; i++) ...[
                    Wrap(
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text(
                            DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                value.datapinjaman[i]["tanggal_pengajuan"])),
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Container(
                          width: width * 0.33,
                          child: Text(
                            value.datapinjaman[i]["nama_borrower"],
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Container(
                          width: width * 0.22,
                          child: Text(
                            "Rp." + value.datapinjaman[i]["jumlah"],
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        if (value.datapinjaman[i]["status"] == "X") ...[
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Pengajuan",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else if (value.datapinjaman[i]["status"] == "0") ...[
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Dipinjamkan",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 94, 89, 89),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Lunas",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    Wrap(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (value.datapinjaman[i]["status"] == "X") {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('idp',
                                  value.datapinjaman[i]["id_permohonan"]);
                              if (value.datapinjaman[i]["acc_l"] == "1") {
                                if (value.datapinjaman[i]["revisi"] == "1") {
                                } else {
                                  Navigator.of(context).pushReplacementNamed(
                                      UploadBuktiPeminjaman.nameRoute);
                                }
                              } else {
                                Navigator.of(context).pushReplacementNamed(
                                    DetailPermohonan.nameRoute);
                              }
                            } else {
                              var kdt = value.datapinjaman[i]["id_transaksi"];
                              openFile(
                                      url:
                                          'https://apiutangin.hendrikofirman.com/User/Transaksi/Cetak_Laporan/$kdt',
                                      fileName: '$kdt.pdf')
                                  .then(
                                (value) => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AnimatedContainer(
                                    duration: Duration(milliseconds: 1500),
                                    child: AlertDialog(
                                      elevation: 0,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            width: width * 0.45,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              (value.datapinjaman[i]["acc_l"] == "1")
                                  ? "Download Laporan"
                                  : "Lihat Detail",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        if (value.datapinjaman[i]["status"] == "X") ...[
                          if (value.datapinjaman[i]["revisi"] == "1") ...[
                            Container(
                              padding: EdgeInsets.all(5),
                              width: width * 0.45,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                child: Text(
                                  "Pinjaman direvisi",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white),
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: EdgeInsets.all(5),
                              width: width * 0.45,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: InkWell(
                                child: Text(
                                  "Peminjam Baru Mengajukan",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white),
                                ),
                              ),
                            ),
                          ]
                        ] else if (value.datapinjaman[i]["status"] == "0") ...[
                          Container(
                            padding: EdgeInsets.all(5),
                            width: width * 0.45,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: InkWell(
                              child: Text(
                                "Peminjam Belum Membayar",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: EdgeInsets.all(5),
                            width: width * 0.45,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: InkWell(
                              child: Text(
                                "Peminjam Telah Membayar",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    Divider(),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        selectedLabelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.business,
              color: Colors.black,
            ),
            label: 'Pinjamanku',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              color: Colors.black,
            ),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: selected,
        onTap: _onItemTapped,
      ),
    );
  }
}
