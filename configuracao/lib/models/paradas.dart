class ParadasList {
  List<Paradas>? paradas;

  ParadasList({this.paradas});

  ParadasList.fromJson(Map<String, dynamic> json) {
    if (json['paradas'] != null) {
      paradas = <Paradas>[];
      json['paradas'].forEach((v) {
        paradas!.add(Paradas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paradas != null) {
      data['paradas'] = paradas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Paradas {
  String? cdParada;
  String? dsParada;
  int? tipoPar;
  bool? check;

  Paradas({this.cdParada, this.dsParada, this.tipoPar, this.check});

  Paradas.fromJson(Map<String, dynamic> json) {
    cdParada = json['cdParada'];
    dsParada = json['dsParada'];
    tipoPar = json['tipoPar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cdParada'] = cdParada;
    data['dsParada'] = dsParada;
    data['tipoPar'] = tipoPar;
    data['check'] = check;
    return data;
  }
}
