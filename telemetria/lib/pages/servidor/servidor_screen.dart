import 'package:flutter/material.dart';
import 'package:telemetria/main.dart';
import 'package:telemetria/pages/components/appbar_text.dart';
import 'package:telemetria/pages/telemetria/telemetria_screen.dart';
import 'package:telemetria/utils/constants.dart';

class ServidorScreen extends StatefulWidget {
  const ServidorScreen({Key? key}) : super(key: key);

  @override
  State<ServidorScreen> createState() => _ServidorScreenState();
}

class _ServidorScreenState extends State<ServidorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController serverController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController maquinasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AppBarText(text: 'TELEMETRIA'),
          ],
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            controller: serverController,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 15),
                            decoration: const InputDecoration(
                              labelText: "Servidor",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: portController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 15),
                            decoration: const InputDecoration(
                              labelText: "Porta",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório.';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () => {
                              if (_formKey.currentState!.validate())
                                {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Confirme as informações abaixo',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: conteudoAlerta(),
                                    ),
                                  ),
                                }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 25.0, horizontal: 30.0),
                              elevation: 5,
                            ),
                            child: const Text(
                              "Enviar",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  conteudoAlerta() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Servidor: ',
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                  children: [
                    TextSpan(
                      text: serverController.text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Porta: ',
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                  children: [
                    TextSpan(
                      text: portController.text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                  elevation: 5,
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  prefs.setString('server', serverController.text);
                  prefs.setString('port', portController.text);

                  getServer();
                  // navega para pagina
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TelemetriaScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 25.0),
                  elevation: 5,
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
