import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../pages/home/user/data_rekening.dart';

import '../template/reusablewidgets.dart';

class UserServices with ChangeNotifier {
  List<dynamic> _datarekening = [];
  List<dynamic> get datarekening => _datarekening;

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_cari_rekening = "User/Rekening/Baca_ktp";
  var endpoint_hapus_rekening = "User/Rekening/Hapus";
  var endpoint_tambah_rekening = "User/Rekening/Tambah";

  getListRekening(String ktp) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_cari_rekening/$ktp"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _datarekening = [];
    } else {
      notifyListeners();
      _datarekening = await json.decode(response.body)[0];
    }
  }

  Future hapusRekening(String id_rekening) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_hapus_rekening/$id_rekening"));
    notifyListeners();
    return response.statusCode;
  }

  tambahRekening(ktp, norek, bank, context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");
    try {
      var response = await http.post(
        Uri.parse("$url/$endpoint_tambah_rekening"),
        body: {
          "ktp": ktp,
          "no_rek": norek,
          "bank": bank,
        },
      );
      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context).pushReplacementNamed(DataRekening.nameRoute);
      } else {
        pd.close();
        ReusableWidgets.alertNotification(context,
            "Terjadi Kesalahan. Status : ${response.statusCode}", Icons.error);
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
}
