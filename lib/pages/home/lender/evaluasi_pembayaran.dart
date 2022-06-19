import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/pages/home/borrower/detail_cicilan.dart';
import '../../../models/evaluasi_hutang_model.dart';
import '../../../pages/home/menu_login.dart';
import '../../../template/reusablewidgets.dart';
import '../borrower/menu_borrower.dart';
import '../lender/menu_lender.dart';

class EvaluasiPembayaran extends StatefulWidget {
  EvaluasiPembayaran({Key? key}) : super(key: key);

  static const nameRoute = '/pageEvaluasiPembayaran';

  @override
  State<EvaluasiPembayaran> createState() => _EvaluasiPembayaranState();
}

class _EvaluasiPembayaranState extends State<EvaluasiPembayaran> {
  String? menu;
  int selected = 1;

  getMenu() async {
    final prefs = await SharedPreferences.getInstance();
    menu = await prefs.getString("menu");
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        selected = 0;
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
      case 1:
        selected = 1;
        if (menu == "lender") {
          Navigator.of(context).pushReplacementNamed(MenuLender.nameRoute);
        } else {
          Navigator.of(context).pushReplacementNamed(MenuBorrower.nameRoute);
        }
        break;
      case 3:
        selected = 3;
        ReusableWidgets.menuPengaturan(context);
        break;
    }
  }

  getListCicilan() async {
    final session = Provider.of<EvaluasiHutangModel>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? idt = await prefs.getString("id_transaksi");
    session.getListCicilan(idt!);
  }

  @override
  void initState() {
    getMenu();
    getListCicilan();
    super.initState();
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
                  "Daftar Cicilan",
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
                        width: width * 0.2,
                        child: Text(
                          "Cicilan Ke",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        width: width * 0.3,
                        child: Text(
                          "Tenggat Waktu",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        width: width * 0.25,
                        child: Text(
                          "Jumlah",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      Container(
                        width: width * 0.3,
                        child: Text(
                          "Opsi",
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
        padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            Consumer<EvaluasiHutangModel>(
              builder: (context, value, child) => Column(
                children: [
                  for (var i = 0; i < value.listcicilan.length; i++) ...[
                    Wrap(
                      children: [
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          width: width * 0.15,
                          child: Text(
                            value.listcicilan[i]["cicilan_ke"],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerRight,
                          width: width * 0.25,
                          child: Text(
                            DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                value.listcicilan[i]["tanggal_batas"])),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.centerRight,
                          width: width * 0.25,
                          child: Text(
                            "Rp." + value.listcicilan[i]["jml_angsuran"],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 5),
                        if (value.listcicilan[i]["status"] == "0") ...[
                          Container(
                            width: width * 0.3,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString("id_cicilan",
                                    value.listcicilan[i]["id_cicilan"]);
                                Navigator.of(context).pushReplacementNamed(
                                    DetailCicilan.nameRoute);
                              },
                              child: Text(
                                "Bayar",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.cyan,
                                fixedSize: Size(50, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ] else if (value.listcicilan[i]["status"] == "1") ...[
                          Container(
                            width: width * 0.3,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Telah Bayar",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                fixedSize: Size(50, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
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
