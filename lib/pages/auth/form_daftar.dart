import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../pages/auth/form_login.dart';
import '../../../main.dart';
import '../../../models/auth.dart';
import '../../../template/reusablewidgets.dart';

class FormDaftar extends StatefulWidget {
  FormDaftar({Key? key}) : super(key: key);

  static const nameRoute = '/page4';

  @override
  State<FormDaftar> createState() => _FormDaftarState();
}

class _FormDaftarState extends State<FormDaftar> {
  File? _fotoktp, _fotoselfie, _tandatangan;
  late String jekel;
  late TextEditingController ktp;
  late TextEditingController nama;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController tgllahir;
  late TextEditingController npwp;
  late TextEditingController alamat;
  late TextEditingController rt;
  late TextEditingController provinsi;
  late TextEditingController pendidikan;
  late TextEditingController pekerjaan;
  late TextEditingController nohp;

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
                          if (stat == 1) {
                            _fotoktp = File(pickedImage!.path);
                          } else if (stat == 2) {
                            _fotoselfie = File(pickedImage!.path);
                          } else if (stat == 3) {
                            _tandatangan = File(pickedImage!.path);
                          }
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
                          if (stat == 1) {
                            _fotoktp = File(pickedImage!.path);
                          } else if (stat == 2) {
                            _fotoselfie = File(pickedImage!.path);
                          } else if (stat == 3) {
                            _tandatangan = File(pickedImage!.path);
                          }
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

  bool _isVisible = true;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8) _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasPasswordOneNumber = true;
    });
  }

  @override
  void initState() {
    ktp = TextEditingController();
    nama = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    tgllahir = TextEditingController();
    npwp = TextEditingController();
    alamat = TextEditingController();
    rt = TextEditingController();
    provinsi = TextEditingController();
    pendidikan = TextEditingController();
    pekerjaan = TextEditingController();
    nohp = TextEditingController();
    jekel = "Jenis Kelamin";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final daftar = Provider.of<AuthModel>(context, listen: false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ReusableWidgets.backAppBar("Daftar", context),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              "Selamat Bergabung",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(FormLogin.nameRoute);
              },
              child: SizedBox(
                height: 20,
                child: Text(
                  "Masuk ke akunmu",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: email..text = args.message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                readOnly: true,
                enableSuggestions: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Email",
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: password,
                onChanged: (password) => onPasswordChanged(password),
                textCapitalization: TextCapitalization.none,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                obscureText: _isVisible,
                enableSuggestions: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: _isVisible
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                  border: InputBorder.none,
                  labelText: "Password",
                  labelStyle: TextStyle(
                      color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            Column(
              children: [
                if (password.text != "") ...[
                  SizedBox(height: 5),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters
                                ? Colors.red
                                : Colors.transparent,
                            border: _isPasswordEightCharacters
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Minimal 8 huruf",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber
                                ? Colors.red
                                : Colors.transparent,
                            border: _hasPasswordOneNumber
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Memiliki setidaknya 1 angka",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ]
              ],
            ),
            SizedBox(height: 5),
            ReusableWidgets.inputField(
                "No HP", nohp..text = args.title, TextInputType.phone),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: ktp,
                onChanged: (ktp) {
                  setState(() {
                    daftar.checkKtp(ktp);
                  });
                },
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Nomor NIK/KTP",
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 110, 108, 108)),
                ),
              ),
            ),
            if (ktp.text != "") ...[
              Consumer<AuthModel>(
                builder: (context, value, child) => Visibility(
                  visible: (value.ktpterdaftar == "true") ? true : false,
                  child: Container(
                    padding: EdgeInsets.only(left: 5, top: 5),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "NIK telah terdaftar",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Nama Lengkap", nama, TextInputType.text),
            SizedBox(height: 5),
            inputJekel(),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Color.fromARGB(255, 184, 174, 174)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                readOnly: true,
                controller: tgllahir,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  labelText: "Tanggal Lahir",
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
                      tgllahir.text = formattedDate;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 5),
            ReusableWidgets.inputField("NPWP", npwp, TextInputType.text),
            SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Alamat Sesuai KTP", alamat, TextInputType.text),
            SizedBox(height: 5),
            ReusableWidgets.inputField("RT/RW", rt, TextInputType.number),
            SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Provinsi", provinsi, TextInputType.text),
            SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Pendidikan Terakhir", pendidikan, TextInputType.text),
            SizedBox(height: 5),
            ReusableWidgets.inputField(
                "Pekerjaan", pekerjaan, TextInputType.text),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child:
                      _fotoktp == null ? Text("") : Image.file(_fotoktp!),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: _fotoselfie == null
                      ? Text("")
                      : Image.file(_fotoselfie!),
                ),
                SizedBox(width: 5),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: _tandatangan == null
                      ? Text("")
                      : Image.file(_tandatangan!),
                ),
              ],
            ),
            SizedBox(height: 5),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showOptionMenu(1);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Foto KTP",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      showOptionMenu(2);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Foto diri dengan KTP",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      showOptionMenu(3);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Upload Tanda Tangan",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_fotoktp == null) {
                        return ReusableWidgets.alertNotification(
                            context, "Foto KTP belum dipilih.", Icons.error);
                      }

                      if (_fotoselfie == null) {
                        return ReusableWidgets.alertNotification(
                            context, "Foto Selfie belum dipilih.", Icons.error);
                      }

                      if (_tandatangan == null) {
                        return ReusableWidgets.alertNotification(context,
                            "Foto tanda tangan belum dipilih.", Icons.error);
                      }

                      daftar.postRequest(
                          ktp.text,
                          nama.text,
                          email.text,
                          password.text,
                          jekel,
                          tgllahir.text,
                          npwp.text,
                          alamat.text,
                          rt.text,
                          provinsi.text,
                          pendidikan.text,
                          pekerjaan.text,
                          _fotoktp,
                          _fotoselfie,
                          _tandatangan,
                          nohp.text,
                          context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Kirim",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Container inputJekel() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 184, 174, 174)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: jekel,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            onChanged: (String? newValue) {
              setState(() {
                jekel = newValue!;
              });
            },
            items: <String>["Jenis Kelamin", "Laki-Laki", "Perempuan"]
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
