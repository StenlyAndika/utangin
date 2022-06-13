import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../pages/auth/sukses_daftar.dart';
import '../pages/home/menu_login.dart';
import '../template/reusablewidgets.dart';

class AuthModel with ChangeNotifier {
  String _getlogin = "";
  String get data => _getlogin;

  String _emailterdaftar = "";
  String get emailterdaftar => _emailterdaftar;

  String _ktpterdaftar = "";
  String get ktpterdaftar => _ktpterdaftar;

  String _verifotp = "";
  String get verifotp => _verifotp;

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_cek_email = "No_login/Cek_email";
  var endpoint_send_otp = "No_login/Kirim_otp";
  var endpoint_cek_ktp = "User/Cek_ktp";
  var endpoint_signup = "No_login/Sign_up";
  var endpoint_login = "No_login/Login";
  var endpoint_auth = "No_login/Cek_login";
  var endpoint_logout = "User/Logout";

  checkEmail(String email) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_cek_email?email=$email"));

    _emailterdaftar = await json.decode(hasilResponse.body)["status"];
    notifyListeners();
  }

  kirimOTP(String email) async {
    var hasilResponse = await http.post(
      Uri.parse("$url/$endpoint_send_otp"),
      body: {
        "email": email,
      },
    );

    _verifotp = await json.decode(hasilResponse.body)["otp"];
    notifyListeners();
  }

  checkKtp(String ktp) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_cek_ktp?ktp=$ktp"));

    _ktpterdaftar = await json.decode(hasilResponse.body)["status"];
    notifyListeners();
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
    provinsi,
    pendidikan,
    pekerjaan,
    File? fotoktp,
    File? fotoselfie,
    File? tandatangan,
    nohp,
    context,
  ) async {
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
        notifyListeners();
        Navigator.of(context).pushReplacementNamed(NotifSuksesDaftar.nameRoute);
      } else {
        ReusableWidgets.alertNotification(
            context,
            "Terjadi Kesalahan. Status : ${response.statusCode} $msg",
            Icons.error);
      }
    } on SocketException {
      ReusableWidgets.alertNotification(
          context, "Tidak ada koneksi internet.", Icons.error);
    } on TimeoutException {
      ReusableWidgets.alertNotification(
          context,
          "Koneksi waktu habis. Pastikan perangkat anda memiliki akses internet.",
          Icons.error);
    } on Exception catch (e) {
      debugPrint("Error $e");
      ReusableWidgets.alertNotification(
          context, "Terjadi Kesalahan $e", Icons.error);
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  login(String email, String password, context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> _deviceData = <String, dynamic>{};
    _deviceData = _readAndroidBuildData(await deviceInfo.androidInfo);

    var hasilResponse = await http.post(
      Uri.parse("$url/$endpoint_login"),
      body: {
        "email": email,
        "password": password,
        "id_device": _deviceData["androidId"],
      },
    );

    _getlogin = await json.decode(hasilResponse.body)["status"];
    if (_getlogin == "1") {
      notifyListeners();
      pd.close();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('status', true);
      Navigator.of(context).pushReplacementNamed(MenuLogin.nameRoute);
    } else if (_getlogin == "0") {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Login gagal. Email tidak terdaftar.", Icons.error);
    } else if (_getlogin == "3") {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Login gagal. Email Belum diverifikasi.", Icons.error);
    } else {
      pd.close();
      ReusableWidgets.alertNotification(
          context, "Login gagal. Email atau Password salah.", Icons.error);
    }
  }

  Future<int> logout() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> _deviceData = <String, dynamic>{};
    _deviceData = _readAndroidBuildData(await deviceInfo.androidInfo);
    var deviceId = _deviceData["androidId"];
    var hasilResponse = await http.get(
      Uri.parse("$url/$endpoint_logout/$deviceId"),
    );
    notifyListeners();
    return hasilResponse.statusCode;
  }
}
