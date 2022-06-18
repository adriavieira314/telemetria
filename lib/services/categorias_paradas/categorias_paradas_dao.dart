import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/categorias_paradas.dart';
import 'package:telemetria/utils/constants.dart';

class CategoriasParadasDao {
  Future<CategoriasParadas> getCategorias() async {
    final response = await http.get(
      Uri.parse(
        '$serverURL/idw/rest/injet/monitorizacao/pam/telemetria/categoriasparadas',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('response.body telemetria');
      // print(response.body);

      return CategoriasParadas.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('error ao receber telemetria');
      print(response.body);
      throw Exception('Erro ao receber dados da Telemetria. ${response.body}');
    }
  }
}
