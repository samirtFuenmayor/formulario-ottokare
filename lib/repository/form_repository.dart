import 'package:http/http.dart' as http;
import 'dart:convert';



class FormRepository {
  final String baseUrl = "https://ottocare-api-container-abhtfcg3akhmhrbx.chilecentral-01.azurewebsites.net";

  Future<Map<String, dynamic>> enviarDatos({
    required String nombre,
    required String apellido,
    required String cedula,
    required String celular,
    required String email,
    required String ciudad,
    required String contractId,
    required List<Map<String, dynamic>> mascotas,
  }) async {
    final url = Uri.parse("$baseUrl/clients/");

    // Construir JSON dinámico
    final jsonData = {
      "first_name": nombre.split(" ").first,
      "last_name": apellido,
      "identification": cedula,
      "phone_number": celular,
      "email": email,
      "address": {
        "home_address": ciudad,
        "postal_code": "1122" // si quieres dinámico, agregar campo ciudad
      },
      "contract_id" :contractId,
      "pets": mascotas.map((pet) {
        return {
          "first_name": pet['nombre'],
          "gender": {"gender": pet['gender'] ?? "M"},
          "client_type": {
            "name": pet['species'] ?? "dog",
            "breed": {"name": pet['raza'] ?? ""},
            "color": pet['color'] ?? "",
            "physical_defect": pet['defect'] ?? "La mascota no tiene defectos",
          },
          "birth_date": pet['birth_date'] != null
              ? (pet['birth_date'] is DateTime
                  ? (pet['birth_date'] as DateTime).toIso8601String()
                  : pet['birth_date'])
              : null,
          "identification": pet['carnet'] ?? "",
          "image_base64": pet['image_base64'] ?? "",
        };
      }).toList(),
    };


    try {
      print("Datos que se enviarán: inicioPST");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Datos que se enviarán: final post");
        return data;
      } else {
        throw Exception("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al enviar datos: $e");
    }
  }
  }



