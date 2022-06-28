import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../pages/home/borrower/sukses_pengajuan.dart';
import '../template/reusablewidgets.dart';

class PengajuanServices with ChangeNotifier {
  Map<dynamic, dynamic> _datauser = {};
  Map<dynamic, dynamic> get datauser => _datauser;

  Map<dynamic, dynamic> _datalender = {};
  Map<dynamic, dynamic> get datalender => _datalender;

  List<dynamic> _datarekening = [];
  List<dynamic> get datarekening => _datarekening;

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_cek_ktp = "User/Data_user/Read_ktp";
  var endpoint_cari_lender = "User/Data_user/Read_email";
  var endpoint_pengajuan = "User/Permohonan/Kirim_permohonan";

  getUserData(String ktp) async {
    var response = await http.get(Uri.parse("$url/$endpoint_cek_ktp?ktp=$ktp"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _datauser = {};
    } else {
      notifyListeners();
      _datauser = await json.decode(response.body)[0];
    }
  }

  Future cariLender(String email) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_cari_lender?email=$email"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _datalender = {};
    } else {
      notifyListeners();
      return _datalender = await json.decode(response.body)[0];
    }
  }

  postPinjaman(context, ktp_borrower, ktp_lender, jumlah, id_rekening, kegunaan,
      tanggal_pengembalian, termin, denda) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");
    try {
      var response = await http.post(
        Uri.parse("$url/$endpoint_pengajuan"),
        body: {
          "ktp_borrower": ktp_borrower,
          "ktp_lender": ktp_lender,
          "jumlah": jumlah,
          "id_rekening": id_rekening,
          "kegunaan": kegunaan,
          "tanggal_pengembalian": tanggal_pengembalian,
          "termin": termin,
          "denda": denda,
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(NotifSuksesPengajuan.nameRoute);
      } else {
        pd.close();
        ReusableWidgets.alertNotification(
            context, "Pengajuan pinjaman gagal dikirim", Icons.error);
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
