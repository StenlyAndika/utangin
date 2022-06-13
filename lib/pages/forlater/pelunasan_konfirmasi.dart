import 'package:flutter/material.dart';
import 'sukses_pelunasan.dart';

class FormPelunasanLender extends StatefulWidget {
  const FormPelunasanLender({Key? key}) : super(key: key);

  static const nameRoute = '/page2831';

  @override
  State<FormPelunasanLender> createState() => _FormPelunasanLenderState();
}

class _FormPelunasanLenderState extends State<FormPelunasanLender> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(NotifSuksesPelunasan.nameRoute);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(10),
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  " T A N G I N . C O M",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Text(
              "Pelunasan Pinjaman",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // InputDesign.InputField("ID / Email Peminjam"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Nama Pemberi Pinjaman"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Tanggal Peminjaman"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Jumlah Peminjaman"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Pembayaran pinjaman dikirim ke rekening*"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Kegunaan Pinjaman"),
            // const SizedBox(height: 5),
            // InputDesign.InputField(
            //     "Tanggal waktu peminjam membayarkan pinjaman*"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Tempo Pembayaran"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Telat tanggal waktu ada denda?"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("Keterangan saat transfer"),
            // const SizedBox(height: 5),
            // InputDesign.InputField("ID / Email Peminjam"),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 177, 173, 173),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Bukti Transfer",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  elevation: 0,
                  backgroundColor:
                      const Color.fromARGB(255, 43, 42, 42).withOpacity(0.5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  title: const Icon(
                    Icons.celebration,
                    size: 40,
                    color: Colors.red,
                  ),
                  content: const Text(
                    "Konfirmasi Pelunasan Telah Kamu Setujui",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  actions: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Konfirmasi Lunas",
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
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        selectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        items: const <BottomNavigationBarItem>[
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
              Icons.school,
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

// ignore: non_constant_identifier_names
// TextField InputField(String lbltxt) {
//   return TextField(
//     style: const TextStyle(
//       fontSize: 15,
//       height: 1,
//       color: Colors.black,
//     ),
//     cursorColor: Colors.black,
//     autocorrect: false,
//     enableSuggestions: false,
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Colors.black,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(
//           color: Colors.black,
//         ),
//       ),
//       labelText: lbltxt,
//       labelStyle: const TextStyle(color: Colors.black),
//     ),
//   );
// }
