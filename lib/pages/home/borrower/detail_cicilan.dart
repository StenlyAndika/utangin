import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/evaluasi_hutang_services.dart';
import '../../../pages/home/menu_login.dart';
import '../../../template/reusablewidgets.dart';
import '../borrower/menu_borrower.dart';
import 'borrower_riwayat.dart';

class DetailCicilan extends StatefulWidget {
  DetailCicilan({Key? key}) : super(key: key);

  static const nameRoute = '/pageDetailCicilan';

  @override
  State<DetailCicilan> createState() => _DetailCicilanState();
}

class _DetailCicilanState extends State<DetailCicilan> {
  late TextEditingController email = TextEditingController();
  late TextEditingController nama = TextEditingController();
  late TextEditingController tanggal = TextEditingController();
  late TextEditingController jumlah = TextEditingController();
  late TextEditingController cicilan_ke = TextEditingController();
  late TextEditingController jml = TextEditingController();
  late TextEditingController ket = TextEditingController();

  late String ktp_lender;
  File? _bukti;

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
    getDetailCicilan();
    super.initState();
  }

  getDetailCicilan() async {
    final session = Provider.of<EvaluasiHutangServices>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String? id_cicilan = await prefs.getString("id_cicilan");
    await session.getDetailCicilan(id_cicilan!);
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
                "Detail Pembayaran Cicilan",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ReusableWidgets.inputReadOnlyField(
                  "Email Lender",
                  email..text = value.detailcicilan["email"],
                  TextInputType.text),
              SizedBox(height: 5),
              ReusableWidgets.inputReadOnlyField(
                  "Nama Lender",
                  nama..text = value.detailcicilan["nama"],
                  TextInputType.text),
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
              ReusableWidgets.inputField(
                  "Jumlah dibayarkan", jml, TextInputType.number),
              SizedBox(height: 5),
              ReusableWidgets.inputField("Keterangan", ket, TextInputType.text),
              SizedBox(height: 5),
              Text((_bukti == null) ? "" : "Bukti pembayaran telah dipilih."),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  showOptionMenu(0);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 124, 120, 119),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Upload Bukti Transfer",
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
                  String? id_cicilan = await prefs.getString("id_cicilan");
                  if (_bukti == null) {
                    return ReusableWidgets.alertNotification(context,
                        "Bukti Pembayaran belum dipilih.", Icons.error);
                  }
                  config.bayarCicilan(
                      id_cicilan, jml.text, _bukti, ket.text, context);
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

  void showOptionMenu(int stat) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(10),
          height: 120,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.folder),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ReusableWidgets.openGallery(stat).then((pickedImage) {
                      if (pickedImage != null) {
                        setState(() {
                          _bukti = File(pickedImage!.path);
                        });
                      }
                    });
                  },
                  label: Text(
                    "Gallery",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ReusableWidgets.openCamera(stat).then((pickedImage) {
                      if (pickedImage != null) {
                        setState(() {
                          _bukti = File(pickedImage!.path);
                        });
                      }
                    });
                  },
                  label: Text(
                    "Kamera",
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.4, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
