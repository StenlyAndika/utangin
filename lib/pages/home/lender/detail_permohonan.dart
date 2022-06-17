import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/pages/home/lender/form_revisi.dart';
import '../../../template/reusablewidgets.dart';
import '../../../models/evaluasi_pinjaman_model.dart';
import '../menu_login.dart';

class DetailPermohonan extends StatefulWidget {
  const DetailPermohonan({Key? key}) : super(key: key);

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

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
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
                "Pengajuan Pinjaman",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ReusableWidgets.inputReadOnlyField(
                  "Email Peminjam",
                  emailpeminjam..text = value.detailpinjaman["email"],
                  TextInputType.emailAddress),
              const SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Nama Lengkap",
                  namapeminjam..text = value.detailpinjaman["nama"],
                  TextInputType.text),
              const SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Tanggal Pengajuan Pinjaman",
                  namapeminjam
                    ..text = DateFormat('d-MM-yyyy').format(
                      DateTime.parse(value.detailpinjaman["tanggal_pengajuan"]),
                    ),
                  TextInputType.text),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: jumlah..text = value.detailpinjaman["jumlah"],
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
                    labelText: "Jumlah Pinjaman",
                    prefixText: "Rp.",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Kirim ke rekening",
                  norek
                    ..text = value.detailpinjaman["no_rek"] +
                        " (" +
                        value.detailpinjaman["bank"] +
                        ")",
                  TextInputType.emailAddress),
              const SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Kegunaan peminjaman",
                  kegunaan..text = value.detailpinjaman["kegunaan"],
                  TextInputType.emailAddress),
              const SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Tanggal pengembalian oleh peminjam",
                  tglpengembalian
                    ..text = DateFormat('d-MM-yyyy').format(
                      DateTime.parse(
                          value.detailpinjaman["tanggal_pengembalian"]),
                    ),
                  TextInputType.emailAddress),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: denda..text = value.detailpinjaman["denda"],
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
                        (value.detailpinjaman["denda"].toString() != "0")
                            ? "Ya"
                            : "Tidak Ada",
                    suffixText:
                        (value.detailpinjaman["denda"].toString() != "0")
                            ? "% per hari"
                            : "",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  config.accPinjaman(
                      context, value.detailpinjaman["id_permohonan"]);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
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
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
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
