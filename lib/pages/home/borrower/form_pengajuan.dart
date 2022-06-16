import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utangin/json/json_rekening.dart';
import 'package:utangin/pages/home/menu_login.dart';
import 'package:utangin/template/reusablewidgets.dart';

import '../../../models/pengajuan.dart';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({Key? key}) : super(key: key);

  static const nameRoute = '/pageformpengajuan';

  @override
  State<FormPengajuan> createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  late TextEditingController emailtujuan;
  late TextEditingController namapemberipinjaman;
  late TextEditingController jumlahpinjam;
  late String norek;
  late TextEditingController kegunaanpinjam;
  late TextEditingController tglpengembalian;
  late TextEditingController terminpembayaran;
  late TextEditingController denda;

  late bool _emailvalid;
  late bool _emailfound;

  late String ktptujuan;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
    }
  }

  @override
  void initState() {
    emailtujuan = TextEditingController();
    namapemberipinjaman = TextEditingController();
    jumlahpinjam = TextEditingController();
    norek = "";
    ktptujuan = "";
    kegunaanpinjam = TextEditingController();
    tglpengembalian = TextEditingController();
    terminpembayaran = TextEditingController();
    denda = TextEditingController();
    _emailvalid = false;
    _emailfound = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<PengajuanModel>(context, listen: false);
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
              "Ajukan Pinjaman",
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
                controller: emailtujuan,
                onChanged: (emailtujuan) async {
                  _emailvalid = EmailValidator.validate(emailtujuan);
                  final prefs = await SharedPreferences.getInstance();
                  var ktpuser = await prefs.getString('ktp');
                  if (_emailvalid == true) {
                    user.cariLender(emailtujuan).then((value) {
                      setState(() {
                        if (value["nama"] != null) {
                          if (ktpuser == value["ktp"]) {
                            _emailfound = false;
                            ktptujuan = "";
                            namapemberipinjaman.text = "";
                          } else {
                            namapemberipinjaman.text = value["nama"];
                            ktptujuan = value["ktp"];
                            _emailfound = true;
                          }
                        } else {
                          namapemberipinjaman.text = "";
                          _emailfound = false;
                          ktptujuan = "0";
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
                controller: namapemberipinjaman,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Nama Pemberi Pinjaman",
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Jumlah Pinjaman", jumlahpinjam, TextInputType.number),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DropdownSearch<JsonRekening>(
                  asyncItems: (text) async {
                    final prefs = await SharedPreferences.getInstance();
                    var ktpuser = await prefs.getString('ktp');
                    var hasilResponse = await http.get(Uri.parse(
                        "http://10.0.2.2/Utangin_API/User/Rekening/Baca_ktp/$ktpuser"));

                    if (hasilResponse.statusCode != 200) {
                      return [];
                    }
                    List allidrek = (json
                        .decode(hasilResponse.body)
                        .cast<Map<String, dynamic>>());

                    List<JsonRekening> allrek = [];

                    for (int i = 0; i < allidrek.length; i++) {
                      allrek.add(
                        JsonRekening(
                          no_rek: allidrek[i]["no_rek"],
                          id_rekening: allidrek[i]["id_rekening"],
                          bank: allidrek[i]["bank"],
                        ),
                      );
                    }
                    return allrek;
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Kirim ke rekening",
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 124, 113, 113))),
                  ),
                  dropdownBuilder: (context, selectedItem) =>
                      Text(selectedItem?.no_rek ?? ""),
                  popupProps: PopupProps.menu(
                    itemBuilder: (context, item, isSelected) => ListTile(
                      title: Text(item.no_rek + " (" + item.bank + ")"),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      norek = value!.id_rekening;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Kegunaan Pinjaman", kegunaanpinjam, TextInputType.text),
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
                  labelText: "Tanggal pengembalian oleh peminjam",
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1945),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      tglpengembalian.text = formattedDate;
                    });
                  }
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
                controller: terminpembayaran,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Termin Pembayaran",
                  suffixText: "x Cicilan",
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Tooltip(
              richMessage: TextSpan(
                text: 'I am a rich tooltip. ',
                style: TextStyle(color: Colors.red),
                children: <InlineSpan>[
                  TextSpan(
                    text: 'I am another span of this rich tooltip',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 184, 174, 174)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: denda,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
                    prefixText: "Ya",
                    suffixText: "% per hari",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 108, 108)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var ktpuser = await prefs.getString('ktp');

                String formatdenda = denda.text;
                final letter = ',';
                final newLetter = '.';
                formatdenda = formatdenda.replaceAll(letter, newLetter);

                user.postPinjaman(
                    context,
                    ktpuser,
                    ktptujuan,
                    jumlahpinjam.text,
                    norek,
                    kegunaanpinjam.text,
                    tglpengembalian.text,
                    terminpembayaran.text,
                    formatdenda);
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
