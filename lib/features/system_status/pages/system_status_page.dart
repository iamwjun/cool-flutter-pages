import 'dart:math' as math;

import 'package:flutter/material.dart';

class SystemStatusPage extends StatefulWidget {
  const SystemStatusPage({super.key});

  @override
  State<SystemStatusPage> createState() => _SystemStatusPageState();
}

class _SystemStatusPageState extends State<SystemStatusPage>
    with TickerProviderStateMixin {
  static const List<String> _phases = <String>[
    '扫描核心矩阵',
    '编织霓虹轨道',
    '稳定能量回路',
    '准备点亮界面',
  ];

  late final AnimationController _orbitController;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;
  late final AnimationController _sparkController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat();
    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    _sparkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        _orbitController,
        _pulseController,
        _progressController,
        _sparkController,
      ]),
      builder: (BuildContext context, Widget? child) {
        final progress = Curves.easeInOutCubic.transform(
          _progressController.value,
        );
        final pulse = Curves.easeInOut.transform(_pulseController.value);
        final phaseIndex = (progress * _phases.length)
            .clamp(0, _phases.length - 0.001)
            .floor();
        final phase = _phases[phaseIndex];
        final percent = (progress * 100).round().clamp(0, 100);

        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF020611),
                  Color(0xFF071526),
                  Color(0xFF030913),
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BackdropPainter(
                      drift: _sparkController.value,
                      pulse: pulse,
                    ),
                  ),
                ),
                Positioned(
                  top: -80,
                  left: -40,
                  child: _GlowBlob(
                    color: const Color(0xFF16E0FF),
                    size: 260,
                    opacity: 0.18 + pulse * 0.08,
                  ),
                ),
                Positioned(
                  bottom: -110,
                  right: -60,
                  child: _GlowBlob(
                    color: const Color(0xFFFF7A18),
                    size: 300,
                    opacity: 0.16 + pulse * 0.06,
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: LayoutBuilder(
                          builder:
                              (
                                BuildContext context,
                                BoxConstraints constraints,
                              ) {
                                final cardWidth = constraints.maxWidth;
                                final compact = cardWidth < 400;
                                final loaderSize = math
                                    .min(cardWidth - (compact ? 40 : 64), 340.0)
                                    .clamp(220.0, 340.0)
                                    .toDouble();
                                final padding = compact ? 20.0 : 28.0;

                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(padding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),
                                    color: const Color(
                                      0xFF091426,
                                    ).withValues(alpha: 0.72),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: const Color(
                                          0xFF16E0FF,
                                        ).withValues(alpha: 0.18),
                                        blurRadius: 48,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 18),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const _StatusChip(label: 'SYSTEM STATUS'),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: loaderSize,
                                        height: loaderSize,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Transform.scale(
                                              scale: 0.92 + pulse * 0.10,
                                              child: Container(
                                                width: loaderSize * 0.38,
                                                height: loaderSize * 0.38,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:
                                                      const RadialGradient(
                                                        colors: <Color>[
                                                          Color(0xFFFFFFFF),
                                                          Color(0xFF9BF9FF),
                                                          Color(0xFF16E0FF),
                                                          Color(0xFF082540),
                                                        ],
                                                      ),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFF16E0FF,
                                                      ).withValues(alpha: 0.52),
                                                      blurRadius: 44,
                                                      spreadRadius: 10,
                                                    ),
                                                    BoxShadow(
                                                      color: const Color(
                                                        0xFFFF7A18,
                                                      ).withValues(alpha: 0.20),
                                                      blurRadius: 72,
                                                      spreadRadius: 14,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            CustomPaint(
                                              size: Size.square(loaderSize),
                                              painter: _OrbitLoaderPainter(
                                                orbit: _orbitController.value,
                                                pulse: pulse,
                                                spark: _sparkController.value,
                                              ),
                                            ),
                                            Container(
                                              width: loaderSize * 0.34,
                                              height: loaderSize * 0.34,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(
                                                  0xFF020813,
                                                ).withValues(alpha: 0.42),
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.14),
                                                ),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6,
                                                      ),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          '${percent.toString().padLeft(2, '0')}%',
                                                          style: TextStyle(
                                                            fontSize:
                                                                loaderSize *
                                                                0.12,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            letterSpacing: 1.8,
                                                          ),
                                                        ),
                                                        Text(
                                                          'SYNC',
                                                          style: TextStyle(
                                                            fontSize:
                                                                loaderSize *
                                                                0.04,
                                                            letterSpacing: 4.2,
                                                            color: Colors.white
                                                                .withValues(
                                                                  alpha: 0.72,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        'QUANTUM SYNC',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: compact ? 26 : 30,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: compact ? 3.2 : 4.0,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '正在校准粒子轨道、光束与界面着色器',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: compact ? 14 : 15,
                                          height: 1.5,
                                          color: Colors.white.withValues(
                                            alpha: 0.72,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        switchInCurve: Curves.easeOut,
                                        switchOutCurve: Curves.easeIn,
                                        child: Text(
                                          phase,
                                          key: ValueKey<String>(phase),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Color(0xFFFFB067),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      _ProgressBeam(
                                        progress: progress,
                                        shimmer: _orbitController.value,
                                      ),
                                      const SizedBox(height: 14),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '00%',
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.45,
                                              ),
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '$percent%',
                                            style: const TextStyle(
                                              color: Color(0xFFB3FBFF),
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      const Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                          _SignalPill(label: '节点', value: '24'),
                                          _SignalPill(
                                            label: '频率',
                                            value: '9.8 THz',
                                          ),
                                          _SignalPill(label: '状态', value: '稳定'),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: <Color>[Color(0x3316E0FF), Color(0x22FF7A18)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.4,
          color: Color(0xFFB8FBFF),
        ),
      ),
    );
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.58),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBeam extends StatelessWidget {
  const _ProgressBeam({required this.progress, required this.shimmer});

  final double progress;
  final double shimmer;

  @override
  Widget build(BuildContext context) {
    final widthFactor = 0.12 + progress * 0.88;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        ),
        child: Stack(
          children: <Widget>[
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: widthFactor,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      Color(0xFF16E0FF),
                      Color(0xFF5CF2C5),
                      Color(0xFFFF7A18),
                    ],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: const Color(0xFF16E0FF).withValues(alpha: 0.30),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment(-1 + shimmer * 2, 0),
              child: IgnorePointer(
                child: Container(
                  width: 90,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: 0.60),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: size * 0.45,
              spreadRadius: size * 0.14,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitLoaderPainter extends CustomPainter {
  _OrbitLoaderPainter({
    required this.orbit,
    required this.pulse,
    required this.spark,
  });

  final double orbit;
  final double pulse;
  final double spark;

  static const List<Color> _palette = <Color>[
    Color(0xFF16E0FF),
    Color(0xFFFF7A18),
    Color(0xFF5CF2C5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final ringRadius = size.shortestSide * 0.34;

    final guidePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, ringRadius * 1.42, guidePaint);
    canvas.drawCircle(
      center,
      ringRadius * 1.72,
      guidePaint..color = Colors.white.withValues(alpha: 0.06),
    );

    final pulseRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF16E0FF).withValues(alpha: 0.16)
      ..strokeWidth = 2;
    canvas.drawCircle(
      center,
      ringRadius * (0.82 + pulse * 0.12),
      pulseRingPaint,
    );
    canvas.drawCircle(
      center,
      ringRadius * (0.64 + (1 - pulse) * 0.10),
      pulseRingPaint..color = const Color(0xFFFF7A18).withValues(alpha: 0.10),
    );

    for (var i = 0; i < 3; i++) {
      final color = _palette[i];
      final rotation =
          orbit * math.pi * (i.isEven ? 1.2 : -0.95) + i * math.pi / 3;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: ringRadius * (2.85 + i * 0.22),
        height: ringRadius * (1.52 + i * 0.12),
      );

      final haloPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
        ..color = color.withValues(alpha: 0.10 + pulse * 0.08);
      canvas.drawArc(
        rect,
        orbit * math.pi * 2 + i,
        math.pi / 1.45,
        false,
        haloPaint,
      );

      final orbitPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = color.withValues(alpha: 0.26 + pulse * 0.14);
      canvas.drawOval(rect, orbitPaint);
      canvas.restore();
    }

    for (var i = 0; i < 12; i++) {
      final radius = ringRadius * 1.48 + (i.isEven ? pulse * 6 : 0);
      final arcPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4
        ..color = _palette[i % _palette.length].withValues(alpha: 0.58);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        orbit * math.pi * 2 + i * math.pi / 6,
        math.pi / 16,
        false,
        arcPaint,
      );
    }

    for (var i = 0; i < 7; i++) {
      final direction = i.isEven ? 1.0 : -1.0;
      final angle = orbit * math.pi * 2 * direction + i * math.pi / 3.5;
      final radius = ringRadius * (1.04 + (i % 3) * 0.22);
      final orbitOffset = Offset(
        math.cos(angle) * radius,
        math.sin(angle * 1.15) * radius * 0.82,
      );
      final point = center + orbitOffset;
      final glowColor = _palette[i % _palette.length];

      final glowPaint = Paint()
        ..color = glowColor.withValues(alpha: 0.42)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(point, 10 + pulse * 3, glowPaint);

      final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.96);
      canvas.drawCircle(point, 2.4 + (i.isEven ? pulse : 0), dotPaint);
    }

    for (var i = 0; i < 16; i++) {
      final angle = spark * math.pi * 2 + i * math.pi / 8;
      final vector = Offset(math.cos(angle), math.sin(angle));
      final inner = center + vector * (ringRadius * 0.72);
      final outer =
          center + vector * (ringRadius * 0.95 + (i.isEven ? pulse * 8 : 0));

      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: i % 4 == 0 ? 0.15 : 0.06)
        ..strokeWidth = 1;
      canvas.drawLine(inner, outer, linePaint);
    }
  }

  @override
  bool shouldRepaint(_OrbitLoaderPainter oldDelegate) {
    return oldDelegate.orbit != orbit ||
        oldDelegate.pulse != pulse ||
        oldDelegate.spark != spark;
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter({required this.drift, required this.pulse});

  final double drift;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    const spacing = 36.0;
    final xOffset = (drift * spacing * 2) % spacing;

    for (double x = -spacing; x <= size.width + spacing; x += spacing) {
      canvas.drawLine(
        Offset(x + xOffset, 0),
        Offset(x + xOffset - 22, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y <= size.height + spacing; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint..color = Colors.white.withValues(alpha: 0.02),
      );
    }

    final starPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 28; i++) {
      final dx = size.width * (((i * 37) % 100) / 100);
      final dy = size.height * (((i * 61) % 100) / 100);
      final twinkle = 0.5 + 0.5 * math.sin(drift * math.pi * 2 + i);
      final color = i.isEven ? const Color(0xFF16E0FF) : Colors.white;
      starPaint.color = color.withValues(alpha: 0.06 + twinkle * 0.14);
      canvas.drawCircle(Offset(dx, dy), 1.1 + twinkle, starPaint);
    }

    final beamRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final beamPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = const LinearGradient(
        colors: <Color>[
          Color(0x0016E0FF),
          Color(0x5516E0FF),
          Color(0x00FF7A18),
        ],
      ).createShader(beamRect);

    final topBeam = Path()
      ..moveTo(-40, size.height * (0.18 + 0.02 * pulse))
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * (0.10 + 0.04 * drift),
        size.width + 60,
        size.height * 0.24,
      );
    canvas.drawPath(topBeam, beamPaint);

    final lowerBeam = Path()
      ..moveTo(-20, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * (0.82 - 0.06 * pulse),
        size.width + 40,
        size.height * 0.68,
      );
    canvas.drawPath(
      lowerBeam,
      beamPaint
        ..shader = const LinearGradient(
          colors: <Color>[
            Color(0x00FF7A18),
            Color(0x44FF7A18),
            Color(0x0016E0FF),
          ],
        ).createShader(beamRect),
    );
  }

  @override
  bool shouldRepaint(_BackdropPainter oldDelegate) {
    return oldDelegate.drift != drift || oldDelegate.pulse != pulse;
  }
}
