import 'package:http/http.dart' as http;
import 'dart:convert';

class FormRepository {
  final String baseUrl = ""; //colocar la ruta del serivio de Angel
  
  Future<String> enviarDatos(String nombre, String email) async{
    final url = Uri.parse("$baseUrl/api/enviar");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nombre": nombre, "email": email}),
    );


    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data["mensaje"];
    }else{
      throw Exception("Error: ${response.statusCode}");
    }
  }
}