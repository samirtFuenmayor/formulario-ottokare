import 'package:flutter/material.dart';
import 'form_widget.dart'; // ajusta la ruta según tu estructura}
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopView extends StatelessWidget {
  final String contractId;
  const DesktopView({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final W = constraints.maxWidth;
          final H = constraints.maxHeight;

          final double hPad         = W * 0.06;
          final double vPad         = H * 0.07;
          final double leftColW     = W * 0.40;
          final double rightColW    = W * 0.46;
          final double titleSize    = (W * 0.034).clamp(28.0, 58.0);
          final double subtitleSize = (W * 0.014).clamp(13.0, 22.0);
          final double chipSize     = (W * 0.010).clamp(10.0, 15.0);
          final double logoW        = (W * 0.11).clamp(100.0, 200.0);
          final double petImgW      = (W * 0.42).clamp(280.0, 680.0);

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset('lib/ui/img/FondoPC.webp', fit: BoxFit.cover),
              ),
              Positioned(
                left: hPad, top: vPad, bottom: 0, width: leftColW,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('lib/ui/img/LogoOttokarePC.png', width: logoW),
                    SizedBox(height: H * 0.04),
                    Text(
                      "Activa la asistencia veterinaria para tu compañero",
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: H * 0.02),
                    Text(
                      "Registra a tu mascota y accede a múltiples beneficios.",
                      style: TextStyle(color: Colors.white70, fontSize: subtitleSize),
                    ),
                    SizedBox(height: H * 0.04),
                    Wrap(
                      spacing: W * 0.012, runSpacing: 8,
                      children: [
                        _chip("Asistencia", chipSize, 'lib/ui/img/icon-orientacion-white.svg'),
                        _chip("Hospedaje", chipSize, 'lib/ui/img/icon-hospedaje-white.svg'),
                        _chip("Y mucho más", chipSize, 'lib/ui/img/icon-Mas-beneficios-white.svg'),
                      ],
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRect(
                          child: Image.asset(
                            'lib/ui/img/ImagenOttoPC.webp',
                            width: petImgW, fit: BoxFit.contain,
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: hPad, top: vPad, bottom: vPad, width: rightColW,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20, offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                    child: FormWidget(contractId: contractId)
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(String text, double fontSize, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: fontSize + 6,
            height: fontSize + 6,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}