class Telemetria {
  List<Setores>? setores;

  Telemetria({this.setores});

  Telemetria.fromJson(Map<String, dynamic> json) {
    if (json['setores'] != null) {
      setores = <Setores>[];
      json['setores'].forEach((v) {
        setores!.add(Setores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (setores != null) {
      data['setores'] = setores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Setores {
  String? dsSetor;
  List<Situacoes>? situacoes;

  Setores({this.dsSetor, this.situacoes});

  Setores.fromJson(Map<String, dynamic> json) {
    dsSetor = json['dsSetor'];
    if (json['situacoes'] != null) {
      situacoes = <Situacoes>[];
      json['situacoes'].forEach((v) {
        situacoes!.add(Situacoes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dsSetor'] = dsSetor;
    if (situacoes != null) {
      data['situacoes'] = situacoes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Situacoes {
  int? idSituacao;
  List<Maquinas>? maquinas;

  Situacoes({this.idSituacao, this.maquinas});

  Situacoes.fromJson(Map<String, dynamic> json) {
    idSituacao = json['idSituacao'];
    if (json['maquinas'] != null) {
      maquinas = <Maquinas>[];
      json['maquinas'].forEach((v) {
        maquinas!.add(Maquinas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idSituacao'] = idSituacao;
    if (maquinas != null) {
      data['maquinas'] = maquinas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Maquinas {
  String? idMaquina;
  String? corFonte;

  Maquinas({this.idMaquina, this.corFonte});

  Maquinas.fromJson(Map<String, dynamic> json) {
    idMaquina = json['idMaquina'];
    corFonte = json['corFonte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMaquina'] = idMaquina;
    data['corFonte'] = corFonte;
    return data;
  }
}
