import 'package:flutter/material.dart';
import 'package:telemetria/constants/array_categorias.dart';
import 'package:telemetria/models/telemetria.dart';
import 'package:telemetria/pages/telemetria/telemetria_screen_text.dart';
import 'package:telemetria/services/telemetriaDao/telemetria_dao.dart';

class TelemetriaScreen extends StatefulWidget {
  const TelemetriaScreen({Key? key}) : super(key: key);

  @override
  State<TelemetriaScreen> createState() => _TelemetriaScreenState();
}

class _TelemetriaScreenState extends State<TelemetriaScreen> {
  final double headingRowHeight = 40.0;
  final TelemetriaDao _telemetriaDao = TelemetriaDao();
  bool loadData = false;
  dynamic situacoesSetores = [];
  late Text cellText;

  List<Map<String, dynamic>> arrayRows = [];
  Map<String, dynamic> colunas = {};

  List<DataColumn> columns = [
    const DataColumn(
      label: HeaderText(
        text: 'Data e Hora aqui',
      ),
    ),
  ];

  List<DataRow> rows = [];

  List<DataCell> cells = [];

  @override
  void initState() {
    super.initState();
    var contador = 0;

    _telemetriaDao.getTelemetria().then((value) {
      // crio a quantidade de colunas do header a partir do setores
      for (var setor in value.setores!) {
        columns.add(
          DataColumn(
            label: HeaderText(
              text: setor.dsSetor!,
            ),
          ),
        );

        // adiciono a array setores a array situacoesSetores
        situacoesSetores.add(setor.situacoes);
      }

      for (var arrayCat = 0; arrayCat < arrayCategorias.length; arrayCat++) {
        setState(() {
          colunas = {};
          contador = 0;
        });

        for (var situacoes in situacoesSetores) {
          contador++;
          // *quantidade de colunas/setores

          for (var i = 0; i < situacoes.length; i++) {
            // *quantidade de linhas/categorias

            // verifico se no setor x, a situacao é igual ao id da categoria atual (arrayCat)
            // e adiciono as maquinas aquela categoria
            if (situacoes[i].idSituacao ==
                arrayCategorias[arrayCat].idCategoria) {
              colunas['categoria'] = Text(
                arrayCategorias[arrayCat].descricao,
                style: const TextStyle(color: Colors.white),
              );
              if (situacoes[i].maquinas!.isNotEmpty) {
                String hex = '0xFF';
                String getColor = situacoes[i].maquinas[0].corFonte;
                String color = getColor.substring(1, 7);
                String colorFormated = hex + color;
                int hexColor = int.parse(colorFormated);

                setState(() {
                  cellText = Text(
                    situacoes[i].maquinas[0].idMaquina,
                    style: TextStyle(
                      color: Color(hexColor),
                    ),
                  );
                  colunas['coluna$contador'] = cellText;
                });
              } else {
                setState(() {
                  cellText = const Text('');
                  colunas['coluna$contador'] = cellText;
                });
              }
            }
          }
        }

        setState(() {
          arrayRows.add(colunas);
        });
      }

      setState(() {
        loadData = true;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AppBarText(text: TelemetriaScreenText.empresa),
            AppBarText(text: TelemetriaScreenText.titulo),
            AppBarText(text: TelemetriaScreenText.logo),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: loadData
            ? Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.grey),
                child: DataTable(
                  dataRowHeight: (MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          headingRowHeight) /
                      arrayCategorias.length,
                  headingRowHeight: headingRowHeight,
                  border: TableBorder.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  // columns: const <DataColumn>[
                  //   DataColumn(
                  //     label: Text(
                  //       'Name',
                  //       style: TextStyle(fontStyle: FontStyle.italic),
                  //     ),
                  //   ),
                  //   DataColumn(
                  //     label: Text(
                  //       'Name',
                  //       style: TextStyle(fontStyle: FontStyle.italic),
                  //     ),
                  //   ),
                  //   DataColumn(
                  //     label: Text(
                  //       'Name',
                  //       style: TextStyle(fontStyle: FontStyle.italic),
                  //     ),
                  //   ),
                  // ],
                  columns: columns,
                  rows: arrayRows.map((row) {
                    return DataRow(
                        cells: row.values.map((cellValue) {
                      return DataCell(cellValue
                          // Text(
                          //   cellValue,
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //   ),
                          // ),
                          );
                    }).toList());
                  }).toList(),
                ),
              )
            : Container(),
      ),
    );
  }
}

class AppBarText extends StatelessWidget {
  final String text;
  const AppBarText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.red),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
    );
  }
}

class CellText extends StatelessWidget {
  final String text;
  const CellText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}
