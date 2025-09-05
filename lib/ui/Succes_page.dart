import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatelessWidget {
  final String imageBase64;

  const SuccessPage({super.key, required this.imageBase64});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Convertir Base64 a bytes de forma segura
    Uint8List? imageBytes;
    if (imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageBase64);
      } catch (e) {
        imageBytes = null;
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Confeti animado de fondo
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                'lib/ui/animation/Confetti.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          // Imagen central adaptativa
          Center(
            child: imageBytes != null
                ? ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                widthFactor: 0.91,  // recorta un 20% a lo ancho (10% a cada lado)
                heightFactor: 0.93, // recorta un 15% en altura (abajo)
                child: Image.memory(imageBytes),
              ),
            )
                : const Text(
              "Imagen inválida",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
