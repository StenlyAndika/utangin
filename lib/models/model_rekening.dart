import 'dart:convert';

JsonRekening rekeningFromJson(String str) =>
    JsonRekening.fromJson(json.decode(str));

String rekeningToJson(JsonRekening data) => json.encode(data.toJson());

class JsonRekening {
  final String id_rekening;
  final String no_rek;
  final String bank;

  JsonRekening(
      {required this.no_rek, required this.id_rekening, required this.bank});

  factory JsonRekening.fromJson(Map<String, dynamic> json) => JsonRekening(
        no_rek: json['no_rek'],
        id_rekening: json['id_rekening'],
        bank: json['bank'],
      );

  Map<String, dynamic> toJson() =>
      {'id_rekening': id_rekening, 'no_rek': no_rek, 'bank': bank};
}
