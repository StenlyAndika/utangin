import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/pages/home/lender/evaluasi_pelunasan.dart';
import '../../../template/currencyformat.dart';
import '../../../template/reusablewidgets.dart';
import '../../../pages/home/lender/evaluasi_pinjaman.dart';
import '../../../pages/home/lender/tawarkan_pinjaman.dart';

import '../../../services/pengajuan.dart';
import '../menu_login.dart';

class MenuLender extends StatefulWidget {
  MenuLender({Key? key}) : super(key: key);

  static const nameRoute = '/pagemenublender';

  @override
  State<MenuLender> createState() => _MenuLenderState();
}

class _MenuLenderState extends State<MenuLender> {
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
      case 3:
        selected = 3;
        ReusableWidgets.menuPengaturan(context);
        break;
    }
  }

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_piutang_berjalan = "User/Transaksi/Jumlah_piutang_berjalan";

  List<Map<String, dynamic>> piutang = [];

  Future getListPiutang() async {
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    try {
      var response =
          await http.get(Uri.parse("$url/$endpoint_piutang_berjalan/$ktp"));
      List data = json.decode(response.body);

      data.forEach((element) {
        piutang.add(element);
      });
    } catch (err) {
      throw (err);
    }
  }

  @override
  void initState() {
    getMenu();
    getUserData();
    super.initState();
  }

  getUserData() async {
    final session2 = Provider.of<PengajuanServices>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    await session2.getUserData(ktp!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 26,
                  child: Container(
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(
                      "     U",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26,
                  child: Container(
                    color: Colors.red,
                    alignment: Alignment.center,
                    child: Text(
                      " T A N G I N . C O M              ",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              "Hallo,",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Consumer<PengajuanServices>(
                  builder: (context, value, child) => Text(
                    (value.datauser["nama"] != null)
                        ? value.datauser["nama"]
                        : "",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.celebration,
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.15,
                  autoPlay: true),
              items: [
                "img/primary-background.jpg",
                "img/secondary-background.jpg"
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: Stack(
                          children: [
                            Image.asset(
                              i.toString(),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromARGB(255, 137, 0, 145).withOpacity(0.8),
                      Color.fromARGB(255, 183, 21, 192).withOpacity(0.8),
                      Color.fromARGB(255, 231, 76, 56).withOpacity(0.8),
                      Color.fromARGB(255, 240, 43, 43).withOpacity(0.8),
                      Color.fromARGB(255, 241, 2, 2).withOpacity(0.8),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: FutureBuilder(
                  future: getListPiutang(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView(
                        children: [
                          Text(
                            "Piutang Berjalan Saya",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          SizedBox(height: 5),
                          Text(
                            CurrencyFormat.convertToIdr(
                                piutang[0]['piutang_berjalan'], 2),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 80,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        (piutang[0]['jumlah_pinjaman'] != null)
                                            ? "${piutang[0]['jumlah_pinjaman']}"
                                            : "0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.4),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Jumlah Pinjaman yang Saya Berikan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 100,
                                width: 80,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        (piutang[0]['jumlah_peminjam'] != null)
                                            ? "${piutang[0]['jumlah_peminjam']}"
                                            : "0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.4),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Jumlah Orang yang Saya Pinjamkan",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 100,
                                width: 80,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        (piutang[0]['pinjaman_lunas'] != null)
                                            ? "${piutang[0]['pinjaman_lunas']}"
                                            : "0",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.4),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Jumlah Pinjaman Lunas",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 80,
                  child: Column(
                    children: [
                      ButtonTheme(
                        minWidth: 200.0,
                        height: 200.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(TawarkanPinjaman.nameRoute);
                          },
                          child: Icon(
                            Icons.attach_money,
                            size: 30,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Tawarkan Pinjaman",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  height: 120,
                  width: 80,
                  child: Column(
                    children: [
                      ButtonTheme(
                        minWidth: 200.0,
                        height: 200.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EvaluasiPinjaman.nameRoute);
                          },
                          child: Icon(
                            Icons.request_page,
                            size: 30,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Evaluasi Pengajuan Pinjaman",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  height: 120,
                  width: 80,
                  child: Column(
                    children: [
                      ButtonTheme(
                        minWidth: 200.0,
                        height: 200.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EvaluasiPelunasan.nameRoute);
                          },
                          child: Icon(
                            Icons.waving_hand,
                            size: 30,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Konfirmasi Pelunasan Peminjaman",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
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
