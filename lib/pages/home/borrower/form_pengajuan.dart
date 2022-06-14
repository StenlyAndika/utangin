import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  late TextEditingController tglpeminjaman;
  late TextEditingController jumlahpinjam;
  late String norek;
  late TextEditingController kegunaanpinjam;
  late TextEditingController tglpengembalian;
  late TextEditingController terminpembayaran;
  late TextEditingController denda;

  late bool _emailvalid;

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
    tglpeminjaman = TextEditingController();
    jumlahpinjam = TextEditingController();
    norek = "Pilih no rekening";
    kegunaanpinjam = TextEditingController();
    tglpengembalian = TextEditingController();
    terminpembayaran = TextEditingController();
    denda = TextEditingController();
    _emailvalid = false;
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
                onChanged: (emailtujuan) {
                  setState(() {
                    _emailvalid = EmailValidator.validate(emailtujuan);
                    if (_emailvalid == true) {
                      user.cariLender(emailtujuan).then((value) {
                        if (value["nama"] != null) {
                          namapemberipinjaman.text = value["nama"];
                        } else {
                          namapemberipinjaman.text = "";
                        }
                      });
                    }
                  });
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
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  if (emailtujuan.text != "") ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Consumer<PengajuanModel>(
                          builder: (context, value, child) => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: (value.datauser["nama"] != null)
                                    ? Colors.red
                                    : (_emailvalid == true)
                                        ? Colors.green
                                        : Colors.red,
                                border: (value.datauser["nama"] != null)
                                    ? Border.all(color: Colors.transparent)
                                    : Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: (value.datauser["nama"] != null)
                                  ? const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 10,
                                    )
                                  : (_emailvalid == true)
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        )
                                      : const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Consumer<PengajuanModel>(
                          builder: (context, value, child) => Text(
                            (value.datauser["nama"] != null)
                                ? "Email sudah terdaftar"
                                : (_emailvalid == true)
                                    ? "Email siap digunakan"
                                    : "Email tidak valid",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                readOnly: true,
                controller: tglpeminjaman,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Tanggal Peminjaman",
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
                      tglpeminjaman.text = formattedDate;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Jumlah Pinjaman", jumlahpinjam, TextInputType.number),
            const SizedBox(height: 5),
            inputnorek(),
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
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {},
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

  Container inputnorek() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 184, 174, 174)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: norek,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            onChanged: (String? newValue) {
              setState(() {
                norek = newValue!;
              });
            },
            items: ["Pilih no rekening", "001", "002"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
