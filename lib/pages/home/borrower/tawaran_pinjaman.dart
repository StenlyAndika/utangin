import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../pages/home/borrower/form_pengajuan_tawaran.dart';
import '../../../services/evaluasi_tawaran_services.dart';
import '../../../template/reusablewidgets.dart';
import '../menu_login.dart';
import 'borrower_riwayat.dart';
import 'menu_borrower.dart';

class TawaranPinjaman extends StatefulWidget {
  TawaranPinjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageTawaranPinjaman';

  @override
  State<TawaranPinjaman> createState() => _TawaranPinjamanState();
}

class _TawaranPinjamanState extends State<TawaranPinjaman> {
  late TextEditingController emaillender = TextEditingController();
  late TextEditingController jumlah = TextEditingController();
  late TextEditingController tglpengembalian = TextEditingController();
  late TextEditingController denda = TextEditingController();

  late String formattedDate;

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

  @override
  void initState() {
    getDetailTawaran();
    emaillender.text = "";
    jumlah.text = "";
    tglpengembalian.text = "";
    denda.text = "";
    formattedDate = "";
    super.initState();
  }

  getDetailTawaran() async {
    final session = Provider.of<EvaluasiTawaranServices>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? idp = await prefs.getString("idp");
    await session.getDetailTawaran(idp!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<EvaluasiTawaranServices>(
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
                "Tawaran Pinjaman",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: emaillender
                    ..text = value.detailtawaran["email_lender"],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  readOnly: true,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Email Pemberi Pinjaman",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: jumlah
                    ..text = value.detailtawaran["jumlah_tawaran"],
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
                    labelText: "Jumlah Tawaran Peminjaman",
                    prefixText: "Rp.",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  readOnly: true,
                  controller: tglpengembalian
                    ..text = value.detailtawaran["tanggal_pengembalian"],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Tenggat waktu peminjam membayarkan pinjaman",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: denda..text = value.detailtawaran["denda"],
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
                        (denda.text.toString() != "0") ? "Ya" : "Tidak Ada",
                    suffixText:
                        (denda.text.toString() != "0") ? "% per hari" : "",
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                      'tgl', value.detailtawaran["tanggal_pengembalian"]);
                  Navigator.of(context)
                      .pushReplacementNamed(FormPengajuanTawaran.nameRoute);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Ajukan Peminjaman ini",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
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
