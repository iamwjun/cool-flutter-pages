import 'dart:math' as math;

import 'package:cool_pages/features/detail/pages/detail_page.dart';
import 'package:cool_pages/features/journal_challenge/pages/journal_challenge_page.dart';
import 'package:cool_pages/features/system_status/pages/system_status_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _driftController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _driftController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (BuildContext context) => page));
  }

  @override
  Widget build(BuildContext context) {
    final features = <_FeatureItem>[
      _FeatureItem(
        tag: '01',
        title: 'System Status',
        path: 'features/system_status',
        description: '原首页内容已迁移到这里，保留粒子同步加载的视觉表现。',
        buttonLabel: '打开 System Status',
        accent: const Color(0xFF16E0FF),
        secondary: const Color(0xFFFF7A18),
        icon: Icons.auto_awesome,
        highlights: const <String>['Loader', 'Neon', 'Animated'],
        pageBuilder: (_) => const SystemStatusPage(),
      ),
      _FeatureItem(
        tag: '02',
        title: 'Detail Lab',
        path: 'features/detail',
        description: '详情模块示例页，用来承接信息层、状态卡片和后续扩展。',
        buttonLabel: '打开 Detail',
        accent: const Color(0xFF7CFFB2),
        secondary: const Color(0xFF24A8FF),
        icon: Icons.dashboard_customize,
        highlights: const <String>['Panels', 'Metrics', 'Scaffold'],
        pageBuilder: (_) => const DetailPage(),
      ),
      _FeatureItem(
        tag: '03',
        title: 'Journal Challenge',
        path: 'features/journal_challenge',
        description: '根据 Shorts 里的 Journal 运动记录页面重建的移动端 UI 挑战。',
        buttonLabel: '打开 Journal Challenge',
        accent: const Color(0xFFF3D1A7),
        secondary: const Color(0xFF5967F5),
        icon: Icons.directions_walk_rounded,
        highlights: const <String>['Journal', 'Walker', 'CustomPaint'],
        pageBuilder: (_) => const JournalChallengePage(),
      ),
    ];

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        _driftController,
        _pulseController,
      ]),
      builder: (BuildContext context, Widget? child) {
        final drift = _driftController.value;
        final pulse = Curves.easeInOut.transform(_pulseController.value);

        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF030712),
                  Color(0xFF08111F),
                  Color(0xFF040913),
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PortalGridPainter(drift: drift, pulse: pulse),
                  ),
                ),
                Positioned(
                  top: -140 + pulse * 24,
                  left: -70,
                  child: _GlowOrb(
                    color: const Color(0xFF16E0FF),
                    size: 320,
                    opacity: 0.16 + pulse * 0.06,
                  ),
                ),
                Positioned(
                  right: -90,
                  bottom: -120 + pulse * 30,
                  child: _GlowOrb(
                    color: const Color(0xFF7CFFB2),
                    size: 340,
                    opacity: 0.12 + pulse * 0.08,
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const _HeroBadge(label: 'FEATURE GATEWAY'),
                            const SizedBox(height: 20),
                            LayoutBuilder(
                              builder:
                                  (
                                    BuildContext context,
                                    BoxConstraints constraints,
                                  ) {
                                    final compact = constraints.maxWidth < 900;

                                    return Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(
                                        compact ? 22 : 32,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(34),
                                        color: const Color(
                                          0xFF091323,
                                        ).withValues(alpha: 0.74),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.10,
                                          ),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: const Color(
                                              0xFF16E0FF,
                                            ).withValues(alpha: 0.14),
                                            blurRadius: 44,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 24),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'COOL FLUTTER PAGES',
                                            style: TextStyle(
                                              fontSize: compact ? 30 : 44,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: compact
                                                  ? 2.2
                                                  : 3.4,
                                              height: 0.96,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxWidth: 720,
                                            ),
                                            child: Text(
                                              '这是新的导向首页。所有 feature 模块从这里进入，保留实验感的视觉节奏，同时让结构切换足够直接。',
                                              style: TextStyle(
                                                fontSize: compact ? 15 : 17,
                                                height: 1.7,
                                                color: Colors.white.withValues(
                                                  alpha: 0.76,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 12,
                                            children: const <Widget>[
                                              _PulseChip(
                                                label: 'Default Entry',
                                                value: 'features/home',
                                              ),
                                              _PulseChip(
                                                label: 'Primary Module',
                                                value: 'system_status',
                                              ),
                                              _PulseChip(
                                                label: 'Navigation Mode',
                                                value: 'route push',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                            ),
                            const SizedBox(height: 24),
                            LayoutBuilder(
                              builder:
                                  (
                                    BuildContext context,
                                    BoxConstraints constraints,
                                  ) {
                                    final wide = constraints.maxWidth >= 920;
                                    final cardWidth = wide
                                        ? (constraints.maxWidth - 20) / 2
                                        : constraints.maxWidth;

                                    return Wrap(
                                      spacing: 20,
                                      runSpacing: 20,
                                      children: features
                                          .map(
                                            (_FeatureItem item) => SizedBox(
                                              width: cardWidth,
                                              child: _FeatureCard(
                                                item: item,
                                                pulse: pulse,
                                                onOpen: () => _openPage(
                                                  context,
                                                  item.pageBuilder(context),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    );
                                  },
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
        );
      },
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.tag,
    required this.title,
    required this.path,
    required this.description,
    required this.buttonLabel,
    required this.accent,
    required this.secondary,
    required this.icon,
    required this.highlights,
    required this.pageBuilder,
  });

  final String tag;
  final String title;
  final String path;
  final String description;
  final String buttonLabel;
  final Color accent;
  final Color secondary;
  final IconData icon;
  final List<String> highlights;
  final Widget Function(BuildContext context) pageBuilder;
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          colors: <Color>[Color(0x3316E0FF), Color(0x227CFFB2)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.8,
          color: Color(0xFFC2FCFF),
        ),
      ),
    );
  }
}

class _PulseChip extends StatelessWidget {
  const _PulseChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: '$label\n',
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.52),
                letterSpacing: 1.0,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.item,
    required this.pulse,
    required this.onOpen,
  });

  final _FeatureItem item;
  final double pulse;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            item.accent.withValues(alpha: 0.18 + pulse * 0.03),
            const Color(0xFF0B1323),
            item.secondary.withValues(alpha: 0.14 + (1 - pulse) * 0.04),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: item.accent.withValues(alpha: 0.18),
            blurRadius: 34,
            spreadRadius: 1,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withValues(alpha: 0.10),
                  border: Border.all(
                    color: item.accent.withValues(alpha: 0.32),
                  ),
                ),
                child: Icon(item.icon, color: Colors.white, size: 26),
              ),
              const Spacer(),
              Text(
                item.tag,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withValues(alpha: 0.16),
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            item.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.black.withValues(alpha: 0.16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.folder_open, size: 16, color: item.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.path,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.76),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: item.highlights
                .map(
                  (String highlight) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: Text(
                      highlight,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.82),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 26),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              key: ValueKey<String>('open-${item.path.replaceAll('/', '-')}'),
              onPressed: onOpen,
              style: FilledButton.styleFrom(
                backgroundColor: item.accent.withValues(alpha: 0.18),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                item.buttonLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
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
              blurRadius: size * 0.42,
              spreadRadius: size * 0.12,
            ),
          ],
        ),
      ),
    );
  }
}

class _PortalGridPainter extends CustomPainter {
  _PortalGridPainter({required this.drift, required this.pulse});

  final double drift;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final beamRect = Offset.zero & size;
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.04);

    const spacing = 42.0;
    final offset = (drift * spacing * 2) % spacing;

    for (double x = -spacing; x <= size.width + spacing; x += spacing) {
      canvas.drawLine(
        Offset(x + offset, 0),
        Offset(x + offset - 30, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y <= size.height + spacing; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint..color = Colors.white.withValues(alpha: 0.025),
      );
    }

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..shader = const LinearGradient(
        colors: <Color>[
          Color(0x0016E0FF),
          Color(0x5516E0FF),
          Color(0x337CFFB2),
        ],
      ).createShader(beamRect);

    final upperArc = Path()
      ..moveTo(-60, size.height * (0.16 + pulse * 0.02))
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * (0.04 + drift * 0.08),
        size.width + 80,
        size.height * 0.24,
      );
    canvas.drawPath(upperArc, arcPaint);

    final lowerArc = Path()
      ..moveTo(-20, size.height * 0.80)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * (0.92 - pulse * 0.07),
        size.width + 40,
        size.height * 0.70,
      );
    canvas.drawPath(
      lowerArc,
      arcPaint
        ..shader = const LinearGradient(
          colors: <Color>[
            Color(0x007CFFB2),
            Color(0x447CFFB2),
            Color(0x0016E0FF),
          ],
        ).createShader(beamRect),
    );

    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 32; i++) {
      final dx = size.width * (((i * 29) % 100) / 100);
      final dy = size.height * (((i * 47) % 100) / 100);
      final twinkle = 0.45 + 0.55 * math.sin((drift * math.pi * 2) + i);
      dotPaint.color =
          (i.isEven ? const Color(0xFF16E0FF) : const Color(0xFF7CFFB2))
              .withValues(alpha: 0.05 + twinkle * 0.16);
      canvas.drawCircle(Offset(dx, dy), 1.0 + twinkle * 1.4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_PortalGridPainter oldDelegate) {
    return oldDelegate.drift != drift || oldDelegate.pulse != pulse;
  }
}
