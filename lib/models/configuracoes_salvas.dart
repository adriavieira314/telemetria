class ConfiguracoesSalvas {
  List<SetoreSelecionados>? setoreSelecionados;
  List<ParadasPorCategoria>? paradasPorCategoria;
  int? refugoProdReferencia;
  int? refugoVlrLimiteBranco;
  int? refugoVlrLimiteAmarelo;
  int? paradaTempoLimiteBranco;
  int? paradaTempoLimiteAmarelo;

  ConfiguracoesSalvas(
      {this.setoreSelecionados,
      this.paradasPorCategoria,
      this.refugoProdReferencia,
      this.refugoVlrLimiteBranco,
      this.refugoVlrLimiteAmarelo,
      this.paradaTempoLimiteBranco,
      this.paradaTempoLimiteAmarelo});

  ConfiguracoesSalvas.fromJson(Map<String, dynamic> json) {
    if (json['setoreSelecionados'] != null) {
      setoreSelecionados = <SetoreSelecionados>[];
      json['setoreSelecionados'].forEach((v) {
        setoreSelecionados!.add(SetoreSelecionados.fromJson(v));
      });
    }
    if (json['paradasPorCategoria'] != null) {
      paradasPorCategoria = <ParadasPorCategoria>[];
      json['paradasPorCategoria'].forEach((v) {
        paradasPorCategoria!.add(ParadasPorCategoria.fromJson(v));
      });
    }
    refugoProdReferencia = json['refugoProdReferencia'];
    refugoVlrLimiteBranco = json['refugoVlrLimiteBranco'];
    refugoVlrLimiteAmarelo = json['refugoVlrLimiteAmarelo'];
    paradaTempoLimiteBranco = json['paradaTempoLimiteBranco'];
    paradaTempoLimiteAmarelo = json['paradaTempoLimiteAmarelo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (setoreSelecionados != null) {
      data['setoreSelecionados'] =
          setoreSelecionados!.map((v) => v.toJson()).toList();
    }
    if (paradasPorCategoria != null) {
      data['paradasPorCategoria'] =
          paradasPorCategoria!.map((v) => v.toJson()).toList();
    }
    data['refugoProdReferencia'] = refugoProdReferencia;
    data['refugoVlrLimiteBranco'] = refugoVlrLimiteBranco;
    data['refugoVlrLimiteAmarelo'] = refugoVlrLimiteAmarelo;
    data['paradaTempoLimiteBranco'] = paradaTempoLimiteBranco;
    data['paradaTempoLimiteAmarelo'] = paradaTempoLimiteAmarelo;
    return data;
  }
}

class SetoreSelecionados {
  String? cdSetor;
  String? dsSetor;

  SetoreSelecionados({this.cdSetor, this.dsSetor});

  SetoreSelecionados.fromJson(Map<String, dynamic> json) {
    cdSetor = json['cdSetor'];
    dsSetor = json['dsSetor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cdSetor'] = cdSetor;
    data['dsSetor'] = dsSetor;
    return data;
  }
}

class ParadasPorCategoria {
  int? idCatPar;
  List<String>? paradas;

  ParadasPorCategoria({this.idCatPar, this.paradas});

  ParadasPorCategoria.fromJson(Map<String, dynamic> json) {
    idCatPar = json['idCatPar'];
    paradas = json['paradas'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idCatPar'] = idCatPar;
    data['paradas'] = paradas;
    return data;
  }
}
