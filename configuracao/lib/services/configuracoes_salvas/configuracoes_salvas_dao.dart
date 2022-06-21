import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/configuracoes_salvas.dart';
import 'package:telemetria/utils/constants.dart';

class ConfiguracoesSalvasDao {
  Future<ConfiguracoesSalvas> getConfiguracoes() async {
    final response = await http.get(
      Uri.parse(
        '$serverURL/idw/rest/injet/monitorizacao/pam/telemetria/configuracoes',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).timeout(
      Duration(seconds: tempoDeEspera),
      onTimeout: () {
        return http.Response(
          'Tempo de espera de resposta da URL excedeu',
          408,
        ); // Request Timeout response status code
      },
    );

    if (response.statusCode == 200) {
      print('response.body configuracoes salvas');
      // print(response.body);

      return ConfiguracoesSalvas.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('error ao enviar configuracoes salvas');
      print(response.body);
      throw Exception(
          'Erro ao buscar os dados de configurações salvas. ${response.body}');
    }
  }
}
