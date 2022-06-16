import 'package:flutter/material.dart';
import '../../../pages/home/menu_login.dart';

class EvaluasiPinjaman extends StatefulWidget {
  const EvaluasiPinjaman({Key? key}) : super(key: key);

  static const nameRoute = '/pageEvaluasiPinjaman';

  @override
  State<EvaluasiPinjaman> createState() => _EvaluasiPinjamanState();
}

class _EvaluasiPinjamanState extends State<EvaluasiPinjaman> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
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
            const SizedBox(height: 20),
            const Text(
              "Pengajuan Pinjaman",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  DataColumn(
                    label: Container(
                      width: width * .21,
                      child: Text(
                        'Tanggal',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: width * .35,
                      child: Text(
                        'Nama Peminjam',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: width * .21,
                      child: Text(
                        'Jumlah',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: width * .2,
                      child: Text(
                        'Status',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '24/02/2022',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Budi Kontolodon',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Rp. 5000000',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Belum Lunas',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        TextButton(
                          onPressed: () {},
                          child: Text("Detail"),
                        ),
                      ),
                      DataCell(
                        Text(
                          '',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Belum Lunas"),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '24/02/2022',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Budi Kontolodon',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Rp. 5000000',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        Text(
                          'Belum Lunas',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        TextButton(
                          onPressed: () {},
                          child: Text("Detail"),
                        ),
                      ),
                      DataCell(
                        Text(
                          '',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Belum Lunas"),
                        ),
                      ),
                    ],
                  )
                ],
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
