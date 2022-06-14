import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:telemetria/models/categorias_paradas.dart';
import 'package:telemetria/models/setores.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
import 'package:telemetria/pages/configuracoes/configuracoes_screen_text.dart';
import 'package:telemetria/services/categorias_paradas/categorias_paradas_dao.dart';
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
  bool loadDropdown = false;
  String _configuracao = 'tempo';
  late Categorias dropdownValue;

  final TextEditingController _tempoBranco = TextEditingController();
  final TextEditingController _tempoAmarelo = TextEditingController();
  final TextEditingController _tempoVermelho = TextEditingController();
  final TextEditingController _refugoBranco = TextEditingController();
  final TextEditingController _refugoAmarelo = TextEditingController();
  final TextEditingController _refugoVermelho = TextEditingController();
  final TextEditingController _refugoProducao = TextEditingController();

  final SetoresDao _daoSetores = SetoresDao();
  final CategoriasParadasDao _categoriasParadasDao = CategoriasParadasDao();

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
                                    border: Border.all(color: Colors.blue)),
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
                                            print(dropdownValue);
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
                                  child: CustomTextFormField(
                                    label: 'Amarelo',
                                    controller: _tempoAmarelo,
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
                            print(_tempoBranco.text);
                            print(_tempoAmarelo.text);
                            print(_tempoVermelho.text);
                            print(_refugoBranco.text);
                            print(_refugoAmarelo.text);
                            print(_refugoVermelho.text);
                            print(_refugoProducao.text);
                            print(selectedList);
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
