import 'package:flutter/material.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F6D7A),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: const [
          SizedBox(height: 60),

          /// LOGO
          Text(
            "LOGO",
            style: TextStyle(color: Colors.white),
          ),

          SizedBox(height: 30),

          /// TITLE
          Text(
            "Activa la asistencia veterinaria",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),

          SizedBox(height: 20),

          /// CTA
          Text(
            "BOTÓN",
            style: TextStyle(color: Colors.white),
          ),

          Spacer(),

          /// IMAGE (dog + cat)
          Text(
            "IMAGEN",
            style: TextStyle(color: Colors.white),
          ),

          SizedBox(height: 30),
        ],
      ),
    );
  }
}