import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/configuracoes.dart';
import 'package:telemetria/utils/constants.dart';

class ConfiguracoesDao {
  Future<http.Response> saveConfiguracoes(Configuracoes jsonBody) async {
    final response = await http.post(
      Uri.parse(
        '$serverURl/idw/rest/injet/monitorizacao/pam/telemetria/configuracoes/salvar',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonBody),
    );

    if (response.statusCode == 200) {
      print('response.body configuracoes');
      print(response.body);

      return response;
    } else {
      print('error ao enviar configuracoes');
      print(response.body);
      throw Exception('Erro ao enviar dados de configuração. ${response.body}');
    }
  }
}
