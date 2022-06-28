import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EvaluasiTawaranServices with ChangeNotifier {
  List<dynamic> _datatawaran = [];
  List<dynamic> get datatawaran => _datatawaran;

  Map<dynamic, dynamic> _databorrower = {};
  Map<dynamic, dynamic> get databorrower => _databorrower;

  Map<String, dynamic> _detailtawaran = {};
  Map<String, dynamic> get detailtawaran => _detailtawaran;

  var url = "http://apiutangin.hendrikofirman.com";
  var endpoint_list_tawaran = "User/Penawaran/Tawaran_kepada_saya";
  var endpoint_detail_tawaran = "User/Penawaran/Detail_tawaran";
  var endpoint_acc_tawaran = "User/Penawaran/Tawaran_diterima";

  getListTawaran(String ktpborrower) async {
    var response =
        await http.get(Uri.parse("$url/$endpoint_list_tawaran/$ktpborrower"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _datatawaran = [];
    } else {
      notifyListeners();
      _datatawaran = await json.decode(response.body);
    }
  }

  getDetailTawaran(String id_penawaran) async {
    var response = await http
        .get(Uri.parse("$url/$endpoint_detail_tawaran/$id_penawaran"));
    if (json.decode(response.body).isEmpty) {
      notifyListeners();
      return _detailtawaran = {};
    } else {
      notifyListeners();
      _detailtawaran = await json.decode(response.body)[0];
    }
    return _detailtawaran;
  }

  accTawaran(String id_penawaran) async {
    await http.get(Uri.parse("$url/$endpoint_acc_tawaran/$id_penawaran"));
    notifyListeners();
  }
}
