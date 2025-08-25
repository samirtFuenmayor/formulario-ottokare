//
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'form_page.dart'; // importa tu formulario
//
// class SuccessPage extends StatelessWidget {
//   const SuccessPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Obtenemos el ancho y alto de la pantalla
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 600; // breakpoint simple
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 🎨 Fondo degradado
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF0F2027), // azul muy oscuro
//                   Color(0xFF203A43), // intermedio
//                   Color(0xFF2C5364), // más claro pero elegante
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           // 🎉 Confeti animado de fondo
//           Positioned.fill(
//             child: IgnorePointer(
//               child: Lottie.asset(
//                 'lib/ui/animation/Confetti.json',
//                 fit: BoxFit.cover,
//                 repeat: true,
//               ),
//             ),
//           ),
//
//           // 🐶🐱 Contenido principal
//           Center(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // 🎯 Texto principal
//                   Text(
//                     "¡Datos guardados exitosamente!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 28 : 44, // responsivo
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black.withOpacity(0.6),
//                           blurRadius: 10,
//                           offset: const Offset(3, 3),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: isSmallScreen ? 16 : 24),
//
//                   Text(
//                     "Tus mascotas ahora cuentan con cobertura\n"
//                         "y estarán siempre protegidas 🐾",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 18 : 26, // responsivo
//                       color: Colors.white70,
//                     ),
//                   ),
//                   SizedBox(height: isSmallScreen ? 40 : 70),
//
//                   // 🐶🐱 Animaciones responsivas
//                   Wrap(
//                     alignment: WrapAlignment.center,
//                     spacing: isSmallScreen ? 20 : 50,
//                     runSpacing: 20,
//                     children: [
//                       Lottie.asset(
//                         'lib/ui/animation/dog.json',
//                         width: isSmallScreen ? size.width * 0.35 : 260,
//                         height: isSmallScreen ? size.width * 0.35 : 260,
//                       ),
//                       Lottie.asset(
//                         'lib/ui/animation/cat.json',
//                         width: isSmallScreen ? size.width * 0.35 : 260,
//                         height: isSmallScreen ? size.width * 0.35 : 260,
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: isSmallScreen ? 40 : 70),
//
//                   // 📝 Botón registrar nuevas mascotas
//                   SizedBox(
//                     width: isSmallScreen ? double.infinity : null,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const FormPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.tealAccent.shade400,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: isSmallScreen ? 20 : 36,
//                           vertical: isSmallScreen ? 14 : 20,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         elevation: 12,
//                       ),
//                       icon: const Icon(Icons.pets, color: Colors.black),
//                       label: Text(
//                         "Registrar nuevas mascotas",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: isSmallScreen ? 18 : 22, // responsivo
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'form_page.dart';
//
// class SuccessPage extends StatelessWidget {
//   const SuccessPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isSmallScreen = size.width < 600;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Fondo degradado
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color(0xFF0F2027),
//                   Color(0xFF203A43),
//                   Color(0xFF2C5364),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//
//           // Confeti animado de fondo
//           Positioned.fill(
//             child: IgnorePointer(
//               child: Lottie.asset(
//                 'lib/ui/animation/Confetti.json',
//                 fit: BoxFit.cover,
//                 repeat: true,
//               ),
//             ),
//           ),
//
//           // Contenido principal - CARD GRANDE CON SOLO LA IMAGEN
//           Center(
//             child: Container(
//               width: isSmallScreen ? size.width * 0.9 : 600,
//               height: isSmallScreen ? size.height * 0.7 : 700,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 15,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Encabezado con gradiente
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(20),
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                       ),
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF6A11CB),
//                           Color(0xFF2575FC),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           'OTTOKARE',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 28 : 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '¡Gracias por activar Otto Plan!',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 16 : 18,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // SOLO LA IMAGEN EN EL CONTENIDO
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Image.asset(
//                         'lib/ui/img/guardad.png', // Reemplaza con la ruta de tu imagen
//                         fit: BoxFit.contain,
//                         width: double.infinity,
//                         height: double.infinity,
//                       ),
//                     ),
//                   ),
//
//                   // Botón en la parte inferior
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const FormPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2575FC),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Registrar nuevas mascotas",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            child: Image.asset(
              'lib/ui/img/Hola.png',
              width: size.width * 0.9,  // 90% del ancho de pantalla
              height: size.height * 0.9, // 90% del alto de pantalla
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

