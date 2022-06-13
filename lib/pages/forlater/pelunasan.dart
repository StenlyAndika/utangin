import 'package:flutter/material.dart';
import 'sukses_pelunasan.dart';

class FormPelunasan extends StatefulWidget {
  const FormPelunasan({Key? key}) : super(key: key);

  static const nameRoute = '/page13';

  @override
  State<FormPelunasan> createState() => _FormPelunasanState();
}

class _FormPelunasanState extends State<FormPelunasan> {
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
              "Pelunasan Pinjaman Saya",
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
            // const SizedBox(height: 5),
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
                "Upload bukti Transfer",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
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
