class CategoriasParadas {
  List<Categorias>? categorias;

  CategoriasParadas({this.categorias});

  CategoriasParadas.fromJson(Map<String, dynamic> json) {
    if (json['categorias'] != null) {
      categorias = <Categorias>[];
      json['categorias'].forEach((v) {
        categorias!.add(Categorias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categorias != null) {
      data['categorias'] = categorias!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categorias {
  int? idCatPar;
  String? dsCatPar;

  Categorias({this.idCatPar, this.dsCatPar});

  Categorias.fromJson(Map<String, dynamic> json) {
    idCatPar = json['idCatPar'];
    dsCatPar = json['dsCatPar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idCatPar'] = idCatPar;
    data['dsCatPar'] = dsCatPar;
    return data;
  }
}
