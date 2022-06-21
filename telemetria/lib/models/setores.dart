class SetoresList {
  List<SetoresDisponiveis>? setores;

  SetoresList({this.setores});

  SetoresList.fromJson(Map<String, dynamic> json) {
    if (json['setores'] != null) {
      setores = <SetoresDisponiveis>[];
      json['setores'].forEach((v) {
        setores!.add(SetoresDisponiveis.fromJson(v));
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

class SetoresDisponiveis {
  String? cdSetor;
  String? dsSetor;
  bool? check;

  SetoresDisponiveis({this.cdSetor, this.dsSetor, this.check});

  SetoresDisponiveis.fromJson(Map<String, dynamic> json) {
    cdSetor = json['cdSetor'];
    dsSetor = json['dsSetor'];
    check = json['check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cdSetor'] = cdSetor;
    data['dsSetor'] = dsSetor;
    data['check'] = check;
    return data;
  }
}
