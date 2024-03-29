import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/pages/home/lender/evaluasi_cicilan_lender.dart';
import '../../../services/evaluasi_hutang_services.dart';
import '../../../services/evaluasi_pinjaman_services.dart';
import '../../../pages/home/menu_login.dart';
import '../../../template/reusablewidgets.dart';
import 'lender_riwayat.dart';
import 'menu_lender.dart';

class EvaluasiPelunasan extends StatefulWidget {
  EvaluasiPelunasan({Key? key}) : super(key: key);

  static const nameRoute = '/pageEvaluasiPelunasan';

  @override
  State<EvaluasiPelunasan> createState() => _EvaluasiPelunasanState();
}

class _EvaluasiPelunasanState extends State<EvaluasiPelunasan> {
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
    final config = Provider.of<EvaluasiHutangServices>(context, listen: false);
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.22),
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
                  "Konfirmasi Pelunasan Pinjaman",
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
                    if (value.datapinjaman[i]["status"] != "X") ...[
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
                          if (value.datapinjaman[i]["status"] == "0") ...[
                            Container(
                              width: width * 0.2,
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Belum Lunas",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color.fromARGB(255, 75, 72, 72),
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
                      Container(
                        width: width,
                        height: 40,
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            config
                                .cariIDTransaksi(
                                    value.datapinjaman[i]["id_permohonan"])
                                .then(
                              (value) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                    "id_transaksi", value.toString());
                              },
                            );
                            Navigator.of(context)
                                .pushNamed(EvaluasiCicilanLender.nameRoute);
                          },
                          child: Text(
                            "Konfirmasi Pembayaran",
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            fixedSize: Size(100, 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
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
