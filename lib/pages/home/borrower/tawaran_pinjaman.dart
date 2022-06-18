import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../pages/home/borrower/form_pengajuan_tawaran.dart';
import '../../../models/evaluasi_tawaran_model.dart';
import '../../../template/reusablewidgets.dart';
import '../lender/menu_lender.dart';
import '../menu_login.dart';
import 'menu_borrower.dart';

class TawaranPinjaman extends StatefulWidget {
  const TawaranPinjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageTawaranPinjaman';

  @override
  State<TawaranPinjaman> createState() => _TawaranPinjamanState();
}

class _TawaranPinjamanState extends State<TawaranPinjaman> {
  late TextEditingController emaillender;
  late TextEditingController jumlah;
  late TextEditingController tglpengembalian;
  late TextEditingController denda;

  late String formattedDate;

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

  getDetailTawaran() async {
    final session = Provider.of<EvaluasiTawaranModel>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? idp = await prefs.getString("idp");
    await session.getDetailTawaran(idp!);
  }

  @override
  void initState() {
    getMenu();
    getDetailTawaran();
    emaillender = TextEditingController();
    jumlah = TextEditingController();
    tglpengembalian = TextEditingController();
    denda = TextEditingController();
    formattedDate = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<EvaluasiTawaranModel>(
        builder: (context, value, child) => Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
              const Text(
                "Tawaran Pinjaman",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: emaillender
                    ..text = value.detailtawaran["email_lender"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  readOnly: true,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Email Pemberi Pinjaman",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: jumlah
                    ..text = value.detailtawaran["jumlah_tawaran"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 53, 51, 51),
                  ),
                  readOnly: true,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Jumlah Tawaran Peminjaman",
                    prefixText: "Rp.",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  readOnly: true,
                  controller: tglpengembalian
                    ..text = value.detailtawaran["tanggal_pengembalian"],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Tenggat waktu peminjam membayarkan pinjaman",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: denda..text = value.detailtawaran["denda"],
                  style: const TextStyle(
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
                    contentPadding: const EdgeInsets.all(5),
                    border: InputBorder.none,
                    labelText: "Telat tenggat waktu ada denda?",
                    prefixText:
                        (denda.text.toString() != "0") ? "Ya" : "Tidak Ada",
                    suffixText:
                        (denda.text.toString() != "0") ? "% per hari" : "",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Ajukan Peminjaman ini",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
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
        currentIndex: selected,
        onTap: _onItemTapped,
      ),
    );
  }
}
