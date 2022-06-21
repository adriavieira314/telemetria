import 'package:flutter/material.dart';
import 'package:telemetria/main.dart';
import 'package:telemetria/models/categorias_paradas.dart';
import 'package:telemetria/models/configuracoes.dart';
import 'package:telemetria/models/paradas.dart';
import 'package:telemetria/models/setores.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
import 'package:telemetria/pages/configuracoes/configuracoes_screen_text.dart';
import 'package:telemetria/services/categorias_paradas/categorias_paradas_dao.dart';
import 'package:telemetria/services/configuracoes/configuracoes_dao.dart';
import 'package:telemetria/services/configuracoes_salvas/configuracoes_salvas_dao.dart';
import 'package:telemetria/services/paradas/paradas_dao.dart';
import 'package:telemetria/services/setoresDao/setores_dao.dart';
import 'package:telemetria/utils/constants.dart';

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
  bool loadingPage = false;
  String _configuracao = 'tempo';
  late Categorias dropdownValue;
  bool isChecked = false;
  int idCategoriaParada = 1;
  bool showGraph = false;
  bool erroNaChamada = false;
  String qtdSetoresSelecionados = '';
  bool isResponseLoading = false;

  final TextEditingController _tempoBranco = TextEditingController();
  final TextEditingController _tempoAmarelo = TextEditingController();
  final TextEditingController _refugoBranco = TextEditingController();
  final TextEditingController _refugoAmarelo = TextEditingController();
  final TextEditingController _refugoProducao = TextEditingController();

  TextEditingController searchSetoresController = TextEditingController();
  TextEditingController searchParadasController = TextEditingController();

  final SetoresDao _daoSetores = SetoresDao();
  final CategoriasParadasDao _categoriasParadasDao = CategoriasParadasDao();
  final ParadasListDao _paradasListDao = ParadasListDao();
  final ConfiguracoesDao _configuracoesDao = ConfiguracoesDao();
  final ConfiguracoesSalvasDao _configuracoesSalvasDao =
      ConfiguracoesSalvasDao();

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

  void getCategoriasParadas() {
    _categoriasParadasDao.getCategorias().then((value) {
      listOfCategorias.addAll(value.categorias!);
      dropdownValue = value.categorias![0];
      print(listOfCategorias);
    });
  }

  void getParadasList() {
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

      if (mounted) {
        setState(() {
          loadingPage = true;
          erroNaChamada = false;
        });
      }
    });
  }

  void getSetoresNaoSelecionados() {
    _daoSetores.getSetoresList().then((value) {
      // *adicionando a array listOfSetores os setores não selecionados
      for (var setor in value.setores!) {
        if (listOfSetores.every((item) => item.cdSetor != setor.cdSetor)) {
          setor.check = false;
          listOfSetores.add(setor);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _configuracoesSalvasDao.getConfiguracoes().then((value) {
      selectedListOfSetores.clear();
      // *adicionando a array listOfSetores os setores selecionados
      for (var setor in value.setoreSelecionados!) {
        setor.check = true;
        listOfSetores.add(setor);
        selectedListOfSetores.add(
          SetoreSelecionados(cdSetor: setor.cdSetor),
        );
      }

      if (mounted) {
        setState(() {
          // *setando o valor inicial
          _tempoBranco.text = value.paradaTempoLimiteBranco.toString();
          _tempoAmarelo.text = value.paradaTempoLimiteAmarelo.toString();
          _refugoBranco.text = value.refugoVlrLimiteBranco.toString();
          _refugoAmarelo.text = value.refugoVlrLimiteAmarelo.toString();
          _refugoProducao.text = value.refugoProdReferencia.toString();
          qtdSetoresSelecionados = selectedListOfSetores.length.toString();
        });
      }

      getCategoriasParadas();
      getSetoresNaoSelecionados();
      // getParadasList() deve ser ultimo a ser chamado pois coloquei o loadingPage e o erroNaChamada nele
      // essas duas variaveis devem mudar quando a ultima chamada rest foi finalizada
      getParadasList();
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          loadingPage = false;
          erroNaChamada = true;
        });
        mensagemErro = onError;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AppBarText(text: ConfiguracoesScreenText.titulo),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Material(
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: InkWell(
                onTap: (() => RestartWidget.restartApp(context)),
                child: const Icon(
                  Icons.refresh,
                  size: 30.0,
                ),
              ),
            ),
          ),
          erroNaChamada
              ? Padding(
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
                                  'Configuração',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Configuracao(),
                              ),
                            ),
                          )
                        },
                        child: Text(
                          'Configuração',
                          style: TextStyle(
                              color:
                                  erroNaChamada ? Colors.black : Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
      body: erroNaChamada
          ? const MensagemErro()
          : loadingPage
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
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _displaySetoresDialog(context),
                                    ).then(
                                      (value) => {
                                        setState(() {
                                          qtdSetoresSelecionados =
                                              selectedListOfSetores.length
                                                  .toString();

                                          searchSetoresController.text = "";
                                        })
                                      },
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        disabledBorder:
                                            const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        labelText:
                                            '$qtdSetoresSelecionados setores selecionados',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? portraitView()
                                : landscapeView(),
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
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 25.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  isResponseLoading = true;
                                });

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

                                _configuracoesDao
                                    .saveConfiguracoes(configuracoesJson)
                                    .then((value) {
                                  print('sucesso');
                                  print(value);
                                  setState(() {
                                    isResponseLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color(0xFF198754),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 25.0),
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                        'Sucesso ao configurar a Telemetria!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }).catchError((onError) {
                                  setState(() {
                                    isResponseLoading = false;
                                  });

                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Alerta',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: ErroSaveConfiguracao(
                                          errorMessage: onError,
                                        ),
                                      ),
                                    ),
                                  );
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
                              child: isResponseLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
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

  Row landscapeView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _configuracao = 'tempo';
            });
          },
          child: radioListTile('Tempo de Parada', 'tempo'),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _configuracao = 'refugo';
            });
          },
          child: radioListTile('Peças Refugadas', 'refugo'),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _configuracao = 'tipo';
            });
          },
          child: radioListTile('Tipo de Parada', 'tipo'),
        ),
      ],
    );
  }

  Column portraitView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _configuracao = 'tempo';
            });
          },
          child: radioListTile('Tempo de Parada', 'tempo'),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _configuracao = 'refugo';
            });
          },
          child: radioListTile('Peças Refugadas', 'refugo'),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _configuracao = 'tipo';
            });
          },
          child: radioListTile('Tipo de Parada', 'tipo'),
        ),
      ],
    );
  }

  Column configuracaoTipoParada(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Configuração do Tipo de Parada',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
                          child: Text(
                            value.dsCatPar!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                  ).then(
                    (value) => {
                      setState(() {
                        searchParadasController.text = "";
                      })
                    },
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      labelText: 'Paradas',
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
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

  SizedBox radioListTile(String title, String value) {
    return SizedBox(
      width: 300,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
      ),
    );
  }

  _displayParadasDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Paradas',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, 'Finalizar');
              },
              icon: const Icon(
                Icons.cancel_outlined,
                size: 30.0,
              ),
            )
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              children: [
                SizedBox(
                  child: searchInput(searchParadasController, setState),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: listOfParadas.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (searchParadasController.text.isEmpty) {
                      return listTileParadas(setState, index);
                    } else if (listOfParadas[index]
                        .dsParada!
                        .toLowerCase()
                        .contains(searchParadasController.text.toLowerCase())) {
                      return listTileParadas(setState, index);
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
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
                Navigator.pop(context, 'Finalizar');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 50.0),
              ),
              child: const Text(
                'Finalizar',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ),
        ],
      );
    });
  }

  SizedBox listTileParadas(StateSetter setState, int index) {
    return SizedBox(
      height: 50,
      child: ListTile(
        onTap: () {
          setState(() {
            listOfParadas[index].check = !listOfParadas[index].check!;
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
        title: Text(
          listOfParadas[index].dsParada!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _displaySetoresDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Setores',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context, 'Finalizar');
              },
              icon: const Icon(
                Icons.cancel_outlined,
                size: 30.0,
              ),
            )
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              children: [
                SizedBox(
                  child: searchInput(searchSetoresController, setState),
                ),
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: listOfSetores.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (searchSetoresController.text.isEmpty) {
                      return listTileSetores(setState, index);
                    } else if (listOfSetores[index]
                        .dsSetor!
                        .toLowerCase()
                        .contains(searchSetoresController.text.toLowerCase())) {
                      return listTileSetores(setState, index);
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
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

                Navigator.pop(context, 'Finalizar');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 50.0),
              ),
              child: const Text(
                'Finalizar',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ),
        ],
      );
    });
  }

  SizedBox listTileSetores(StateSetter setState, int index) {
    return SizedBox(
      height: 50,
      child: ListTile(
        onTap: () {
          setState(() {
            listOfSetores[index].check = !listOfSetores[index].check!;
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
        title: Text(
          listOfSetores[index].dsSetor!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
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

  SizedBox searchInput(TextEditingController controller, setState) {
    return SizedBox(
      height: 65.0,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        child: TextField(
          onChanged: (value) {
            setState(() {});
          },
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(30),
            ),

            filled: true,
            fillColor: Colors.white,
            labelText: "Pesquisa",
            // hintText: "Filtrar por nome, função ou setor",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: InkWell(
              onTap: () {
                controller.text = '';
                setState(() {});
              },
              child: const Icon(Icons.close_outlined),
            ),
          ),
        ),
      ),
    );
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
          'Configuração do Tempo de Parada',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
                  label: 'Branco (em segundos)',
                  controller: tempoBranco,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30.0, bottom: 30.0),
                child: CustomTextFormField(
                  label: 'Amarelo (em segundos)',
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
          'Configuração de Peças Refugadas',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
                  label: 'Branco (em segundos)',
                  controller: refugoBranco,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: CustomTextFormField(
                  label: 'Amarelo (em segundos)',
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
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        labelText: label,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: 'Em segundos',
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
    );
  }
}

class MensagemErro extends StatelessWidget {
  const MensagemErro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '${mensagemErro.toString()}.  Link servidor: $serverURL',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              const Text(
                'Vá para menu para alterar o servidor',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Configuracao extends StatelessWidget {
  const Configuracao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController serverController = TextEditingController();
    final TextEditingController portController = TextEditingController();

    prefs.getString('server') != null
        ? serverController.text = prefs.getString('server')!
        : serverController.text = "";

    prefs.getString('port') != null
        ? portController.text = prefs.getString('port')!
        : portController.text = "";

    return SingleChildScrollView(
      child: SizedBox(
        height: 250.0,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Servidor',
                ),
                controller: serverController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o servidor';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    labelText: 'Porta',
                  ),
                  controller: portController,
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a porta';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      prefs.setString('server', serverController.text);
                      prefs.setString('port', portController.text);
                      getServer();
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

class CustomTextWidget extends StatelessWidget {
  final String texto;
  const CustomTextWidget({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: FittedBox(
        child: Text(
          texto,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ErroSaveConfiguracao extends StatelessWidget {
  final Exception errorMessage;
  const ErroSaveConfiguracao({Key? key, required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 250.0,
        // width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              errorMessage.toString(),
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                  elevation: 5,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
