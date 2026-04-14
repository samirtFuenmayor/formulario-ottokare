import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'form_widget.dart';

// ═══════════════════════════════════════════════════════════════════
//  TABLET VIEW — diseño fiel a los mockups
//  • Hero animado con fondo de imagen
//  • Formulario con header propio (logo + stepper visual + "Paso X de 3")
//  • El FormWidget maneja sus propios pasos internamente; aquí sólo
//    necesitamos escuchar en qué paso está para pintar el stepper.
// ═══════════════════════════════════════════════════════════════════

class TabletView extends StatefulWidget {
  final String contractId;
  const TabletView({super.key, required this.contractId});

  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  bool _showForm = false;

  // Notifier que FormWidget actualiza cada vez que cambia de paso
  final ValueNotifier<int> _stepNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _stepNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final W = constraints.maxWidth;
          final H = constraints.maxHeight;
          return Stack(
            children: [
              // ── FONDO ─────────────────────────────────────────
              Positioned.fill(
                child: Image.asset(
                  'lib/ui/img/Fondo Tablet.webp',
                  fit: BoxFit.cover,
                ),
              ),

              // ── HERO ──────────────────────────────────────────
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showForm ? 0.0 : 1.0,
                child: IgnorePointer(
                  ignoring: _showForm,
                  child: _buildHero(W, H),
                ),
              ),

              // ── FORMULARIO (slide desde abajo) ────────────────
              AnimatedSlide(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                offset: _showForm ? Offset.zero : const Offset(0, 1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showForm ? 1.0 : 0.0,
                  child: _buildFormScreen(W, H),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  HERO (sin cambios funcionales, igual que antes)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHero(double W, double H) {
    final double logoW        = (W * 0.40).clamp(140.0, 260.0);
    final double titleSize    = (W * 0.055).clamp(26.0, 48.0);
    final double subtitleSize = (W * 0.022).clamp(14.0, 20.0);
    final double chipSize     = (W * 0.018).clamp(11.0, 15.0);
    final double petImgW      = (W * 0.38).clamp(220.0, 420.0);
    final double hPad         = W * 0.08;

    return SizedBox(
      width: W,
      height: H,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: H * 0.08),
          Image.asset('lib/ui/img/LogoOttoKareTabletMobile.png', width: logoW),
          SizedBox(height: H * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Text(
              "Activa la asistencia\nveterinaria para tu\ncompañero",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(height: H * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Text(
              "Registra a tu mascota y accede a múltiples beneficios.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: subtitleSize,
              ),
            ),
          ),
          SizedBox(height: H * 0.04),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _chip('lib/ui/img/icon-orientacion-veterinaria.svg', "Asistencia", chipSize),
              _chip('lib/ui/img/icon-hospedaje.svg', "Hospedaje", chipSize),
              _chip('lib/ui/img/icon-mucho-mas.svg', "Y mucho más", chipSize),
            ],
          ),
          SizedBox(height: H * 0.05),
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Image.asset(
                  'lib/ui/img/Imagen Otto Tablet Mobile.webp',
                  width: petImgW,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 2,
                child: _ctaButton(W),
              ),
            ],
          ),
          SizedBox(height: H * 0.05),
        ],
      ),
    );
  }

  Widget _chip(String iconPath, String text, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 18, height: 18,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton(double W) {
    return GestureDetector(
      onTap: () {
        _stepNotifier.value = 0;
        setState(() => _showForm = true);
      },
      child: Container(
        width: W * 0.48,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF00B0C8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Comenzar Registro",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 12),
            Icon(Icons.arrow_forward, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  PANTALLA COMPLETA DEL FORMULARIO
  //  Diseño fiel a las imágenes:
  //   • Fondo blanco
  //   • Logo OttoKare centrado arriba
  //   • Tres barras de progreso (coloreadas según paso actual)
  //   • Flecha ← a la izquierda de las barras
  //   • Texto "Paso X de 3" centrado debajo de las barras
  //   • El FormWidget ocupa el resto del espacio
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFormScreen(double W, double H) {
    return Container(
      width: W,
      height: H,
      color: Colors.white,
      child: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────
          _buildFormHeader(W, H),

          // ── CUERPO: FormWidget ───────────────────────────────
          Expanded(
            child: FormWidget(
              showStepper: false,
              contractId: widget.contractId,
              onStepChanged: (step) {
                _stepNotifier.value = step;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormHeader(double W, double H) {
    return ValueListenableBuilder<int>(
      valueListenable: _stepNotifier,
      builder: (context, step, _) {
        final bool isSuccess = step >= 3;

        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(
            top: H * 0.045,
            left: W * 0.055,
            right: W * 0.055,
            bottom: isSuccess ? H * 0.02 : H * 0.015,
          ),
          child: Column(
            // Alineación por defecto a la izquierda para los pasos
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Logo Centrado
              Center(
                child: Image.asset(
                  'lib/ui/img/Logo Form Tablet Mobile.png',
                  width: (W * 0.32).clamp(130.0, 220.0),
                ),
              ),

              if (!isSuccess) ...[
                SizedBox(height: H * 0.025),

                // 2. Fila: Flecha + Barras de progreso
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (step == 0) {
                          setState(() => _showForm = false);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Color(0xFF1B3A4B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          _progressBar(active: step >= 0, W: W),
                          const SizedBox(width: 6),
                          _progressBar(active: step >= 1, W: W),
                          const SizedBox(width: 6),
                          _progressBar(active: step >= 2, W: W),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: H * 0.012),

                // 3. "Paso X de 3" CENTRADO
                Center(
                  child: Text(
                    "Paso ${step + 1} de 3",
                    style: const TextStyle(
                      color: Color(0xFF6B7C85),
                      fontSize: 13,
                    ),
                  ),
                ),

                SizedBox(height: H * 0.018),

                // 4. Indicador visual (Círculo + Texto) a la IZQUIERDA
                // Alineado con el inicio de las barras (considerando el ancho de la flecha)
                Padding(
                  padding: const EdgeInsets.only(left: 0), // Ajusta si prefieres que inicie desde el borde o bajo la flecha
                  child: _stepLabel(step),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _stepLabel(int step) {
    const labels = ["Tus datos", "Tu mascota", "Condición de tu mascota"];
    if (step >= labels.length) return const SizedBox.shrink();

    return Row(
      // MainAxisSize.min para que no ocupe todo el ancho y respete la alineación izquierda
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF0D7A8A),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${step + 1}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          labels[step],
          style: const TextStyle(
            color: Color(0xFF1B3A4B),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Una barra de progreso individual
  Widget _progressBar({required bool active, required double W}) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        height: 5,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0D7A8A) : const Color(0xFFD6E4E8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}