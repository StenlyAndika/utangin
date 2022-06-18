import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/pages/home/borrower/menu_borrower.dart';
import 'package:utangin/pages/home/borrower/tawaran_pinjaman.dart';
import '../../../models/evaluasi_tawaran_model.dart';
import '../../../pages/home/menu_login.dart';
import '../user/pengaturan.dart';

class EvaluasiTawaran extends StatefulWidget {
  const EvaluasiTawaran({Key? key}) : super(key: key);

  static const nameRoute = '/pageevaluasitawarankesaya';

  @override
  State<EvaluasiTawaran> createState() => _EvaluasiTawaranState();
}

class _EvaluasiTawaranState extends State<EvaluasiTawaran> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(MenuBorrower.nameRoute);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(Pengaturan.nameRoute);
        break;
    }
  }

  getListTawaran() async {
    final session = Provider.of<EvaluasiTawaranModel>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    session.getListTawaran(ktp!);
  }

  @override
  void initState() {
    getListTawaran();
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
            padding:
                const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 0),
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
                const SizedBox(height: 10),
                const Text(
                  "Tawaran Pinjaman",
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
        padding: const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            Consumer<EvaluasiTawaranModel>(
              builder: (context, value, child) => Column(
                children: [
                  for (var i = 0; i < value.datatawaran.length; i++) ...[
                    Wrap(
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Text(
                            DateFormat('d-MM-yyyy').format(DateTime.parse(
                                value.datatawaran[i]["tanggal_diajukan"])),
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Container(
                          width: width * 0.33,
                          child: Text(
                            value.datatawaran[i]["nama_lender"],
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Container(
                          width: width * 0.22,
                          child: Text(
                            "Rp." + value.datatawaran[i]["jumlah_tawaran"],
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        if (value.datatawaran[i]["status"] == "0") ...[
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Penawaran",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ] else ...[
                          Container(
                            width: width * 0.2,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Diterima",
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
                            if (value.datatawaran[i]["status"] == "0") {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  'idp', value.datatawaran[i]["id_penawaran"]);
                              Navigator.of(context)
                                  .pushNamed(TawaranPinjaman.nameRoute);
                            } else {
                              null;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 70),
                            width: width,
                            height: 40,
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Lihat Detail",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
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
