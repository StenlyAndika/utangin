import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/models/evaluasi_pinjaman_model.dart';
import 'package:utangin/pages/home/lender/detail_permohonan.dart';
import 'package:utangin/pages/home/lender/upload__bukti_peminjaman.dart';
import '../../../pages/home/menu_login.dart';

class EvaluasiPinjaman extends StatefulWidget {
  const EvaluasiPinjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageEvaluasiPinjaman';

  @override
  State<EvaluasiPinjaman> createState() => _EvaluasiPinjamanState();
}

class _EvaluasiPinjamanState extends State<EvaluasiPinjaman> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
    }
  }

  getListPinjaman() async {
    final session = Provider.of<EvaluasiPinjamanModel>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    session.getListPinjaman(ktp!);
  }

  @override
  void initState() {
    getListPinjaman();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
            const SizedBox(height: 20),
            const Text(
              "Pengajuan Pinjaman",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: width * 0.2,
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
            Consumer<EvaluasiPinjamanModel>(
              builder: (context, value, child) => Column(
                children: [
                  for (var i = 0; i < value.datapinjaman.length; i++) ...[
                    Wrap(
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text(
                            DateFormat('d-MM-yyyy').format(DateTime.parse(
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
                                color: Colors.yellow,
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
                                Navigator.of(context).pushReplacementNamed(
                                    UploadBuktiPeminjaman.nameRoute);
                              } else {
                                Navigator.of(context)
                                    .pushNamed(DetailPermohonan.nameRoute);
                              }
                            } else {
                              null;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 20),
                            width: width * 0.45,
                            height: 40,
                            alignment: Alignment.topRight,
                            child: Text(
                              "Lihat Detail",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        if (value.datapinjaman[i]["status"] == "X") ...[
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
        unselectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        selectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        items: const [
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
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
