import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../pages/auth/sukses_daftar.dart';
import '../pages/home/menu_login.dart';
import '../pages/landing.dart';
import '../template/reusablewidgets.dart';

class AuthServices with ChangeNotifier {
  Map<dynamic, dynamic> _getlogin = {};
  Map<dynamic, dynamic> get data => _getlogin;

  String _emailterdaftar = "";
  String get emailterdaftar => _emailterdaftar;

  String _nomorterdaftar = "";
  String get nomorterdaftar => _nomorterdaftar;

  String _ktpterdaftar = "";
  String get ktpterdaftar => _ktpterdaftar;

  String _verifotp = "";
  String get verifotp => _verifotp;

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_cek_email = "No_login/Cek_email";
  var endpoint_cek_no_hp = "No_login/Cek_no_hp";
  var endpoint_send_otp = "No_login/Kirim_otp";
  var endpoint_cek_ktp = "No_login/Cek_ktp";
  var endpoint_signup = "No_login/Sign_up";
  var endpoint_login = "No_login/Login";
  var endpoint_auth = "No_login/Cek_login";
  var endpoint_logout = "User/Logout";

  checkEmail(String email) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_cek_email?email=$email"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _emailterdaftar = "";
    } else {
      notifyListeners();
      _emailterdaftar = await json.decode(response.body)["status"];
    }
  }

  checkNoHP(String nohp) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_cek_no_hp?no_hp=$nohp"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _nomorterdaftar = "";
    } else {
      notifyListeners();
      _nomorterdaftar = await json.decode(response.body)["status"];
    }
  }

  kirimOTP(String email) async {
    var response = await http.post(
      Uri.parse("$url/$endpoint_send_otp"),
      body: {
        "email": email,
      },
    );
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _verifotp = "";
    } else {
      notifyListeners();
      _verifotp = await json.decode(response.body)["otp"];
    }
  }

  checkKtp(String ktp) async {
    var response = await http.get(Uri.parse("$url/$endpoint_cek_ktp?ktp=$ktp"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _ktpterdaftar = "";
    } else {
      notifyListeners();
      _ktpterdaftar = await json.decode(response.body)["status"];
    }
  }

  //daftar
  postRequest(
    ktp,
    nama,
    email,
    password,
    jk,
    tgllahir,
    npwp,
    alamat,
    rt,
    rw,
    provinsi,
    pendidikan,
    pekerjaan,
    File? fotoktp,
    File? fotoselfie,
    File? tandatangan,
    nohp,
    context,
  ) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse("$url/$endpoint_signup"));
      request.fields["ktp"] = ktp;
      request.fields["nama"] = nama;
      request.fields["email"] = email;
      request.fields["pass"] = password;
      request.fields["pass_konf"] = password;
      request.fields["tgl_lahir"] = tgllahir;
      request.fields["alamat"] = alamat;
      request.fields["provinsi"] = provinsi;
      request.fields["pendidikan"] = pendidikan;
      request.fields["pekerjaan"] = pekerjaan;
      request.fields["no_hp"] = nohp;
      request.fields["jk"] = jk;
      request.fields["npwp"] = npwp;
      request.fields["rt"] = rt;
      request.fields["rw"] = rw;
      request.files.add(
        http.MultipartFile(
          "foto_ktp",
          http.ByteStream(fotoktp!.openRead()).cast(),
          await fotoktp.length(),
          filename: path.basename(fotoktp.path),
        ),
      );
      request.files.add(
        http.MultipartFile(
          "foto_selfie",
          http.ByteStream(fotoselfie!.openRead()).cast(),
          await fotoselfie.length(),
          filename: path.basename(fotoselfie.path),
        ),
      );
      request.files.add(
        http.MultipartFile(
          "foto_ttd",
          http.ByteStream(tandatangan!.openRead()).cast(),
          await tandatangan.length(),
          filename: path.basename(tandatangan.path),
        ),
      );
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var msg = json.decode(respStr);

      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context).pushReplacementNamed(NotifSuksesDaftar.nameRoute);
      } else {
        pd.close();
        ReusableWidgets.alertNotification(
            context,
            "Terjadi Kesalahan. Status : ${response.statusCode} $msg",
            Icons.error);
      }
    } on SocketException {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Tidak ada koneksi internet.", Icons.error);
    } on TimeoutException {
      pd.close();
      ReusableWidgets.alertNotification(
          context,
          "Koneksi waktu habis. Pastikan perangkat anda terhubung ke internet.",
          Icons.error);
    } on Exception catch (e) {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Terjadi Kesalahan $e", Icons.error);
    }
  }

  login(String email, String password, context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");

    var response = await http.post(
      Uri.parse("$url/$endpoint_login"),
      body: {
        "email": email,
        "password": password,
      },
    );

    _getlogin = await json.decode(response.body);
    if (_getlogin["status"] == "1") {
      notifyListeners();
      pd.close();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('status', true);
      await prefs.setString('ktp', _getlogin["ktp"]);
      Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
    } else if (_getlogin["status"] == "0") {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Login gagal. Email tidak terdaftar.", Icons.error);
    } else if (_getlogin["status"] == "3") {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Login gagal. Email Belum diverifikasi.", Icons.error);
    } else {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Login gagal. Email atau Password salah.", Icons.error);
    }
  }

  logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('status');
    await prefs.remove('ktp');
    Navigator.of(context).pushReplacementNamed(MyHomePage.nameRoute);
    notifyListeners();
  }
}
