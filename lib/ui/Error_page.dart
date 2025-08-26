import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'form_page.dart'; // importa tu formulario

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Fondo oscuro elegante
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1C1C1E), // gris oscuro elegante
                  Color(0xFF2A2A2D), // intermedio
                  Color(0xFF3A3A3D), // más claro para resaltar
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ❌ Contenido principal
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔴 Texto principal de error
                  Text(
                    "¡Error al guardar datos!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 30),

                  // ❌ Animación de error
                  Lottie.asset(
                    'lib/ui/animation/error.json',
                    width: isSmallScreen ? size.width * 0.5 : 280,
                    height: isSmallScreen ? size.width * 0.5 : 280,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isSmallScreen ? 30 : 50),

                  // 📋 Texto informativo
                  Text(
                    "Verifique los datos y vuelva a intentarlo.\n"
                        "Si el error persiste comuníquese con\n"
                        "el balcón de servicios 📞 300 123 4567",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 22,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 40 : 60),

                  // 📝 Botón reintentar
                  SizedBox(
                    width: isSmallScreen ? double.infinity : null,
                    child: ElevatedButton.icon(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 20 : 36,
                          vertical: isSmallScreen ? 14 : 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 12,
                      ),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        "Intentar nuevamente",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
