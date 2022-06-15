class JsonRekening {
  final String id_rekening;
  final String no_rek;
  final String bank;

  JsonRekening(this.no_rek, this.id_rekening, this.bank);

  JsonRekening.fromJson(Map<String, dynamic> json)
      : no_rek = json['no_rek'],
        id_rekening = json['id_rekening'],
        bank = json['bank'];

  Map<String, dynamic> toJson() =>
      {'id_rekening': id_rekening, 'no_rek': no_rek, 'bank': bank};
}
