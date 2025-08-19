// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'form_page.dart'; // importa tu formulario
//
// class SuccessPage extends StatelessWidget {
//   const SuccessPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//
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
//
//           Positioned.fill(
//             child: IgnorePointer(
//               child: Lottie.asset(
//                 'lib/ui/animation/Confetti.json', // cuidado con minúsculas
//                 fit: BoxFit.cover,
//                 repeat: true,
//               ),
//             ),
//           ),
//
//           // 🐶🐱 Contenido principal
//           Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(32.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // 🎯 Texto principal
//                   Text(
//                     "¡Datos guardados exitosamente!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 44, // más grande
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
//                   const SizedBox(height: 24),
//                   const Text(
//                     "Tus mascotas ahora cuentan con cobertura\n"
//                         "y estarán siempre protegidas 🐾",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 26, // más grande
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 70),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Lottie.asset(
//                         'lib/ui/animation/dog.json',
//                         width: 260,
//                         height: 260,
//                       ),
//                       const SizedBox(width: 50),
//                       Lottie.asset(
//                         'lib/ui/animation/cat.json',
//                         width: 260,
//                         height: 260,
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 70),
//
//                   // 📝 Botón registrar nuevas mascotas
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const FormPage(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.tealAccent.shade400,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 36,
//                         vertical: 20,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       elevation: 12,
//                     ),
//                     icon: const Icon(Icons.pets, color: Colors.black),
//                     label: const Text(
//                       "Registrar nuevas mascotas",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 22, // más grande
//                         fontWeight: FontWeight.bold,
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
//
//
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'form_page.dart'; // importa tu formulario

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho y alto de la pantalla
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600; // breakpoint simple

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Fondo degradado
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027), // azul muy oscuro
                  Color(0xFF203A43), // intermedio
                  Color(0xFF2C5364), // más claro pero elegante
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 🎉 Confeti animado de fondo
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                'lib/ui/animation/Confetti.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),

          // 🐶🐱 Contenido principal
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🎯 Texto principal
                  Text(
                    "¡Datos guardados exitosamente!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 28 : 44, // responsivo
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 10,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),

                  Text(
                    "Tus mascotas ahora cuentan con cobertura\n"
                        "y estarán siempre protegidas 🐾",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 26, // responsivo
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 40 : 70),

                  // 🐶🐱 Animaciones responsivas
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isSmallScreen ? 20 : 50,
                    runSpacing: 20,
                    children: [
                      Lottie.asset(
                        'lib/ui/animation/dog.json',
                        width: isSmallScreen ? size.width * 0.35 : 260,
                        height: isSmallScreen ? size.width * 0.35 : 260,
                      ),
                      Lottie.asset(
                        'lib/ui/animation/cat.json',
                        width: isSmallScreen ? size.width * 0.35 : 260,
                        height: isSmallScreen ? size.width * 0.35 : 260,
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 40 : 70),

                  // 📝 Botón registrar nuevas mascotas
                  SizedBox(
                    width: isSmallScreen ? double.infinity : null,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FormPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent.shade400,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 20 : 36,
                          vertical: isSmallScreen ? 14 : 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 12,
                      ),
                      icon: const Icon(Icons.pets, color: Colors.black),
                      label: Text(
                        "Registrar nuevas mascotas",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isSmallScreen ? 18 : 22, // responsivo
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
