import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EvaluasiTawaranModel with ChangeNotifier {
  List<dynamic> _datatawaran = [];
  List<dynamic> get datatawaran => _datatawaran;

  Map<dynamic, dynamic> _databorrower = {};
  Map<dynamic, dynamic> get databorrower => _databorrower;

  Map<String, dynamic> _detailtawaran = {};
  Map<String, dynamic> get detailtawaran => _detailtawaran;

  var url = "http://10.0.2.2/Utangin_API";
  var endpoint_list_tawaran = "User/Penawaran/Tawaran_kepada_saya";
  var endpoint_detail_tawaran = "User/Penawaran/Detail_tawaran";
  var endpoint_acc_tawaran = "User/Penawaran/Tawaran_diterima";

  getListTawaran(String ktpborrower) async {
    var hasilResponse =
        await http.get(Uri.parse("$url/$endpoint_list_tawaran/$ktpborrower"));
    _datatawaran = await json.decode(hasilResponse.body);
    notifyListeners();
  }

  getDetailTawaran(String id_penawaran) async {
    var hasilResponse = await http
        .get(Uri.parse("$url/$endpoint_detail_tawaran/$id_penawaran"));
    _detailtawaran = await json.decode(hasilResponse.body)[0];
    notifyListeners();
    return json.decode(hasilResponse.body)[0];
  }

  accTawaran(String id_penawaran) async {
    await http.get(Uri.parse("$url/$endpoint_acc_tawaran/$id_penawaran"));
    notifyListeners();
  }
}
