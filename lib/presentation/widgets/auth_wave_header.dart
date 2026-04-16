import 'package:flutter/material.dart';

class AuthWaveHeader extends StatelessWidget {
  const AuthWaveHeader({
    super.key,
    required this.child,
    this.leading,
    this.backgroundColor = const Color(0xFFF5FAF2),
  });

  final Widget child;
  final Widget? leading;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _WaveClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAAF0B7), Color(0xFF4CAF50)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 18,
              left: 26,
              child: _SparkleDot(size: 6, color: backgroundColor),
            ),
            Positioned(
              top: 54,
              right: 34,
              child: _SparkleDot(size: 7, color: backgroundColor),
            ),
            Positioned(
              top: 96,
              left: 98,
              child: _SparkleDot(size: 5, color: backgroundColor),
            ),
            Positioned(
              top: 164,
              right: 18,
              child: _SparkleDot(size: 6, color: backgroundColor),
            ),
            Positioned(
              top: -50,
              right: -56,
              child: Container(
                width: 172,
                height: 172,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -70,
              bottom: 48,
              child: Container(
                width: 152,
                height: 152,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            if (leading case Widget widget)
              Positioned(top: 12, left: 0, child: widget),
            child,
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 30,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 60,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) => false;
}

class _SparkleDot extends StatelessWidget {
  const _SparkleDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
