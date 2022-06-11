import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:telemetria/models/telemetria.dart';

class TelemetriaDao {
  Future<Telemetria> getTelemetria() async {
    final response = await http.get(
      Uri.parse(
        'http://localhost:8080/idw/rest/injet/monitorizacao/pam/telemetria',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      print('response.body telemetria');
      // print(response.body);

      return Telemetria.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('error ao receber telemetria');
      print(response.body);
      throw Exception('Erro ao receber dados da Telemetria. ${response.body}');
    }
  }
}
