import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:utangin/pages/home/user/data_rekening.dart';

import '../template/reusablewidgets.dart';

class UserModel with ChangeNotifier {
  List<dynamic> _datarekening = [];
  List<dynamic> get datarekening => _datarekening;

  List<dynamic> _hutangberjalan = [];
  List<dynamic> get hutangberjalan => _hutangberjalan;

  Map<String, dynamic> _piutangberjalan = {};
  Map<String, dynamic> get piutangberjalan => _piutangberjalan;

  var url = "http://10.0.2.2/Utangin_API";
  var endpoint_hutang_berjalan = "User/Transaksi/Jumlah_hutang_berjalan";
  var endpoint_piutang_berjalan = "User/Transaksi/Jumlah_piutang_berjalan";
  var endpoint_cari_rekening = "User/Rekening/Baca_ktp";
  var endpoint_hapus_rekening = "User/Rekening/Hapus";
  var endpoint_tambah_rekening = "User/Rekening/Tambah";

  getListHutang(String ktpborrower) async {
    var hasilResponse = await http
        .get(Uri.parse("$url/$endpoint_hutang_berjalan/$ktpborrower"));
    _hutangberjalan = await json.decode(hasilResponse.body);
    print(_hutangberjalan);
    notifyListeners();
  }

  getListPiutang(String ktplender) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_piutang_berjalan/$ktplender"));
    _piutangberjalan = await json.decode(hasilResponse.body);
    notifyListeners();
  }

  getListRekening(String ktp) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_cari_rekening/$ktp"));
    _datarekening = await json.decode(hasilResponse.body);
    notifyListeners();
  }

  Future hapusRekening(String id_rekening) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_hapus_rekening/$id_rekening"));
    notifyListeners();
    return hasilResponse.statusCode;
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
