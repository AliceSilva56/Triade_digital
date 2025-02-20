import 'package:flutter/material.dart';
import 'dart:math';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({super.key});

  @override
  ConfettiAnimationState createState() => ConfettiAnimationState();
}

class ConfettiAnimationState extends State<ConfettiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward().whenComplete(() {
        particles.clear();
      });

    _generateParticles();
  }

  void _generateParticles() {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      particles.add(ConfettiParticle(
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        size: random.nextDouble() * 10 + 5,
        speed: random.nextDouble() * 500 + 500,
        angle: random.nextDouble() * 2 * pi,
        distance: random.nextDouble() * 300,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ConfettiPainter(
            particles: particles,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class ConfettiParticle {
  final Color color;
  final double size;
  final double speed;
  final double angle;
  final double distance;

  ConfettiParticle({
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
    required this.distance,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animationValue;

  ConfettiPainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final particle in particles) {
      final progress = Curves.easeOut.transform(animationValue);
      final offset = Offset(
        center.dx + cos(particle.angle) * particle.distance * progress,
        center.dy + sin(particle.angle) * particle.distance * progress,
      );

      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(progress * 2 * pi);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
