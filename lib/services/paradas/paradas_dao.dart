import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/paradas.dart';
import 'package:telemetria/utils/constants.dart';

class ParadasListDao {
  Future<ParadasList> getParadasList() async {
    final response = await http.get(
      Uri.parse(
        '$serverURl/idw/rest/injet/monitorizacao/pam/telemetria/paradas',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('response.body telemetria');
      // print(response.body);

      return ParadasList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('error ao receber telemetria');
      print(response.body);
      throw Exception('Erro ao receber dados da Telemetria. ${response.body}');
    }
  }
}
