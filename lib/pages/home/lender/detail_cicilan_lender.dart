import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/evaluasi_hutang_services.dart';
import '../../../pages/home/menu_login.dart';
import '../../../template/reusablewidgets.dart';
import '../lender/menu_lender.dart';
import 'lender_riwayat.dart';

class DetailCicilanLender extends StatefulWidget {
  DetailCicilanLender({Key? key}) : super(key: key);

  static const nameRoute = '/pageDetailCicilanLender';

  @override
  State<DetailCicilanLender> createState() => _DetailCicilanLenderState();
}

class _DetailCicilanLenderState extends State<DetailCicilanLender> {
  late TextEditingController email = TextEditingController();
  late TextEditingController nama = TextEditingController();
  late TextEditingController tanggal = TextEditingController();
  late TextEditingController jumlah = TextEditingController();
  late TextEditingController cicilan_ke = TextEditingController();
  late TextEditingController jml = TextEditingController();
  late TextEditingController ket = TextEditingController();

  late String ktp_lender;

  int selected = 1;

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(MenuLender.nameRoute);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(RiwayatLender.nameRoute);
        break;
      case 3:
        ReusableWidgets.menuPengaturan(context);
        break;
    }
  }

  @override
  void initState() {
    getDetailCicilanLender();
    super.initState();
  }

  getDetailCicilanLender() async {
    final session = Provider.of<EvaluasiHutangServices>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? id_cicilan = await prefs.getString("id_cicilan");
    await session.getDetailCicilanLender(id_cicilan!);
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<EvaluasiHutangServices>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<EvaluasiHutangServices>(
        builder: (context, value, child) => Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                "Detail Pelunasan Cicilan",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ReusableWidgets.inputReadOnlyField(
                  "Email Peminjam",
                  email..text = value.detailcicilan["email"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField("Nama Peminjam",
                  nama..text = value.detailcicilan["nama"], TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Tanggal Pinjaman",
                  tanggal..text = value.detailcicilan["tanggal"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Jumlah Pinjaman",
                  jumlah..text = value.detailcicilan["jumlah"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Cicilan Ke",
                  cicilan_ke..text = value.detailcicilan["cicilan_ke"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Jumlah yang harus dibayarkan",
                  jumlah..text = value.detailcicilan["jml_angsuran"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Jumlah dibayarkan",
                  jml..text = value.detailcicilan["jml_bayar"],
                  TextInputType.number),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Keterangan",
                  ket..text = value.detailcicilan["keterangan"],
                  TextInputType.text),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AnimatedContainer(
                      duration: Duration(milliseconds: 1500),
                      child: AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.black.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        content: Image.network(
                            "http://apiutangin.hendrikofirman.com/uploads/Cicilan/" +
                                value.detailcicilan["bukti_transfer"]),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              'Kembali',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 124, 120, 119),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Bukti Transfer",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  config.konfirmasiCicilan(
                      value.detailcicilan["id_cicilan"], context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Kirim",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
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
