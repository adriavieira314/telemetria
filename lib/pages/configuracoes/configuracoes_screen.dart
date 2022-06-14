import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:telemetria/models/categorias_paradas.dart';
import 'package:telemetria/models/paradas.dart';
import 'package:telemetria/models/setores.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
import 'package:telemetria/pages/configuracoes/configuracoes_screen_text.dart';
import 'package:telemetria/services/categorias_paradas/categorias_paradas_dao.dart';
import 'package:telemetria/services/paradas/paradas_dao.dart';
import 'package:telemetria/services/setoresDao/setores_dao.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  List selectedList = [];
  List<SetoresDisponiveis> listOfSetores = [];
  List<Categorias> listOfCategorias = [];
  List<Paradas> listOfParadas = [];
  bool loadDropdown = false;
  String _configuracao = 'tempo';
  late Categorias dropdownValue;
  bool isChecked = false;

  final TextEditingController _tempoBranco = TextEditingController();
  final TextEditingController _tempoAmarelo = TextEditingController();
  final TextEditingController _tempoVermelho = TextEditingController();
  final TextEditingController _refugoBranco = TextEditingController();
  final TextEditingController _refugoAmarelo = TextEditingController();
  final TextEditingController _refugoVermelho = TextEditingController();
  final TextEditingController _refugoProducao = TextEditingController();

  final SetoresDao _daoSetores = SetoresDao();
  final CategoriasParadasDao _categoriasParadasDao = CategoriasParadasDao();
  final ParadasListDao _paradasListDao = ParadasListDao();
  List<Paradas> paradasTipo0 = [];
  List<Paradas> paradasTipo1 = [];
  List<Paradas> paradasTipo2 = [];
  List<Paradas> paradasTipo3 = [];
  List<Paradas> paradasTipo4 = [];
  List<Paradas> paradasTipo5 = [];
  List<Paradas> paradasTipo6 = [];
  List<Paradas> paradasTipo7 = [];

  @override
  void initState() {
    super.initState();
    _daoSetores.getSetoresList().then((value) {
      listOfSetores.addAll(value.setores!);
      print(listOfSetores);
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
          setState(() {
            paradas.check = true;
          });
        } else {
          paradas.check = false;
        }

        if (paradas.tipoPar == 0) {
          paradasTipo0.add(paradas);
        } else if (paradas.tipoPar == 1) {
          paradasTipo1.add(paradas);
        } else if (paradas.tipoPar == 2) {
          paradasTipo2.add(paradas);
        } else if (paradas.tipoPar == 3) {
          paradasTipo3.add(paradas);
        } else if (paradas.tipoPar == 4) {
          paradasTipo4.add(paradas);
        } else if (paradas.tipoPar == 5) {
          paradasTipo5.add(paradas);
        } else if (paradas.tipoPar == 6) {
          paradasTipo6.add(paradas);
        } else if (paradas.tipoPar == 7) {
          paradasTipo7.add(paradas);
        }
      }
      listOfParadas.addAll(paradasTipo1);
      listOfParadas.addAll(paradasTipo0);
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
                              const Text('Selecione o setor:'),
                              CustomSearchableDropDown(
                                items: listOfSetores,
                                label: 'Selecione os setores',
                                multiSelectTag: 'Setores',
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                ),
                                multiSelect: true,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(Icons.search),
                                ),
                                dropDownMenuItems: listOfSetores.map((item) {
                                  return item.dsSetor;
                                }).toList(),
                                onChanged: (value) {
                                  print(value);
                                  if (value != null) {
                                    selectedList = jsonDecode(value);
                                  } else {
                                    selectedList.clear();
                                  }
                                },
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
                      Column(
                        children: [
                          const Text(
                            'Configuração do Tipo\nde Parada',
                            style: TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            color: const Color.fromARGB(255, 231, 229, 229),
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
                                            print(dropdownValue.idCatPar);
                                            // *preencho a listOfParadas com as paradas de cada categoria
                                            // *e tambem preencho com as paradas do id 0
                                            listOfParadas.clear();
                                            if (dropdownValue.idCatPar == 1) {
                                              listOfParadas
                                                  .addAll(paradasTipo1);
                                            } else if (dropdownValue.idCatPar ==
                                                2) {
                                              listOfParadas
                                                  .addAll(paradasTipo2);
                                            } else if (dropdownValue.idCatPar ==
                                                3) {
                                              listOfParadas
                                                  .addAll(paradasTipo3);
                                            } else if (dropdownValue.idCatPar ==
                                                4) {
                                              listOfParadas
                                                  .addAll(paradasTipo4);
                                            } else if (dropdownValue.idCatPar ==
                                                5) {
                                              listOfParadas
                                                  .addAll(paradasTipo5);
                                            } else if (dropdownValue.idCatPar ==
                                                6) {
                                              listOfParadas
                                                  .addAll(paradasTipo6);
                                            } else if (dropdownValue.idCatPar ==
                                                7) {
                                              listOfParadas
                                                  .addAll(paradasTipo7);
                                            }
                                            // *preenchendo com as paradas id 0
                                            listOfParadas.addAll(paradasTipo0);
                                          });
                                        },
                                        items: listOfCategorias
                                            .map<DropdownMenuItem<Categorias>>(
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
                                          _displayDialog(context),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        labelText: 'Paradas',
                                        labelStyle:
                                            TextStyle(color: Colors.black),
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
                      ),
                      // Visibility(
                      //   visible: _configuracao == 'tempo',
                      //   child: ConfiguracaoTempoParada(
                      //     tempoBranco: _tempoBranco,
                      //     tempoAmarelo: _tempoAmarelo,
                      //     tempoVermelho: _tempoVermelho,
                      //   ),
                      // ),
                      // Visibility(
                      //   visible: _configuracao == 'refugo',
                      //   child: ConfiguracaoPecasRefugadas(
                      //     refugoBranco: _refugoBranco,
                      //     refugoAmarelo: _refugoAmarelo,
                      //     refugoVermelho: _refugoVermelho,
                      //     refugoProducao: _refugoProducao,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            print(paradasTipo0);
                            print(paradasTipo1);
                            print(paradasTipo2);
                            print(paradasTipo3);
                            print(paradasTipo4);
                            print(paradasTipo5);
                            print(paradasTipo6);
                            print(paradasTipo7);
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

  _displayDialog(BuildContext context) {
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
                return Container(
                  height: 50,
                  child: ListTile(
                    leading: Checkbox(
                      checkColor: Colors.white,
                      value: listOfParadas[index].check,
                      onChanged: (bool? value) {
                        setState(() {
                          listOfParadas[index].check = value!;
                        });
                      },
                    ),
                    title: Text(listOfParadas[index].dsParada!),
                  ),
                );
              }),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      );
    });
  }
}

class ConfiguracaoTempoParada extends StatelessWidget {
  final TextEditingController tempoBranco;
  final TextEditingController tempoAmarelo;
  final TextEditingController tempoVermelho;

  const ConfiguracaoTempoParada({
    Key? key,
    required this.tempoBranco,
    required this.tempoAmarelo,
    required this.tempoVermelho,
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
          color: const Color.fromARGB(255, 231, 229, 229),
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
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: CustomTextFormField(
                  label: 'Amarelo',
                  controller: tempoAmarelo,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CustomTextFormField(
                  label: 'Vermelho',
                  controller: tempoVermelho,
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
  final TextEditingController refugoVermelho;
  final TextEditingController refugoProducao;

  const ConfiguracaoPecasRefugadas({
    Key? key,
    required this.refugoBranco,
    required this.refugoAmarelo,
    required this.refugoVermelho,
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
          color: const Color.fromARGB(255, 231, 229, 229),
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
                padding:
                    const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                child: CustomTextFormField(
                  label: 'Vermelho',
                  controller: refugoVermelho,
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
