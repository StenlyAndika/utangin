import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/evaluasi_pinjaman_model.dart';
import '../menu_login.dart';
import '../user/pengaturan.dart';
import 'menu_lender.dart';

class TawarkanPinjaman extends StatefulWidget {
  const TawarkanPinjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageTawarkanPinjaman';

  @override
  State<TawarkanPinjaman> createState() => _TawarkanPinjamanState();
}

class _TawarkanPinjamanState extends State<TawarkanPinjaman> {
  late TextEditingController emailpeminjam;
  late TextEditingController jumlah;
  late TextEditingController tglpengembalian;
  late TextEditingController denda;

  late String ktppeminjam;
  late bool _emailvalid;
  late bool _emailfound;
  late String formattedDate;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(MenuLender.nameRoute);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(Pengaturan.nameRoute);
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
    jumlah = TextEditingController();
    tglpengembalian = TextEditingController();
    denda = TextEditingController();
    _emailvalid = false;
    _emailfound = true;
    formattedDate = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<EvaluasiPinjamanModel>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
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
              "Tawarkan Pinjaman",
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
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: emailpeminjam,
                onChanged: (emailpeminjam) async {
                  _emailvalid = EmailValidator.validate(emailpeminjam);
                  final prefs = await SharedPreferences.getInstance();
                  var ktpuser = await prefs.getString('ktp');
                  if (_emailvalid == true) {
                    config.cariBorrower(emailpeminjam).then((value) {
                      setState(() {
                        if (value["nama"] != null) {
                          if (ktpuser == value["ktp"]) {
                            _emailfound = false;
                            ktppeminjam = "";
                          } else {
                            ktppeminjam = value["ktp"];
                            _emailfound = true;
                          }
                        } else {
                          _emailfound = false;
                          ktppeminjam = "0";
                        }
                      });
                    });
                  }
                },
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
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
            Visibility(
              visible: (_emailfound) ? false : true,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Email tidak terdaftar",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: jumlah,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 53, 51, 51),
                ),
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
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                readOnly: true,
                controller: tglpengembalian,
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
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1945),
                    lastDate: DateTime(2100),
                  );
                  int daysBetween(DateTime from, DateTime to) {
                    from = DateTime(from.year, from.month, from.day);
                    to = DateTime(to.year, to.month, to.day);
                    return (to.difference(from).inHours / 24).round();
                  }

                  final date2 = DateTime.now();

                  final difference = daysBetween(date2, pickedDate!);

                  formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    tglpengembalian.text =
                        formattedDate + " / " + difference.toString() + " hari";
                  });
                },
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: denda,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 53, 51, 51),
                ),
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
            Text(
              "Tawaran ini akan dikirimkan ke peminjam sesuai dengan email diatas. Apabila penawaranmu diterima, sistem akan mengirimkan kamu surat penawaran peminjaman yang bisa kamu konfirmasi.",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                config.tawarkanPinjaman(context, ktppeminjam, jumlah.text,
                    formattedDate, denda.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Kirim",
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
