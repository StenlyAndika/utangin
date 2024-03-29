import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../pages/home/borrower/evaluasi_cicilan.dart';
import '../../../services/evaluasi_hutang_services.dart';
import '../../../pages/home/menu_login.dart';
import '../../../template/reusablewidgets.dart';
import '../borrower/menu_borrower.dart';
import 'borrower_riwayat.dart';

class EvaluasiHutang extends StatefulWidget {
  EvaluasiHutang({Key? key}) : super(key: key);

  static const nameRoute = '/pageEvaluasiHutang';

  @override
  State<EvaluasiHutang> createState() => _EvaluasiHutangState();
}

class _EvaluasiHutangState extends State<EvaluasiHutang> {
  int selected = 1;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(MenuBorrower.nameRoute);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(RiwayatBorrower.nameRoute);
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
    getListHutang();
    super.initState();
  }

  getListHutang() async {
    final session = Provider.of<EvaluasiHutangServices>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    await session.getListHutang(ktp!);
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<EvaluasiHutangServices>(context, listen: false);
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
                  "Bayar Pinjaman",
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
                          "Nama Lender",
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
            Consumer<EvaluasiHutangServices>(
              builder: (context, value, child) => Column(
                children: [
                  for (var i = 0; i < value.datahutang.length; i++) ...[
                    if (value.datahutang[i]["status"] != "X") ...[
                      Wrap(
                        children: [
                          Container(
                            width: width * 0.2,
                            child: Text(
                              DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                  value.datahutang[i]["tanggal_pengajuan"])),
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          Container(
                            width: width * 0.33,
                            child: Text(
                              value.datahutang[i]["nama_lender"],
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          Container(
                            width: width * 0.22,
                            child: Text(
                              "Rp." + value.datahutang[i]["jumlah"],
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          if (value.datahutang[i]["status"] == "X") ...[
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
                          ] else if (value.datahutang[i]["status"] == "0") ...[
                            Container(
                              width: width * 0.2,
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Belum Lunas",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red,
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
                              var kdt = value.datahutang[i]["id_transaksi"];
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
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20),
                              width: width * 0.45,
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                "Download Laporan",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          if (value.datahutang[i]["status"] == "0") ...[
                            ElevatedButton(
                              onPressed: () async {
                                await config
                                    .cariIDTransaksi(
                                        value.datahutang[i]["id_permohonan"])
                                    .then((value) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      "id_transaksi", value.toString());
                                  print(value.toString());
                                });

                                Navigator.of(context)
                                    .pushNamed(EvaluasiCicilan.nameRoute);
                              },
                              child: Text(
                                "Bayar",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.cyan,
                                fixedSize: Size(150, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ] else if (value.datahutang[i]["status"] == "1") ...[
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Lunas",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                fixedSize: Size(150, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Divider(),
                    ]
                  ],
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
