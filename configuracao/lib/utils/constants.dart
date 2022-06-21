import 'package:shared_preferences/shared_preferences.dart';

String serverURL = '';
Exception mensagemErro = Exception();
int tempoDeEspera = 30;
int atualizacaoTempo = 15;

void getServer() async {
  final prefs = await SharedPreferences.getInstance();
  String? server;
  String? port;

  if (prefs.getString('server') == null) {
    server = "";
    port = "";
  } else {
    server = prefs.getString('server');
    port = prefs.getString('port');
    server = server!.trim();
    port = port!.trim();
    serverURL = "http://$server:$port";
  }
}

void tempoDePaginacao() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getString('tempoAtualizacao') == null) {
    atualizacaoTempo = 15;
  } else {
    atualizacaoTempo = int.parse(prefs.getString('tempoAtualizacao')!);
  }
}
