import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../pages/home/lender/form_revisi.dart';
import '../../../template/reusablewidgets.dart';
import '../../../models/evaluasi_pinjaman_model.dart';
import '../borrower/menu_borrower.dart';
import '../menu_login.dart';
import 'menu_lender.dart';

class DetailPermohonan extends StatefulWidget {
  DetailPermohonan({Key? key}) : super(key: key);

  static const nameRoute = '/pageDetailPermohonan';

  @override
  State<DetailPermohonan> createState() => _DetailPermohonanState();
}

class _DetailPermohonanState extends State<DetailPermohonan> {
  late TextEditingController emailpeminjam;
  late TextEditingController namapeminjam;
  late TextEditingController jumlah;
  late TextEditingController norek;
  late TextEditingController notrans;
  late TextEditingController kegunaan;
  late TextEditingController tglpengembalian;
  late TextEditingController termin;
  late TextEditingController denda;

  late String ktptujuan;

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

  getDetailPinjaman() async {
    final session = Provider.of<EvaluasiPinjamanModel>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? idp = await prefs.getString("idp");
    await session.getDetailPinjaman(idp!);
  }

  @override
  void initState() {
    getMenu();
    getDetailPinjaman();
    emailpeminjam = TextEditingController();
    namapeminjam = TextEditingController();
    jumlah = TextEditingController();
    norek = TextEditingController();
    notrans = TextEditingController();
    kegunaan = TextEditingController();
    tglpengembalian = TextEditingController();
    termin = TextEditingController();
    denda = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<EvaluasiPinjamanModel>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<EvaluasiPinjamanModel>(
        builder: (context, value, child) => Container(
          padding:
              EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
              Text(
                "Pengajuan Pinjaman",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ReusableWidgets.inputReadOnlyField(
                  "Email Peminjam",
                  emailpeminjam..text = value.detailpinjaman["email"],
                  TextInputType.emailAddress),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Nama Lengkap",
                  namapeminjam..text = value.detailpinjaman["nama"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Tanggal Pengajuan Pinjaman",
                  namapeminjam
                    ..text = DateFormat('d-MM-yyyy').format(
                      DateTime.parse(value.detailpinjaman["tanggal_pengajuan"]),
                    ),
                  TextInputType.text),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: jumlah..text = value.detailpinjaman["jumlah"],
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 53, 51, 51),
                  ),
                  readOnly: true,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Jumlah Pinjaman",
                    prefixText: "Rp.",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Kirim ke rekening",
                  norek
                    ..text = value.detailpinjaman["no_rek"] +
                        " (" +
                        value.detailpinjaman["bank"] +
                        ")",
                  TextInputType.emailAddress),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Kegunaan peminjaman",
                  kegunaan..text = value.detailpinjaman["kegunaan"],
                  TextInputType.emailAddress),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Tanggal pengembalian oleh peminjam",
                  tglpengembalian
                    ..text = DateFormat('d-MM-yyyy').format(
                      DateTime.parse(
                          value.detailpinjaman["tanggal_pengembalian"]),
                    ),
                  TextInputType.emailAddress),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: denda..text = value.detailpinjaman["denda"],
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 53, 51, 51),
                  ),
                  readOnly: true,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  enableSuggestions: false,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Telat tenggat waktu ada denda?",
                    prefixText:
                        (value.detailpinjaman["denda"].toString() != "0")
                            ? "Ya"
                            : "Tidak Ada",
                    suffixText:
                        (value.detailpinjaman["denda"].toString() != "0")
                            ? "% per hari"
                            : "",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  config.accPinjaman(
                      context, value.detailpinjaman["id_permohonan"]);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Setujui Peminjaman",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                      'idp', value.detailpinjaman["id_permohonan"]);
                  Navigator.of(context).pushNamed(RevisiPinjaman.nameRoute);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 112, 110, 110),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Revisi Tawaran Peminjaman",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5)
            ],
          ),
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
