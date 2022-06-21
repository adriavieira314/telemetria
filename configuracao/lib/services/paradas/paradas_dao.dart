import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/paradas.dart';
import 'package:telemetria/utils/constants.dart';

class ParadasListDao {
  Future<ParadasList> getParadasList() async {
    final response = await http.get(
      Uri.parse(
        '$serverURL/idw/rest/injet/monitorizacao/pam/telemetria/paradas',
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
      print('response.body ParadasList');
      // print(response.body);

      return ParadasList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('error ao receber ParadasList');
      print(response.body);
      throw Exception('Erro ao receber dados da ParadasList. ${response.body}');
    }
  }
}
