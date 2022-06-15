import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PengajuanModel with ChangeNotifier {
  Map<dynamic, dynamic> _datauser = {};
  Map<dynamic, dynamic> get datauser => _datauser;

  Map<dynamic, dynamic> _datalender = {};
  Map<dynamic, dynamic> get datalender => _datalender;

  List<dynamic> _datarekening = [];
  List<dynamic> get datarekening => _datarekening;

  var url = "http://10.0.2.2/Utangin_API";
  var endpoint_cek_ktp = "User/Data_user/Read_ktp";
  var endpoint_cari_lender = "User/Data_user/Read_email";
  var endpoint_pengajuan = "User/Permohonan/Kirim_permohonan";

  getUserData(String ktp) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_cek_ktp?ktp=$ktp"));
    _datauser = await json.decode(hasilResponse.body)[0];
    notifyListeners();
  }

  Future cariLender(String email) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_cari_lender?email=$email"));
    if (json.decode(hasilResponse.body).isEmpty) {
      notifyListeners();
      return _datalender = {};
    } else {
      notifyListeners();
      return _datalender = await json.decode(hasilResponse.body)[0];
    }
  }

  postPinjaman() async {
    var hasilResponse = await http.post(
      Uri.parse("$url/$endpoint_pengajuan"),
      body: {
        "ktp_borrower": "",
        "ktp_lender": "",
        "jumlah": "",
        "id_rekening": "",
        "kegunaan": "",
        "tanggal_pengembalian": "",
        "termin": "",
        "denda": "",
      },
    );
    if (hasilResponse.statusCode == 200) {
      print("OK");
    } else {
      print("error");
    }
    notifyListeners();
  }
}
