import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:utangin/pages/home/lender/sukses_revisi.dart';

import '../pages/home/lender/sukses_konfirmasi.dart';
import '../pages/home/lender/sukses_tawaran_peminjaman.dart';
import '../pages/home/lender/upload_bukti_peminjaman.dart';
import '../template/reusablewidgets.dart';

class EvaluasiPinjamanServices with ChangeNotifier {
  List<dynamic> _datapinjaman = [];
  List<dynamic> get datapinjaman => _datapinjaman;

  Map<dynamic, dynamic> _databorrower = {};
  Map<dynamic, dynamic> get databorrower => _databorrower;

  Map<String, dynamic> _detailpinjaman = {};
  Map<String, dynamic> get detailpinjaman => _detailpinjaman;

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_list_pinjaman = "User/Permohonan/Permohonan_kepada_saya";
  var endpoint_detail_pinjaman = "User/Permohonan/Detail_permohonan";
  var endpoint_acc = "User/Permohonan/ACC_lender";
  var endpoint_konfirmasi = "User/Transaksi/Konfirmasi_pinjaman";
  var endpoint_revisi = "User/Permohonan/Kirim_revisi_permohonan";
  var endpoint_kirim_tawaran = "User/Penawaran/Kirim_tawaran";
  var endpoint_cari_borrower = "User/Data_user/Read_email";

  getListPinjaman(String niklender) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_list_pinjaman/$niklender"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _datapinjaman = [];
    } else {
      notifyListeners();
      _datapinjaman = await json.decode(response.body);
    }
  }

  getDetailPinjaman(String idpermohonan) async {
    var response = await http
        .get(Uri.parse("$url/$endpoint_detail_pinjaman/$idpermohonan"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _detailpinjaman = {};
    } else {
      notifyListeners();
      _detailpinjaman = await json.decode(response.body)[0];
    }
  }

  Future cariBorrower(String email) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_cari_borrower?email=$email"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _databorrower = {};
    } else {
      notifyListeners();
      return _databorrower = await json.decode(response.body)[0];
    }
  }

  tawarkanPinjaman(context, ktp_borrower, jumlah_tawaran, tanggal_pengembalian,
      denda) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");

    final prefs = await SharedPreferences.getInstance();
    String? ktp_lender = await prefs.getString("ktp");
    try {
      var response = await http.post(
        Uri.parse("$url/$endpoint_kirim_tawaran"),
        body: {
          "ktp_lender": ktp_lender,
          "ktp_borrower": ktp_borrower,
          "jumlah_tawaran": jumlah_tawaran,
          "tanggal_pengembalian": tanggal_pengembalian,
          "denda": denda,
        },
      ).timeout(Duration(seconds: 10));

      print(response.body);

      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(NotifTawaranPeminjaman.nameRoute);
      } else {
        pd.close();
        ReusableWidgets.alertNotification(
            context, "Tawaran Peminjaman gagal dikirim", Icons.error);
      }
    } on TimeoutException {
      pd.close();
      ReusableWidgets.alertNotification(
          context,
          "Koneksi waktu habis. Pastikan perangkat anda terhubung ke internet.",
          Icons.error);
    }
  }

  revisiPinjaman(context, id_permohonan, ket_revisi, jumlah, id_rekening,
      kegunaan, tanggal_pengembalian, termin, denda) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");

    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    try {
      var response = await http.post(
        Uri.parse("$url/$endpoint_revisi"),
        body: {
          "ktp": ktp,
          "jumlah": jumlah,
          "id_rekening": id_rekening,
          "kegunaan": kegunaan,
          "tanggal_pengembalian": tanggal_pengembalian,
          "termin": termin,
          "denda": denda,
          "ket_revisi": ket_revisi,
          "id_permohonan": id_permohonan
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context).pushReplacementNamed(NotifSuksesRevisi.nameRoute);
      } else {
        pd.close();
        ReusableWidgets.alertNotification(
            context, "Revisi Peminjaman gagal dikirim", Icons.error);
      }
    } on TimeoutException {
      pd.close();
      ReusableWidgets.alertNotification(
          context,
          "Koneksi waktu habis. Pastikan perangkat anda terhubung ke internet.",
          Icons.error);
    }
  }

  accPinjaman(context, idp) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");
    final prefs = await SharedPreferences.getInstance();
    String? ktp = await prefs.getString("ktp");
    try {
      var response = await http.post(
        Uri.parse("$url/$endpoint_acc/$idp"),
        body: {
          "ktp": ktp,
        },
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(UploadBuktiPeminjaman.nameRoute);
      } else {
        pd.close();
        ReusableWidgets.alertNotification(
            context, "Pinjaman gagal disetujui", Icons.error);
      }
    } on TimeoutException {
      pd.close();
      ReusableWidgets.alertNotification(
          context,
          "Koneksi waktu habis. Pastikan perangkat anda terhubung ke internet.",
          Icons.error);
    }
  }

  konfirmasi(
    idp,
    bukti,
    context,
  ) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse("$url/$endpoint_konfirmasi"));
      request.fields["id_permohonan"] = idp;
      request.files.add(
        http.MultipartFile(
          "bukti_peminjaman",
          http.ByteStream(bukti!.openRead()).cast(),
          await bukti.length(),
          filename: path.basename(bukti.path),
        ),
      );
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var msg = json.decode(respStr);

      // print(response);
      print(respStr);
      print(msg);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('kdt', json.decode(respStr)["id_transaksi"]);

      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(NotifPeminjamanTerdokumentasi.nameRoute);
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
}
