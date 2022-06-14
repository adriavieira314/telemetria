import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/setores.dart';
import 'package:telemetria/utils/constants.dart';

class SetoresDao {
  Future<SetoresList> getSetoresList() async {
    final response = await http.get(
      Uri.parse(
        '$serverURl/idw/rest/injet/monitorizacao/pam/telemetria/setores',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('response.body setores');
      // print(response.body);

      return SetoresList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('error ao receber setores');
      print(response.body);
      throw Exception('Erro ao receber dados da Setores. ${response.body}');
    }
  }
}
