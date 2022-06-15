import 'package:flutter/material.dart';
import 'package:telemetria/models/categorias_paradas.dart';
import 'package:telemetria/models/configuracoes.dart';
import 'package:telemetria/models/paradas.dart';
import 'package:telemetria/models/setores.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
import 'package:telemetria/pages/configuracoes/configuracoes_screen_text.dart';
import 'package:telemetria/services/categorias_paradas/categorias_paradas_dao.dart';
import 'package:telemetria/services/configuracoes/configuracoes_dao.dart';
import 'package:telemetria/services/paradas/paradas_dao.dart';
import 'package:telemetria/services/setoresDao/setores_dao.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  List<SetoreSelecionados> selectedListOfSetores = [];
  List<SetoresDisponiveis> listOfSetores = [];
  List<Categorias> listOfCategorias = [];
  List<Paradas> listOfParadas = [];
  bool loadDropdown = false;
  String _configuracao = 'tempo';
  late Categorias dropdownValue;
  bool isChecked = false;
  int idCategoriaParada = 1;

  final TextEditingController _tempoBranco = TextEditingController();
  final TextEditingController _tempoAmarelo = TextEditingController();
  final TextEditingController _refugoBranco = TextEditingController();
  final TextEditingController _refugoAmarelo = TextEditingController();
  final TextEditingController _refugoProducao = TextEditingController();

  final SetoresDao _daoSetores = SetoresDao();
  final CategoriasParadasDao _categoriasParadasDao = CategoriasParadasDao();
  final ParadasListDao _paradasListDao = ParadasListDao();
  final ConfiguracoesDao _configuracoesDao = ConfiguracoesDao();

  List<Paradas> paradasTipo0 = [];
  List<Paradas> paradasTipo1 = [];
  List<Paradas> paradasTipo2 = [];
  List<Paradas> paradasTipo3 = [];
  List<Paradas> paradasTipo4 = [];
  List<Paradas> paradasTipo5 = [];
  List<Paradas> paradasTipo6 = [];
  List<Paradas> paradasTipo7 = [];

  List<String> parCodTipo0 = [];
  List<String> parCodTipo1 = [];
  List<String> parCodTipo2 = [];
  List<String> parCodTipo3 = [];
  List<String> parCodTipo4 = [];
  List<String> parCodTipo5 = [];
  List<String> parCodTipo6 = [];
  List<String> parCodTipo7 = [];

  late ParadasPorCategoria objParTipo0;
  late ParadasPorCategoria objParTipo1;
  late ParadasPorCategoria objParTipo2;
  late ParadasPorCategoria objParTipo3;
  late ParadasPorCategoria objParTipo4;
  late ParadasPorCategoria objParTipo5;
  late ParadasPorCategoria objParTipo6;
  late ParadasPorCategoria objParTipo7;

  @override
  void initState() {
    super.initState();
    _daoSetores.getSetoresList().then((value) {
      for (var setor in value.setores!) {
        setor.check = false;
        listOfSetores.add(setor);
      }
      setState(() {
        loadDropdown = true;
      });
    });

    _categoriasParadasDao.getCategorias().then((value) {
      listOfCategorias.addAll(value.categorias!);
      dropdownValue = value.categorias![0];
      print(listOfCategorias);
    });

    _paradasListDao.getParadasList().then((value) {
      for (var paradas in value.paradas!) {
        // todas as paradas recebem um check true para dizer quais estao marcadas na lista
        if (paradas.tipoPar != 0) {
          paradas.check = true;
        } else {
          paradas.check = false;
        }

        if (paradas.tipoPar == 0) {
          paradasTipo0.add(paradas);
          parCodTipo0.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 1) {
          paradasTipo1.add(paradas);
          parCodTipo1.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 2) {
          paradasTipo2.add(paradas);
          parCodTipo2.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 3) {
          paradasTipo3.add(paradas);
          parCodTipo3.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 4) {
          paradasTipo4.add(paradas);
          parCodTipo4.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 5) {
          paradasTipo5.add(paradas);
          parCodTipo5.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 6) {
          paradasTipo6.add(paradas);
          parCodTipo6.add(paradas.cdParada!);
        } else if (paradas.tipoPar == 7) {
          paradasTipo7.add(paradas);
          parCodTipo7.add(paradas.cdParada!);
        }
      }
      listOfParadas.addAll(paradasTipo1);
      listOfParadas.addAll(paradasTipo0);

      paradasPorCategoriaObjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AppBarText(text: ConfiguracoesScreenText.empresa),
            // AppBarText(text: ConfiguracoesScreenText.titulo),
            // AppBarText(text: ConfiguracoesScreenText.logo),
          ],
        ),
      ),
      body: loadDropdown
          ? CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 15.0,
                                ),
                                child: Text(
                                  'Selecione o setor:',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              InkWell(
                                onTap: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _displaySetoresDialog(context),
                                ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Selecionar setores',
                                    labelStyle: TextStyle(color: Colors.black),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  readOnly: true,
                                  enabled: false,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          radioListTile('Tempo de Parada', 'tempo'),
                          radioListTile('Tipo de Parada', 'tipo'),
                          radioListTile('Peças Refugadas', 'refugo'),
                        ],
                      ),
                      Visibility(
                        visible: _configuracao == 'tempo',
                        child: ConfiguracaoTempoParada(
                          tempoBranco: _tempoBranco,
                          tempoAmarelo: _tempoAmarelo,
                        ),
                      ),
                      Visibility(
                        visible: _configuracao == 'tipo',
                        child: configuracaoTipoParada(context),
                      ),
                      Visibility(
                        visible: _configuracao == 'refugo',
                        child: ConfiguracaoPecasRefugadas(
                          refugoBranco: _refugoBranco,
                          refugoAmarelo: _refugoAmarelo,
                          refugoProducao: _refugoProducao,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // print(_tempoBranco.text.runtimeType);
                            // print(_tempoAmarelo.text.runtimeType);
                            // print(_tempoVermelho.text.runtimeType);
                            // print(_refugoBranco.text.runtimeType);
                            // print(_refugoAmarelo.text.runtimeType);
                            // print(_refugoVermelho.text.runtimeType);
                            // print(_refugoProducao.text.runtimeType);
                            // print(objParTipo7.paradas);
                            // print(selectedListOfSetores);
                            var configuracoesJson = Configuracoes(
                              setoreSelecionados: selectedListOfSetores,
                              paradasPorCategoria: [
                                objParTipo0,
                                objParTipo1,
                                objParTipo2,
                                objParTipo3,
                                objParTipo4,
                                objParTipo5,
                                objParTipo6,
                                objParTipo7,
                              ],
                              refugoProdReferencia:
                                  int.parse(_refugoProducao.text),
                              refugoVlrLimiteBranco:
                                  int.parse(_refugoBranco.text),
                              refugoVlrLimiteAmarelo:
                                  int.parse(_refugoAmarelo.text),
                              paradaTempoLimiteBranco:
                                  int.parse(_tempoBranco.text),
                              paradaTempoLimiteAmarelo:
                                  int.parse(_tempoAmarelo.text),
                            );

                            print(configuracoesJson);
                            _configuracoesDao
                                .saveConfiguracoes(configuracoesJson)
                                .then((value) {
                              print('sucesso');
                              print(value);
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 25.0, horizontal: 70.0),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Concluir',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Column configuracaoTipoParada(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Configuração do Tipo\nde Parada',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color.fromARGB(255, 231, 229, 229),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(5.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Categorias>(
                      value: dropdownValue,
                      onChanged: (Categorias? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          idCategoriaParada = dropdownValue.idCatPar!;
                          print('idCategoriaParada');
                          print(idCategoriaParada);
                          // *preencho a listOfParadas com as paradas de cada categoria
                          // *e tambem preencho com as paradas do id 0
                          listOfParadas.clear();
                          if (dropdownValue.idCatPar == 1) {
                            listOfParadas.addAll(paradasTipo1);
                          } else if (dropdownValue.idCatPar == 2) {
                            listOfParadas.addAll(paradasTipo2);
                          } else if (dropdownValue.idCatPar == 3) {
                            listOfParadas.addAll(paradasTipo3);
                          } else if (dropdownValue.idCatPar == 4) {
                            listOfParadas.addAll(paradasTipo4);
                          } else if (dropdownValue.idCatPar == 5) {
                            listOfParadas.addAll(paradasTipo5);
                          } else if (dropdownValue.idCatPar == 6) {
                            listOfParadas.addAll(paradasTipo6);
                          } else if (dropdownValue.idCatPar == 7) {
                            listOfParadas.addAll(paradasTipo7);
                          }
                          // *preenchendo com as paradas id 0
                          listOfParadas.addAll(paradasTipo0);
                        });
                      },
                      items: listOfCategorias.map<DropdownMenuItem<Categorias>>(
                          (Categorias value) {
                        return DropdownMenuItem<Categorias>(
                          value: value,
                          child: Text(value.dsCatPar!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 30.0),
                child: InkWell(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        _displayParadasDialog(context),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      labelText: 'Paradas',
                      labelStyle: TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    readOnly: true,
                    enabled: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  ListTile radioListTile(String title, String value) {
    return ListTile(
      title: Text(title),
      leading: Transform.scale(
        scale: 1.8,
        child: Radio(
          value: value,
          groupValue: _configuracao,
          onChanged: (String? value) {
            setState(() {
              _configuracao = value!;
            });
          },
        ),
      ),
    );
  }

  _displayParadasDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text('Paradas'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listOfParadas.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        listOfParadas[index].check =
                            !listOfParadas[index].check!;
                      });
                    },
                    leading: Transform.scale(
                      scale: 1.7,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: listOfParadas[index].check,
                        onChanged: (bool? value) {
                          setState(() {
                            listOfParadas[index].check = value!;
                          });
                        },
                      ),
                    ),
                    title: Text(listOfParadas[index].dsParada!),
                  ),
                );
              }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearArray();
              paradasTipo0.clear();
              parCodTipo0.clear();

              for (var paradas in listOfParadas) {
                if (paradas.check == false) {
                  setState(() {
                    paradasTipo0.add(paradas);
                    parCodTipo0.add(paradas.cdParada!);
                  });
                } else {
                  if (idCategoriaParada == 1) {
                    setState(() {
                      paradasTipo1.add(paradas);
                      parCodTipo1.add(paradas.cdParada!);
                    });
                  } else if (idCategoriaParada == 2) {
                    setState(() {
                      paradasTipo2.add(paradas);
                      parCodTipo2.add(paradas.cdParada!);
                    });
                  } else if (idCategoriaParada == 3) {
                    setState(() {
                      paradasTipo3.add(paradas);
                      parCodTipo3.add(paradas.cdParada!);
                    });
                  } else if (idCategoriaParada == 4) {
                    setState(() {
                      paradasTipo4.add(paradas);
                      parCodTipo4.add(paradas.cdParada!);
                    });
                  } else if (idCategoriaParada == 5) {
                    setState(() {
                      paradasTipo5.add(paradas);
                      parCodTipo5.add(paradas.cdParada!);
                    });
                  } else if (idCategoriaParada == 6) {
                    setState(() {
                      paradasTipo6.add(paradas);
                      parCodTipo6.add(paradas.cdParada!);
                    });
                  } else if (idCategoriaParada == 7) {
                    setState(() {
                      paradasTipo7.add(paradas);
                      parCodTipo7.add(paradas.cdParada!);
                    });
                  }
                }
              }
              paradasPorCategoriaObjects();
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      );
    });
  }

  _displaySetoresDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text(
          'Setores',
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: listOfSetores.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 50,
                  child: ListTile(
                    onTap: () {
                      setState(() {
                        listOfSetores[index].check =
                            !listOfSetores[index].check!;
                      });
                    },
                    leading: Transform.scale(
                      scale: 1.7,
                      child: Checkbox(
                        checkColor: Colors.white,
                        value: listOfSetores[index].check,
                        onChanged: (bool? value) {
                          setState(() {
                            listOfSetores[index].check = value!;
                          });
                        },
                      ),
                    ),
                    title: Text(listOfSetores[index].dsSetor!),
                  ),
                );
              }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              selectedListOfSetores.clear();

              for (var setor in listOfSetores) {
                if (setor.check == true) {
                  setState(() {
                    selectedListOfSetores.add(
                      SetoreSelecionados(cdSetor: setor.cdSetor),
                    );
                  });
                }
              }

              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      );
    });
  }

  clearArray() {
    if (idCategoriaParada == 1) {
      setState(() {
        paradasTipo1.clear();
        parCodTipo1.clear();
      });
    } else if (idCategoriaParada == 2) {
      setState(() {
        paradasTipo2.clear();
        parCodTipo2.clear();
      });
    } else if (idCategoriaParada == 3) {
      setState(() {
        paradasTipo3.clear();
        parCodTipo3.clear();
      });
    } else if (idCategoriaParada == 4) {
      setState(() {
        paradasTipo4.clear();
        parCodTipo4.clear();
      });
    } else if (idCategoriaParada == 5) {
      setState(() {
        paradasTipo5.clear();
        parCodTipo5.clear();
      });
    } else if (idCategoriaParada == 6) {
      setState(() {
        paradasTipo6.clear();
        parCodTipo6.clear();
      });
    } else if (idCategoriaParada == 7) {
      setState(() {
        paradasTipo7.clear();
        parCodTipo7.clear();
      });
    }
  }

  paradasPorCategoriaObjects() {
    objParTipo0 = ParadasPorCategoria(idCatPar: 0, paradas: parCodTipo0);
    objParTipo1 = ParadasPorCategoria(idCatPar: 1, paradas: parCodTipo1);
    objParTipo2 = ParadasPorCategoria(idCatPar: 2, paradas: parCodTipo2);
    objParTipo3 = ParadasPorCategoria(idCatPar: 3, paradas: parCodTipo3);
    objParTipo4 = ParadasPorCategoria(idCatPar: 4, paradas: parCodTipo4);
    objParTipo5 = ParadasPorCategoria(idCatPar: 5, paradas: parCodTipo5);
    objParTipo6 = ParadasPorCategoria(idCatPar: 6, paradas: parCodTipo6);
    objParTipo7 = ParadasPorCategoria(idCatPar: 7, paradas: parCodTipo7);
  }
}

class ConfiguracaoTempoParada extends StatelessWidget {
  final TextEditingController tempoBranco;
  final TextEditingController tempoAmarelo;

  const ConfiguracaoTempoParada({
    Key? key,
    required this.tempoBranco,
    required this.tempoAmarelo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Configuração do Tempo\nde Parada',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color.fromARGB(255, 231, 229, 229),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomTextFormField(
                  label: 'Branco',
                  controller: tempoBranco,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 30.0),
                child: CustomTextFormField(
                  label: 'Amarelo',
                  controller: tempoAmarelo,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ConfiguracaoPecasRefugadas extends StatelessWidget {
  final TextEditingController refugoBranco;
  final TextEditingController refugoAmarelo;
  final TextEditingController refugoProducao;

  const ConfiguracaoPecasRefugadas({
    Key? key,
    required this.refugoBranco,
    required this.refugoAmarelo,
    required this.refugoProducao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Configuração de Peças\nRefugadas',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: const Color.fromARGB(255, 231, 229, 229),
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomTextFormField(
                  label: 'Branco',
                  controller: refugoBranco,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: CustomTextFormField(
                  label: 'Amarelo',
                  controller: refugoAmarelo,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomTextFormField(
                  label: 'Produção',
                  controller: refugoProducao,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Em segundos',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
    );
  }
}
