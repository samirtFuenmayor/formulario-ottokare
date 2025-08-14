import 'dart:math';
import 'package:flutter/material.dart';

class PremiumParticlesBackground extends StatefulWidget {
  const PremiumParticlesBackground({super.key});

  @override
  State<PremiumParticlesBackground> createState() =>
      _PremiumParticlesBackgroundState();
}

class _PremiumParticlesBackgroundState
    extends State<PremiumParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();
  Offset _mousePosition = Offset.zero;

  final int particleCount = 120;

  @override
  void initState() {
    super.initState();

    // Crear partículas iniciales
    for (int i = 0; i < particleCount; i++) {
      _particles.add(_Particle(
        position: Offset(
          _random.nextDouble() * 1000,
          _random.nextDouble() * 800,
        ),
        radius: 2 + _random.nextDouble() * 2,
        color: Color.lerp(
            Colors.blueAccent, Colors.tealAccent, _random.nextDouble())!,
        speed: Offset((_random.nextDouble() - 0.5) * 0.5,
            (_random.nextDouble() - 0.5) * 0.5),
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(() {
        setState(() {
          for (final p in _particles) {
            p.position += p.speed;

            // Limites de pantalla
            if (p.position.dx > 1000) p.position = Offset(0, p.position.dy);
            if (p.position.dx < 0) p.position = Offset(1000, p.position.dy);
            if (p.position.dy > 800) p.position = Offset(p.position.dx, 0);
            if (p.position.dy < 0) p.position = Offset(p.position.dx, 800);
          }
        });
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMousePosition(PointerEvent details) {
    setState(() {
      _mousePosition = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: _updateMousePosition,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _PremiumParticlesPainter(_particles, _mousePosition),
      ),
    );
  }
}

class _Particle {
  Offset position;
  double radius;
  Color color;
  Offset speed;
  _Particle(
      {required this.position,
      required this.radius,
      required this.color,
      required this.speed});
}

class _PremiumParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset mousePosition;

  _PremiumParticlesPainter(this.particles, this.mousePosition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Dibujar partículas
    for (final p in particles) {
      paint.color = p.color.withOpacity(0.4);
      canvas.drawCircle(p.position, p.radius, paint);
    }

    // Dibujar líneas entre partículas cercanas
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        double dist = (particles[i].position - particles[j].position).distance;
        if (dist < 100) {
          paint.color = Colors.blueAccent.withOpacity(0.05);
          paint.strokeWidth = 1;
          canvas.drawLine(particles[i].position, particles[j].position, paint);
        }
      }
    }

    // Conectar partículas al mouse si está cerca
    for (final p in particles) {
      double dist = (p.position - mousePosition).distance;
      if (dist < 120) {
        paint.color = Colors.tealAccent.withOpacity(0.15);
        paint.strokeWidth = 1.2;
        canvas.drawLine(p.position, mousePosition, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumParticlesPainter oldDelegate) => true;
}
