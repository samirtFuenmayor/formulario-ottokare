import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form_widget.dart';

// ═══════════════════════════════════════════════════════════════════
//  COLOR TEXTOS FORMULARIO — Azul principal del design system
// ═══════════════════════════════════════════════════════════════════
const Color _kFormText       = Color(0xFF005871);  // Azul principal → todos los textos del form
const Color _kFormMuted      = Color(0xFF8E8E8E);  // Text input / subtextos
const Color _kFormProgress   = Color(0xFF005871);  // Barra activa
const Color _kFormProgressBg = Color(0xFFD6E4E8);  // Barra inactiva

class MobileView extends StatefulWidget {
  final String contractId;
  const MobileView({super.key, required this.contractId});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  bool _showForm = false;
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
              Positioned.fill(
                child: Image.asset('lib/ui/img/Fondo Mobile.webp', fit: BoxFit.cover),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showForm ? 0.0 : 1.0,
                child: IgnorePointer(ignoring: _showForm, child: _buildHero(W, H)),
              ),
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

  // ── HERO ──────────────────────────────────────────────────────
  Widget _buildHero(double W, double H) {
    final double layoutHeight = H < 700 ? 750 : H;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: W, height: layoutHeight,
        child: Column(
          children: [
            const Spacer(flex: 1),
            Image.asset('lib/ui/img/LogoOttoKareTabletMobile.png', width: W * 0.50),
            SizedBox(height: layoutHeight * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: W * 0.08),
              child: Text(
                "Activa la asistencia\nveterinaria para tu\ncompañero",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 28,
                    fontWeight: FontWeight.bold, height: 1.1),
              ),
            ),
            SizedBox(height: layoutHeight * 0.02),
            Text(
              "Registra a tu mascota y accede a múltiples beneficios.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 15),
            ),
            SizedBox(height: layoutHeight * 0.035),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _chip('lib/ui/img/icon-orientacion-veterinaria.svg', "Asistencia"),
                  const SizedBox(width: 8),
                  _chip('lib/ui/img/icon-hospedaje.svg', "Hospedaje"),
                  const SizedBox(width: 8),
                  _chip('lib/ui/img/icon-mucho-mas.svg', "Y mucho más"),
                ],
              ),
            ),
            SizedBox(height: layoutHeight * 0.035),
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Image.asset('lib/ui/img/Imagen Otto Tablet Mobile.webp',
                      width: W * 0.85, fit: BoxFit.contain),
                ),
                Positioned(bottom: 10, child: _ctaButton(W)),
              ],
            ),
            SizedBox(height: layoutHeight * 0.15),
          ],
        ),
      ),
    );
  }

  Widget _chip(String iconPath, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white60),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath, width: 25,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _ctaButton(double W) {
    return GestureDetector(
      onTap: () => setState(() => _showForm = true),
      child: Container(
        width: W * 0.80,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF00B0C8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Comenzar Registro",
                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // ── PANTALLA FORMULARIO ───────────────────────────────────────
  Widget _buildFormScreen(double W, double H) {
    return Container(
      width: W, height: H, color: Colors.white,
      child: Column(
        children: [
          _buildFormHeader(W, H),
          Expanded(
            child: FormWidget(
              showStepper: false,
              contractId: widget.contractId,
              onStepChanged: (step) => _stepNotifier.value = step,
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
          padding: EdgeInsets.only(top: H * 0.05, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo centrado
              Center(
                child: Image.asset('lib/ui/img/Logo Form Tablet Mobile.png', width: W * 0.70),
              ),
              if (!isSuccess) ...[
                const SizedBox(height: 35),
                // Barras de progreso
                Row(
                  children: List.generate(3, (i) => _progressBar(active: step >= i)),
                ),
                // Flecha ← + "Paso X de 3" centrado
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => step == 0 ? setState(() => _showForm = false) : null,
                        // Flecha: color azul principal
                        child: const Icon(Icons.arrow_back, color: _kFormText, size: 24),
                      ),
                    ),
                    // "Paso X de 3": Montserrat Medium, color muted
                    Text(
                      "Paso ${step + 1} de 3",
                      style: GoogleFonts.montserrat(
                        color: _kFormMuted, fontSize: 13, fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Indicador de paso: Quicksand Bold, color azul principal
                _stepLabel(step),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _progressBar({required bool active}) {
    return Expanded(
      child: Container(
        height: 5,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: active ? _kFormProgress : _kFormProgressBg,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _stepLabel(int step) {
    const labels = ["Tus datos", "Tu mascota", "Condición de tu mascota"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Círculo con número: fondo azul principal
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: _kFormText, shape: BoxShape.circle),
          child: Text(
            "${step + 1}",
            style: GoogleFonts.quicksand(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Texto del paso: Quicksand Bold, color azul principal
        Text(
          labels[step],
          style: GoogleFonts.quicksand(
            color: _kFormText, fontSize: 16, fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}