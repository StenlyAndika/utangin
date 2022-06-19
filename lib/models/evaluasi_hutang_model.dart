import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../pages/home/borrower/sukses_pelunasan.dart';
import '../pages/home/lender/sukses_pelunasan_lender.dart';

import '../template/reusablewidgets.dart';

class EvaluasiHutangModel with ChangeNotifier {
  List<dynamic> _datahutang = [];
  List<dynamic> get datahutang => _datahutang;

  List<dynamic> _listcicilan = [];
  List<dynamic> get listcicilan => _listcicilan;

  Map<dynamic, dynamic> _datalender = {};
  Map<dynamic, dynamic> get datalender => _datalender;

  Map<String, dynamic> _detailcicilan = {};
  Map<String, dynamic> get detailcicilan => _detailcicilan;

  var url = "http://10.0.2.2/Utangin_API";
  var endpoint_list_hutang = "User/Permohonan/Permohonan_dari_saya";
  var endpoint_cari_id = "User/Cicilan/cariIdTransaksi";
  var endpoint_list_cicilan = "User/Cicilan/Daftar_cicilan";
  var endpoint_detail_cicilan = "User/Cicilan/Detail_cicilan";
  var endpoint_detail_cicilan_lender = "User/Cicilan/Detail_cicilan_lender";
  var endpoint_bayar_cicilan = "User/Cicilan/Bayar_cicilan";
  var endpoint_konfirmasi_cicilan = "User/Cicilan/Konfirmasi_cicilan";

  getListHutang(String nikborrower) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_list_hutang/$nikborrower"));
    _datahutang = await json.decode(hasilResponse.body);
    notifyListeners();
  }

  Future cariIDTransaksi(String id_permohonan) async {
    String id;
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_cari_id/$id_permohonan"));
    id = await json.decode(hasilResponse.body)[0]["id_transaksi"];
    notifyListeners();
    return id;
  }

  getListCicilan(String id_transaksi) async {
    var hasilResponse = await http.post(
      Uri.parse("$url/$endpoint_list_cicilan"),
      body: {
        "id_transaksi": id_transaksi,
      },
    );
    _listcicilan = await json.decode(hasilResponse.body);
    notifyListeners();
  }

  getDetailCicilan(String id_cicilan) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_detail_cicilan/$id_cicilan"));
    _detailcicilan = await json.decode(hasilResponse.body)[0];
    notifyListeners();
  }

  getDetailCicilanLender(String id_cicilan) async {
    var hasilResponse = await http
        .get(Uri.parse("$url/$endpoint_detail_cicilan_lender/$id_cicilan"));
    _detailcicilan = await json.decode(hasilResponse.body)[0];
    notifyListeners();
  }

  konfirmasiCicilan(String id_cicilan, context) async {
    var hasilResponse = await http
        .get(Uri.parse("$url/$endpoint_konfirmasi_cicilan/$id_cicilan"));
    if (hasilResponse.statusCode == 200) {
      Navigator.of(context)
          .pushReplacementNamed(NotifSuksesPelunasanLender.nameRoute);
    } else {
      ReusableWidgets.alertNotification(
          context,
          "Terjadi Kesalahan. Status : ${hasilResponse.statusCode}",
          Icons.error);
    }
    notifyListeners();
  }

  bayarCicilan(
      id_cicilan, jml_bayar, bukti_transfer, keterangan, context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: -1, msg: "Mohon tunggu...");
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("$url/$endpoint_bayar_cicilan"));
      request.fields["id_cicilan"] = id_cicilan;
      request.fields["jml_bayar"] = jml_bayar;
      request.fields["keterangan"] = keterangan;
      request.files.add(
        http.MultipartFile(
          "bukti_transfer",
          http.ByteStream(bukti_transfer!.openRead()).cast(),
          await bukti_transfer.length(),
          filename: path.basename(bukti_transfer.path),
        ),
      );
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      var msg = json.decode(respStr);
      print(msg);
      if (response.statusCode == 200) {
        pd.close();
        notifyListeners();
        Navigator.of(context)
            .pushReplacementNamed(NotifSuksesPelunasan.nameRoute);
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
