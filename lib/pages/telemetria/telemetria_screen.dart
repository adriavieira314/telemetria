import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:telemetria/constants/array_categorias.dart';
import 'package:telemetria/main.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
import 'package:telemetria/pages/configuracoes/configuracoes_screen.dart';
import 'package:telemetria/pages/telemetria/telemetria_screen_text.dart';
import 'package:telemetria/services/telemetriaDao/telemetria_dao.dart';
import 'package:telemetria/utils/constants.dart';

late Timer _timerRelogio;
late Timer _timerAtualizacao;
bool voltarConfig = false;

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
        DateFormat('dd/MM/yyyy - kk:mm').format(DateTime.now()).toString();
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  void _getTelemetria() {
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
  }

  void timersFunction() {
    _timerRelogio =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    // *timer de atualização da tela
    _timerAtualizacao = Timer.periodic(
      Duration(seconds: atualizacaoTempo),
      (Timer t) {
        if (mounted) {
          RestartWidget.restartApp(context);
          // orientação landscape somente
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        }
      },
    );
  }

  @override
  void initState() {
    _getTime();
    _getTelemetria();
    timersFunction();

    // orientação landscape somente
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    _timerRelogio.cancel();
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
    // orientação landscape somente
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            const AppBarText(text: TelemetriaScreenText.titulo),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0, left: 25.0),
            child: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  onTap: () => {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text(
                            'Inserir Técnico',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: LoginTecnico(),
                        ),
                      ).then((value) {
                        print('hi there');
                        if (voltarConfig == false) {
                          timersFunction();
                        }
                      }),
                    )
                  },
                  child: const Text(
                    'Tela Configuração',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  onTap: () => {
                    Future.delayed(
                      const Duration(seconds: 0),
                      () => showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text(
                            'Tempo da Paginação',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: TempoAtualizacao(),
                        ),
                      ).then((value) {
                        print('hi there');
                        timersFunction();
                      }),
                    )
                  },
                  child: const Text('Tempo de Atualização'),
                ),
              ],
            ),
          )
        ],
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

class LoginTecnico extends StatefulWidget {
  const LoginTecnico({Key? key}) : super(key: key);

  @override
  State<LoginTecnico> createState() => _LoginTecnicoState();
}

class _LoginTecnicoState extends State<LoginTecnico> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 250.0,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                onTap: () {
                  _timerAtualizacao.cancel();
                  _timerRelogio.cancel();
                  print('hello');
                },
                decoration: const InputDecoration(
                  labelText: 'Técnico',
                ),
                controller: userController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o técnico';
                  } else if (userController.text.toLowerCase() != "admin") {
                    return 'Técnico incorreto';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  obscureText: _isObscure,
                  onTap: () {
                    _timerAtualizacao.cancel();
                    _timerRelogio.cancel();
                    print('hello');
                  },
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  controller: senhaController,
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a senha';
                    } else if (senhaController.text != "12345") {
                      return 'Senha incorreta';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // fecho o modal
                      Navigator.pop(context);
                      // paradando o timer
                      _timerRelogio.cancel();
                      _timerAtualizacao.cancel();

                      setState(() {
                        voltarConfig = true;
                      });

                      // novo valor do prefs telaConfigurada
                      prefs.setBool('telaConfigurada', false);
                      // volto para tela de configuracao
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ConfiguracoesScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25.0),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Finalizar',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TempoAtualizacao extends StatelessWidget {
  const TempoAtualizacao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController tempoController = TextEditingController();

    prefs.getString('tempoAtualizacao') != null
        ? tempoController.text = prefs.getString('tempoAtualizacao')!
        : tempoController.text = "";

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                onTap: () {
                  _timerAtualizacao.cancel();
                  _timerRelogio.cancel();
                  print('hello');
                },
                decoration: const InputDecoration(
                  labelText: 'Tempo de atualização',
                  hintText: 'Em segundos',
                ),
                controller: tempoController,
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, escolha um tempo';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      prefs.setString('tempoAtualizacao', tempoController.text);
                      tempoDePaginacao();
                      Navigator.pop(context);
                      RestartWidget.restartApp(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25.0),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Finalizar',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
