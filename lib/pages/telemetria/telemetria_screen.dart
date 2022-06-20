import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:telemetria/constants/array_categorias.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
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
  late dynamic cellText;
  late String _timeString;
  late Timer _timer;

  List<Map<String, dynamic>> arrayRows = [];
  Map<String, dynamic> colunas = {};

  List<DataColumn> columns = [
    const DataColumn(
      label: HeaderText(
        text: TelemetriaScreenText.empresa,
      ),
    )
  ];

  getColor(String maquinaColor) {
    String hex = '0xFF';
    //situacoes[i].maquinas[0].corFonte
    String color = maquinaColor.substring(1, 7);
    String colorFormated = hex + color;
    int hexColor = int.parse(colorFormated);
    return hexColor;
  }

  void _getTime() {
    final String formattedDateTime =
        DateFormat('dd/MM/yyyy kk:mm:ss').format(DateTime.now()).toString();
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  @override
  void initState() {
    super.initState();
    // _timeString = _formatDateTime(DateTime.now());
    _getTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

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
              // adicionando ao objeto colunas um item categoria
              colunas['categoria'] = Text(
                arrayCategorias[arrayCat].descricao,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );

              // adicionando ao objeto colunas a quantidade de celulas dinamicamente
              if (situacoes[i].maquinas!.isNotEmpty) {
                // adicionando as maquinas ao texto das celulas
                setState(() {
                  if (situacoes[i].maquinas.length > 1) {
                    cellText = Wrap(
                      children: situacoes[i]
                          .maquinas
                          .map<Widget>(
                            (maquina) => Text(
                              '${maquina.idMaquina} ',
                              style: TextStyle(
                                color: Color(
                                  getColor(maquina.corFonte),
                                ),
                                // fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    cellText = Text(
                      situacoes[i].maquinas[0].idMaquina,
                      style: TextStyle(
                        color: Color(
                          getColor(situacoes[i].maquinas[0].corFonte),
                        ),
                        // fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

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

        // crio uma linha ao acabar o loop de setores e inicio novamente ate o loop arrayCategorias terminar
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

    // orientação landscape somente
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _timer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 200,
              child: FittedBox(
                child: Text(
                  _timeString,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            // AppBarText(text: _timeString.toString()),
            const AppBarText(text: TelemetriaScreenText.titulo),
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
                  horizontalMargin: 0,
                  columnSpacing: 10,
                  dataRowHeight: (MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          headingRowHeight) /
                      arrayCategorias.length,
                  headingRowHeight: headingRowHeight,
                  border: TableBorder.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  columns: columns,
                  rows: arrayRows.map((row) {
                    return DataRow(
                        cells: row.values.map((cellValue) {
                      return DataCell(cellValue);
                    }).toList());
                  }).toList(),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  final String text;
  const HeaderText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
