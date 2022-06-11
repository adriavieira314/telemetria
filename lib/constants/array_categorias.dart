class ArrayCategorias {
  final int idCategoria;
  final String descricao;

  ArrayCategorias(this.idCategoria, this.descricao);
}

final arrayCategorias = [
  ArrayCategorias(0, 'FORA CICLO'),
  ArrayCategorias(1, 'PARADA AGUARDANDO TECNICO'),
  ArrayCategorias(2, 'PARADA REINICIO FIM SEMANA FERIADO'),
  ArrayCategorias(3, 'PARADA MANUTENCAO'),
  ArrayCategorias(4, 'PARADA LIGACAO PERIFERICOS'),
  ArrayCategorias(5, 'PARADA FERRAMENTARIA'),
  ArrayCategorias(6, 'PARADA TROCA MOLDE'),
  ArrayCategorias(7, 'PARADA MATERIA PRIMA'),
  ArrayCategorias(8, 'PARADA OUTROS MOTIVOS'),
  ArrayCategorias(9, 'ALARME REFUGO'),
  ArrayCategorias(10, 'PARADA SEM PROGRAMA'),
];

class Exemplo {
  final int idCategoria;
  final String descricao;

  Exemplo(this.idCategoria, this.descricao);
}

final exemplo = [
  ArrayCategorias(0, 'setor 1'),
  ArrayCategorias(1, 'setor 2'),
  ArrayCategorias(2, 'setor 3'),
  ArrayCategorias(3, 'setor 4'),
  ArrayCategorias(4, 'setor 5'),
  ArrayCategorias(5, 'setor 6'),
];
