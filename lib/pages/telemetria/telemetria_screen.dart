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
  List<Situacoes> situacoes = [];

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

    for (var categoria in arrayCategorias) {
      rows.add(DataRow(
        cells: <DataCell>[
          DataCell(
            CellText(text: categoria.descricao),
          ),
          DataCell(
            CellText(text: '5555'),
          ),
          DataCell(
            CellText(text: '5555'),
          ),
          DataCell(
            CellText(text: '5555'),
          ),
        ],
      ));
    }

    _telemetriaDao.getTelemetria().then((value) {
      print(value.setores);
      for (var setor in value.setores!) {
        columns.add(
          DataColumn(
            label: HeaderText(
              text: setor.dsSetor!,
            ),
          ),
        );
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
                  columns: columns,
                  rows: rows,
                  // rows: arrayCategorias
                  //     .map(
                  //       ((element) => DataRow(
                  //             cells: <DataCell>[
                  //               DataCell(CellText(text: element.descricao)),
                  //               const DataCell(CellText(text: '19')),
                  //               const DataCell(CellText(text: 'Student')),
                  //               const DataCell(CellText(text: 'Student')),
                  //               // const DataCell(CellText(text: 'Student')),
                  //               // const DataCell(CellText(text: 'Student')),
                  //               // const DataCell(CellText(text: 'Student')),
                  //             ],
                  //           )),
                  //     )
                  //     .toList(),
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
