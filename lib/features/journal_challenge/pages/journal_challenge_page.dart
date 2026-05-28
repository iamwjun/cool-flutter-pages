import 'dart:math' as math;

import 'package:flutter/material.dart';

class JournalChallengePage extends StatefulWidget {
  const JournalChallengePage({super.key});

  @override
  State<JournalChallengePage> createState() => _JournalChallengePageState();
}

class _JournalChallengePageState extends State<JournalChallengePage>
    with TickerProviderStateMixin {
  late final AnimationController _motionController;
  late final AnimationController _transitionController;
  var _previousTab = 1;
  var _activeTab = 1;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 560),
      value: 1,
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    if (_activeTab == index) {
      return;
    }

    setState(() {
      _previousTab = _activeTab;
      _activeTab = index;
    });
    _transitionController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        _motionController,
        _transitionController,
      ]),
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFFAF6),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              final layout = _ScreenLayout(
                size: size,
                insets: MediaQuery.paddingOf(context),
              );

              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WarmCanvasPainter(activeTab: _activeTab),
                    ),
                  ),
                  Positioned.fill(
                    child: _SharedChallengeScene(
                      layout: layout,
                      motion: _motionController.value,
                      progress: Curves.easeInOutCubic.transform(
                        _transitionController.value,
                      ),
                      fromTab: _previousTab,
                      toTab: _activeTab,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    height: layout.topNavHeight,
                    child: _TopNavigationBar(
                      layout: layout,
                      activeTab: _activeTab,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _BottomTabs(
                      height: layout.navHeight,
                      activeTab: _activeTab,
                      onChanged: _changeTab,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ScreenLayout {
  const _ScreenLayout({required this.size, required this.insets});

  final Size size;
  final EdgeInsets insets;

  double get shortSide => math.min(size.width, size.height);
  double get side => shortSide.clamp(320, 430) * 0.105;
  double get titleTop => math.max(insets.top + 15, size.height * 0.036);
  double get contentTop => size.height * 0.055;
  double get topNavHeight => titleTop + 42;
  double get navHeight => math.max(92, math.min(122, size.height * 0.145));
  double get navTop => size.height - navHeight;
  double get contentBottom => navHeight + math.max(22, size.height * 0.034);
  bool get compact => size.height < 720;

  double x(double value) => size.width * value;
  double y(double value) => size.height * value;
}

class _TopNavigationBar extends StatelessWidget {
  const _TopNavigationBar({required this.layout, required this.activeTab});

  final _ScreenLayout layout;
  final int activeTab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: layout.side,
          top: layout.titleTop,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.18),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _SectionTitle(
              _titleFor(activeTab),
              key: ValueKey<int>(activeTab),
            ),
          ),
        ),
        Positioned(
          right: layout.side,
          top: math.max(0, layout.titleTop - 8),
          child: const _MenuButton(),
        ),
      ],
    );
  }

  String _titleFor(int tab) {
    return switch (tab) {
      0 => 'DAILY GOAL',
      1 => 'JOURNAL',
      _ => 'PROFILE',
    };
  }
}

class _SharedChallengeScene extends StatelessWidget {
  const _SharedChallengeScene({
    required this.layout,
    required this.motion,
    required this.progress,
    required this.fromTab,
    required this.toTab,
  });

  final _ScreenLayout layout;
  final double motion;
  final double progress;
  final int fromTab;
  final int toTab;

  @override
  Widget build(BuildContext context) {
    final daily = _visibility(0);
    final journal = _visibility(1);
    final profile = _visibility(2);
    final personFrame = _PersonFrame.lerp(
      _personFrameFor(fromTab),
      _personFrameFor(toTab),
      progress,
    );
    final cardHeight = layout.compact ? 108.0 : 126.0;
    final goalCardHeight = layout.compact ? 64.0 : 76.0;
    final goalCardGap = layout.compact ? 10.0 : 12.0;

    return Stack(
      children: <Widget>[
        _FadingPositioned(
          opacity: daily,
          left: layout.side - 3,
          top: layout.contentTop + 52 + _contentDrift(0),
          child: const _GoalPercent(),
        ),
        _FadingPositioned(
          opacity: daily,
          left: layout.side,
          top:
              layout.contentTop +
              (layout.compact ? 190 : 228) +
              _contentDrift(0),
          child: const _DailyMetrics(),
        ),
        _FadingPositioned(
          opacity: daily,
          top: layout.contentTop + (layout.compact ? 344 : 438),
          right: math.max(16, layout.side * 0.58),
          width: math.min(layout.size.width * 0.44, 236.0),
          height: math.min(layout.size.width * 0.44, 236.0) * 0.48,
          child: CustomPaint(painter: _ActivityRingPainter(motion: motion)),
        ),
        _FadingPositioned(
          opacity: journal,
          top: layout.contentTop + 58 + _contentDrift(1),
          left: layout.side - 23,
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF9C9BA0),
            size: 34,
          ),
        ),
        _FadingPositioned(
          opacity: journal,
          left: layout.side,
          top: layout.contentTop + 34 + _contentDrift(1),
          child: const _JournalDate(),
        ),
        _FadingPositioned(
          opacity: journal,
          left: layout.size.width * 0.08,
          right: 0,
          top: layout.y(0.30),
          height: math.min(172, layout.size.height * 0.20),
          child: CustomPaint(painter: _MountainPainter()),
        ),
        _FadingPositioned(
          opacity: profile,
          left: layout.side,
          top: layout.contentTop + 44 + _contentDrift(2),
          child: const Text(
            'Ron',
            style: TextStyle(
              color: Color(0xFF304576),
              fontSize: 82,
              fontWeight: FontWeight.w800,
              height: 0.95,
              letterSpacing: 0,
            ),
          ),
        ),
        _FadingPositioned(
          opacity: profile,
          left: layout.side,
          top: layout.contentTop + 142 + _contentDrift(2),
          child: const Text(
            '29 years old',
            style: TextStyle(
              color: Color(0xFF77777E),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _FadingPositioned(
          opacity: profile,
          left: 0,
          right: 0,
          top:
              (layout.compact ? layout.y(0.565) : layout.y(0.525)) +
              _contentDrift(2),
          child: const Center(
            child: Text(
              'Daily goals',
              style: TextStyle(
                color: Color(0xFF77777E),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Positioned(
          left: personFrame.left,
          top:
              personFrame.top +
              (toTab == 1 ? math.sin(motion * math.pi * 2) * 4 : 0),
          width: personFrame.width,
          height: personFrame.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (fromTab != toTab)
                Opacity(
                  opacity: 1 - progress,
                  child: _PersonCanvas(tab: fromTab, motion: motion),
                ),
              Opacity(
                opacity: fromTab == toTab ? 1 : progress,
                child: _PersonCanvas(tab: toTab, motion: motion),
              ),
            ],
          ),
        ),
        _FadingPositioned(
          opacity: daily,
          left: layout.side,
          right: layout.side,
          bottom: layout.contentBottom,
          height: cardHeight,
          child: const _ArticleCard(),
        ),
        _FadingPositioned(
          opacity: journal,
          left: layout.side,
          right: layout.side,
          bottom: layout.contentBottom,
          height: cardHeight,
          child: const _MorningWalkCard(),
        ),
        _FadingPositioned(
          opacity: profile,
          left: layout.side,
          right: layout.side,
          bottom: layout.contentBottom,
          child: _GoalCards(cardHeight: goalCardHeight, gap: goalCardGap),
        ),
      ],
    );
  }

  double _visibility(int tab) {
    if (fromTab == toTab) {
      return tab == toTab ? 1 : 0;
    }
    if (tab == fromTab) {
      return 1 - progress;
    }
    if (tab == toTab) {
      return progress;
    }
    return 0;
  }

  double _contentDrift(int tab) {
    if (fromTab == toTab) {
      return 0;
    }
    if (tab == fromTab) {
      return -22 * progress;
    }
    if (tab == toTab) {
      return 22 * (1 - progress);
    }
    return 0;
  }

  _PersonFrame _personFrameFor(int tab) {
    return switch (tab) {
      0 => _dailyPersonFrame(),
      1 => _journalPersonFrame(),
      _ => _profilePersonFrame(),
    };
  }

  _PersonFrame _dailyPersonFrame() {
    final width = math.min(layout.size.width * 0.34, 188.0);
    return _PersonFrame(
      left: layout.size.width - math.max(22, layout.side * 0.65) - width,
      top: layout.contentTop + 110,
      width: width,
      height: width * 1.86,
    );
  }

  _PersonFrame _journalPersonFrame() {
    final width = math.min(layout.size.width * 0.54, 226.0);
    return _PersonFrame(
      left: layout.x(0.33),
      top: layout.compact ? layout.y(0.205) : layout.y(0.220),
      width: width,
      height: width * 1.55,
    );
  }

  _PersonFrame _profilePersonFrame() {
    final size = math.min(layout.shortSide * 0.50, 230.0);
    return _PersonFrame(
      left: (layout.size.width - size) / 2,
      top: layout.compact ? layout.y(0.285) : layout.y(0.265),
      width: size,
      height: size,
    );
  }
}

class _PersonFrame {
  const _PersonFrame({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  static _PersonFrame lerp(_PersonFrame a, _PersonFrame b, double t) {
    return _PersonFrame(
      left: _lerpDouble(a.left, b.left, t),
      top: _lerpDouble(a.top, b.top, t),
      width: _lerpDouble(a.width, b.width, t),
      height: _lerpDouble(a.height, b.height, t),
    );
  }
}

class _PersonCanvas extends StatelessWidget {
  const _PersonCanvas({required this.tab, required this.motion});

  final int tab;
  final double motion;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: switch (tab) {
        0 => _StandingPersonPainter(motion: motion, portrait: false),
        1 => _WalkingPersonPainter(motion: motion),
        _ => _ProfilePersonPainter(motion: motion),
      },
    );
  }
}

class _FadingPositioned extends StatelessWidget {
  const _FadingPositioned({
    required this.opacity,
    required this.child,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });

  final double opacity;
  final Widget child;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0.001) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: IgnorePointer(
        ignoring: opacity < 0.98,
        child: Opacity(opacity: opacity.clamp(0, 1), child: child),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF333950),
        fontSize: 21,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }
}

class _GoalPercent extends StatelessWidget {
  const _GoalPercent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          '87',
          style: TextStyle(
            color: Color(0xFF304576),
            fontSize: 118,
            fontWeight: FontWeight.w800,
            height: 0.86,
            letterSpacing: 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7, bottom: 14),
          child: Text(
            '%',
            style: TextStyle(
              color: Color(0xFF7D7D84),
              fontSize: 31,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _JournalDate extends StatelessWidget {
  const _JournalDate();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '13',
          style: TextStyle(
            color: Color(0xFF304576),
            fontSize: 126,
            fontWeight: FontWeight.w300,
            height: 0.86,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 18),
        Text(
          'July 2020',
          style: TextStyle(
            color: Color(0xFF77777E),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (var i = 0; i < 3; i++)
            Container(
              width: 34,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF303241),
                borderRadius: BorderRadius.circular(999),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF303241).withValues(alpha: 0.13),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DailyMetrics extends StatelessWidget {
  const _DailyMetrics();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _MetricLine(
          icon: Icons.local_fire_department_rounded,
          color: Color(0xFFFF6A2E),
          value: '1,840',
          label: 'calories',
        ),
        SizedBox(height: 27),
        _MetricLine(
          icon: Icons.directions_walk_rounded,
          color: Color(0xFF7137EB),
          value: '3,248',
          label: 'steps',
        ),
        SizedBox(height: 27),
        _MetricLine(
          icon: Icons.nights_stay_rounded,
          color: Color(0xFF25BDE8),
          value: '6.5',
          label: 'hours',
        ),
      ],
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: color, size: 34),
        const SizedBox(width: 22),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF33364E),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8F8F94),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard();

  @override
  Widget build(BuildContext context) {
    return _FloatingCard(
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 76,
            height: 76,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              child: CustomPaint(painter: _ArticleThumbPainter()),
            ),
          ),
          const SizedBox(width: 28),
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'A simple way to\nstay healthy',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF33364B),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.24,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Dr Melissa',
                      style: TextStyle(
                        color: Color(0xFF9B9A9E),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.lightbulb_rounded,
            color: Color(0xFFD62E65),
            size: 30,
          ),
        ],
      ),
    );
  }
}

class _MorningWalkCard extends StatelessWidget {
  const _MorningWalkCard();

  @override
  Widget build(BuildContext context) {
    return _FloatingCard(
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 76,
            height: 76,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              child: CustomPaint(painter: _MiniMapPainter()),
            ),
          ),
          const SizedBox(width: 24),
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '10:42',
                      style: TextStyle(
                        color: Color(0xFF8C8B91),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 13),
                    Text(
                      'Morning Walk',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF33364B),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '2km in 30mins',
                      style: TextStyle(
                        color: Color(0xFF8C8B91),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.directions_walk_rounded,
            color: Color(0xFFD28A2F),
            size: 30,
          ),
        ],
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  const _FloatingCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFD8C9BD).withValues(alpha: 0.35),
            blurRadius: 34,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _GoalCards extends StatelessWidget {
  const _GoalCards({required this.cardHeight, required this.gap});

  final double cardHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _GoalPill(
          icon: Icons.local_fire_department_rounded,
          label: 'Calories',
          value: '2,000',
          color: const Color(0xFFFF6744),
          height: cardHeight,
        ),
        SizedBox(height: gap),
        _GoalPill(
          icon: Icons.directions_walk_rounded,
          label: 'Steps',
          value: '3,500',
          color: const Color(0xFF9600F0),
          height: cardHeight,
        ),
        SizedBox(height: gap),
        _GoalPill(
          icon: Icons.nights_stay_rounded,
          label: 'Sleep',
          value: '8h',
          color: const Color(0xFF0EAEE8),
          height: cardHeight,
        ),
      ],
    );
  }
}

class _GoalPill extends StatelessWidget {
  const _GoalPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.height,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomTabs extends StatelessWidget {
  const _BottomTabs({
    required this.height,
    required this.activeTab,
    required this.onChanged,
  });

  final double height;
  final int activeTab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFFDBCEC4).withValues(alpha: 0.42),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _TabIcon(
            key: const ValueKey<String>('journal-challenge-tab-daily'),
            icon: Icons.monitor_heart_outlined,
            active: activeTab == 0,
            onTap: () => onChanged(0),
          ),
          _TabIcon(
            key: const ValueKey<String>('journal-challenge-tab-journal'),
            icon: Icons.schedule_rounded,
            active: activeTab == 1,
            onTap: () => onChanged(1),
          ),
          _TabIcon(
            key: const ValueKey<String>('journal-challenge-tab-profile'),
            icon: Icons.person_outline_rounded,
            active: activeTab == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    super.key,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFFD72D64) : const Color(0xFF3B3E4D);

    return InkResponse(
      onTap: onTap,
      radius: 36,
      child: SizedBox(
        width: 78,
        height: 78,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              bottom: active ? 7 : 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: active ? 35 : 0,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD72D64),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            AnimatedScale(
              duration: const Duration(milliseconds: 220),
              scale: active ? 1.08 : 1,
              child: Icon(icon, color: color, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarmCanvasPainter extends CustomPainter {
  const _WarmCanvasPainter({required this.activeTab});

  final int activeTab;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFFFFBF7),
            Color(0xFFFEF8F2),
            Color(0xFFF7EEE7),
          ],
        ).createShader(rect),
    );

    if (activeTab == 2) {
      canvas.drawCircle(
        Offset(size.width * 0.50, size.height * 0.36),
        math.min(size.width, size.height) * 0.32,
        Paint()..color = const Color(0xFFF8F0EA).withValues(alpha: 0.76),
      );
    }
  }

  @override
  bool shouldRepaint(_WarmCanvasPainter oldDelegate) {
    return oldDelegate.activeTab != activeTab;
  }
}

class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path mountain(double x, double y, double width, double height) {
      return Path()
        ..moveTo(x, y)
        ..lineTo(x + width * 0.50, y - height)
        ..lineTo(x + width, y)
        ..close();
    }

    canvas.drawPath(
      mountain(
        size.width * 0.02,
        size.height * 0.88,
        size.width * 0.26,
        size.height * 0.65,
      ),
      Paint()..color = const Color(0xFFECE4DD).withValues(alpha: 0.78),
    );
    canvas.drawPath(
      mountain(
        size.width * 0.20,
        size.height * 0.89,
        size.width * 0.18,
        size.height * 0.44,
      ),
      Paint()..color = const Color(0xFFF0E9E3).withValues(alpha: 0.76),
    );
    canvas.drawPath(
      mountain(
        size.width * 0.62,
        size.height * 0.87,
        size.width * 0.50,
        size.height * 0.86,
      ),
      Paint()..color = const Color(0xFFEDE4DD).withValues(alpha: 0.82),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityRingPainter extends CustomPainter {
  const _ActivityRingPainter({required this.motion});

  final double motion;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width * 0.52, size.height * 0.52),
      width: size.width * 0.88,
      height: size.height * 0.96,
    );

    final ghostPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 7
      ..color = const Color(0xFFEFEAE4);

    for (var i = 0; i < 4; i++) {
      canvas.drawArc(
        rect.deflate(i * 11),
        math.pi * 0.12,
        math.pi * 1.34,
        false,
        ghostPaint
          ..color = const Color(0xFFEFEAE4).withValues(alpha: 0.68 - i * 0.09),
      );
    }

    const colors = <Color>[
      Color(0xFF2FC5E9),
      Color(0xFF6F31EA),
      Color(0xFFFF702E),
    ];
    const starts = <double>[0.07, 0.14, 0.21];
    const sweeps = <double>[1.22, 1.05, 0.78];

    for (var i = 0; i < colors.length; i++) {
      final progress = 0.88 + math.sin(motion * math.pi * 2 + i) * 0.035;
      canvas.drawArc(
        rect.deflate(i * 13),
        math.pi * starts[i],
        math.pi * sweeps[i] * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8
          ..color = colors[i],
      );
    }
  }

  @override
  bool shouldRepaint(_ActivityRingPainter oldDelegate) {
    return oldDelegate.motion != motion;
  }
}

class _WalkingPersonPainter extends CustomPainter {
  const _WalkingPersonPainter({required this.motion});

  final double motion;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = math.sin(motion * math.pi * 2);
    final s = size.width / 226;
    final cx = size.width * 0.48;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, size.height * 0.91),
        width: size.width * 0.64,
        height: size.height * 0.08,
      ),
      Paint()
        ..shader =
            RadialGradient(
              colors: <Color>[
                const Color(0xFFB8B0A9).withValues(alpha: 0.28),
                const Color(0xFFB8B0A9).withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCenter(
                center: Offset(cx, size.height * 0.91),
                width: size.width * 0.68,
                height: size.height * 0.11,
              ),
            ),
    );

    final outline = _outline(2.3 * s);
    final skin = Paint()..color = const Color(0xFFE6A0B8);
    final pants = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 23 * s
      ..color = const Color(0xFF3515BD);

    final hip = Offset(cx - 4 * s, 196 * s);
    final rearKnee = Offset(cx - 40 * s + phase * 11 * s, 244 * s);
    final rearFoot = Offset(cx - 79 * s - phase * 8 * s, 302 * s);
    final frontKnee = Offset(cx + 22 * s - phase * 9 * s, 242 * s);
    final frontFoot = Offset(cx + 61 * s + phase * 5 * s, 296 * s);

    canvas.drawLine(hip, rearKnee, pants);
    canvas.drawLine(rearKnee, rearFoot, pants);
    canvas.drawLine(hip.translate(12 * s, 0), frontKnee, pants);
    canvas.drawLine(frontKnee, frontFoot, pants);
    canvas.drawLine(rearKnee, rearFoot, _highlight(9 * s));

    _drawShoe(canvas, rearFoot, -0.18 - phase * 0.05, s);
    _drawShoe(canvas, frontFoot, 0.05 + phase * 0.05, s);

    final neck = Offset(cx - 5 * s, 84 * s);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: neck, width: 17 * s, height: 26 * s),
        Radius.circular(9 * s),
      ),
      skin,
    );

    final shirt = Path()
      ..moveTo(neck.dx - 21 * s, neck.dy + 7 * s)
      ..cubicTo(
        neck.dx - 47 * s,
        neck.dy + 46 * s,
        neck.dx - 41 * s,
        neck.dy + 96 * s,
        neck.dx - 9 * s,
        neck.dy + 113 * s,
      )
      ..cubicTo(
        neck.dx + 31 * s,
        neck.dy + 127 * s,
        neck.dx + 70 * s,
        neck.dy + 107 * s,
        neck.dx + 58 * s,
        neck.dy + 69 * s,
      )
      ..cubicTo(
        neck.dx + 49 * s,
        neck.dy + 38 * s,
        neck.dx + 29 * s,
        neck.dy + 9 * s,
        neck.dx + 5 * s,
        neck.dy,
      )
      ..close();
    canvas.drawPath(
      shirt,
      _shirtShader(Rect.fromLTWH(54 * s, 84 * s, 118 * s, 126 * s)),
    );
    canvas.drawPath(shirt, outline);

    final rearArm = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 11 * s
      ..color = const Color(0xFF3D2CC2);
    final frontArm = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 13 * s
      ..color = const Color(0xFF687AF2);
    final rearHand = Offset(
      cx - 47 * s - phase * 7 * s,
      196 * s + phase * 3 * s,
    );
    final frontHand = Offset(
      cx + 76 * s + phase * 7 * s,
      194 * s - phase * 5 * s,
    );
    canvas.drawLine(
      Offset(neck.dx - 17 * s, neck.dy + 40 * s),
      rearHand,
      rearArm,
    );
    canvas.drawLine(
      Offset(neck.dx + 22 * s, neck.dy + 38 * s),
      frontHand,
      frontArm,
    );
    canvas.drawCircle(rearHand, 7 * s, skin);
    canvas.drawCircle(frontHand, 7 * s, skin);
    canvas.drawLine(
      Offset(rearHand.dx + 2 * s, rearHand.dy + 5 * s),
      Offset(rearHand.dx + 8 * s, rearHand.dy + 12 * s),
      _handLine(s),
    );
    canvas.drawLine(
      Offset(frontHand.dx - 2 * s, frontHand.dy + 5 * s),
      Offset(frontHand.dx + 8 * s, frontHand.dy + 12 * s),
      _handLine(s),
    );

    final faceRect = Rect.fromCenter(
      center: Offset(cx + 5 * s, 58 * s),
      width: 43 * s,
      height: 55 * s,
    );
    canvas.drawOval(faceRect, _skinShader(faceRect));
    canvas.drawOval(faceRect, outline);

    final hair = _sideHairPath(cx, s);
    final hairRect = Rect.fromLTWH(cx - 35 * s, 16 * s, 72 * s, 54 * s);
    canvas.drawPath(hair, _hairShader(hairRect));
    canvas.drawPath(hair, outline);
    canvas.drawPath(
      _hairHighlightPath(cx, s),
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );

    final faceLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF302440);
    canvas.drawLine(
      Offset(cx + 14 * s, 58 * s),
      Offset(cx + 22 * s, 58 * s),
      faceLine,
    );
    canvas.drawLine(
      Offset(cx + 27 * s, 70 * s),
      Offset(cx + 33 * s, 69 * s),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4 * s
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFC8779A).withValues(alpha: 0.72),
    );
  }

  Path _sideHairPath(double cx, double s) {
    return Path()
      ..moveTo(cx - 27 * s, 43 * s)
      ..cubicTo(cx - 31 * s, 18 * s, cx + 2 * s, 10 * s, cx + 29 * s, 20 * s)
      ..cubicTo(cx + 55 * s, 30 * s, cx + 38 * s, 56 * s, cx + 11 * s, 55 * s)
      ..cubicTo(cx + 4 * s, 74 * s, cx - 22 * s, 67 * s, cx - 27 * s, 43 * s)
      ..close();
  }

  Path _hairHighlightPath(double cx, double s) {
    return Path()
      ..moveTo(cx - 15 * s, 25 * s)
      ..cubicTo(cx - 1 * s, 16 * s, cx + 22 * s, 18 * s, cx + 31 * s, 31 * s)
      ..cubicTo(cx + 15 * s, 28 * s, cx + 1 * s, 31 * s, cx - 12 * s, 38 * s)
      ..close();
  }

  void _drawShoe(Canvas canvas, Offset foot, double rotation, double s) {
    canvas.save();
    canvas.translate(foot.dx, foot.dy);
    canvas.rotate(rotation);
    final shoe = Path()
      ..moveTo(-22 * s, -6 * s)
      ..quadraticBezierTo(-4 * s, -17 * s, 14 * s, -7 * s)
      ..quadraticBezierTo(29 * s, -1 * s, 27 * s, 8 * s)
      ..lineTo(-13 * s, 10 * s)
      ..quadraticBezierTo(-28 * s, 8 * s, -22 * s, -6 * s)
      ..close();
    canvas.drawPath(shoe, Paint()..color = const Color(0xFF6630DF));
    canvas.drawPath(shoe, _outline(2 * s));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(11 * s, 3 * s, 22 * s, 8 * s),
        Radius.circular(7 * s),
      ),
      Paint()..color = Colors.white,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WalkingPersonPainter oldDelegate) {
    return oldDelegate.motion != motion;
  }
}

class _StandingPersonPainter extends CustomPainter {
  const _StandingPersonPainter({required this.motion, required this.portrait});

  final double motion;
  final bool portrait;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 188;
    final cx = size.width * 0.52;
    final pulse = math.sin(motion * math.pi * 2);
    final outline = _outline(2.4 * s);

    if (!portrait) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, size.height * 0.94),
          width: size.width * 0.55,
          height: size.height * 0.07,
        ),
        Paint()
          ..shader =
              RadialGradient(
                colors: <Color>[
                  const Color(0xFFB8B0A9).withValues(alpha: 0.30),
                  const Color(0xFFB8B0A9).withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromCenter(
                  center: Offset(cx, size.height * 0.94),
                  width: size.width * 0.60,
                  height: size.height * 0.10,
                ),
              ),
      );
    }

    final faceRect = Rect.fromCenter(
      center: Offset(cx, 48 * s),
      width: 48 * s,
      height: 58 * s,
    );
    final neckRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, 78 * s),
        width: 18 * s,
        height: 25 * s,
      ),
      Radius.circular(9 * s),
    );
    canvas.drawRRect(neckRect, _skinShader(faceRect));
    canvas.drawOval(faceRect, _skinShader(faceRect));
    canvas.drawOval(faceRect, outline);

    final hair = _frontHairPath(cx, s);
    final hairRect = Rect.fromLTWH(cx - 34 * s, 5 * s, 72 * s, 56 * s);
    canvas.drawPath(hair, _hairShader(hairRect));
    canvas.drawPath(hair, outline);
    canvas.drawPath(
      _frontHairHighlight(cx, s),
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );

    final eyePaint = Paint()
      ..strokeWidth = 2.4 * s
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF272038);
    canvas.drawLine(
      Offset(cx - 15 * s, 48 * s),
      Offset(cx - 10 * s, 48 * s),
      eyePaint,
    );
    canvas.drawLine(
      Offset(cx + 11 * s, 48 * s),
      Offset(cx + 16 * s, 48 * s),
      eyePaint,
    );
    canvas.drawLine(
      Offset(cx - 5 * s, 63 * s),
      Offset(cx + 9 * s, 64 * s),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4 * s
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFC9789A).withValues(alpha: 0.70),
    );

    final bodyTop = 84 * s;
    final shirt = Path()
      ..moveTo(cx - 44 * s, bodyTop)
      ..cubicTo(
        cx - 68 * s,
        bodyTop + 37 * s,
        cx - 73 * s,
        bodyTop + 86 * s,
        cx - 54 * s,
        bodyTop + 128 * s,
      )
      ..quadraticBezierTo(cx, bodyTop + 152 * s, cx + 58 * s, bodyTop + 128 * s)
      ..cubicTo(
        cx + 73 * s,
        bodyTop + 86 * s,
        cx + 66 * s,
        bodyTop + 36 * s,
        cx + 42 * s,
        bodyTop,
      )
      ..quadraticBezierTo(cx, bodyTop + 16 * s, cx - 44 * s, bodyTop)
      ..close();
    canvas.drawPath(
      shirt,
      _shirtShader(Rect.fromLTWH(20 * s, 80 * s, 138 * s, 145 * s)),
    );
    canvas.drawPath(shirt, outline);
    canvas.drawLine(
      Offset(cx - 30 * s, bodyTop + 31 * s),
      Offset(cx - 36 * s, bodyTop + 108 * s),
      _fold(2 * s),
    );
    canvas.drawLine(
      Offset(cx + 31 * s, bodyTop + 35 * s),
      Offset(cx + 43 * s, bodyTop + 108 * s),
      _fold(2 * s),
    );

    if (portrait) {
      return;
    }

    final armPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 18 * s
      ..color = const Color(0xFF7896F8);
    final skin = Paint()..color = const Color(0xFFE6A0B8);
    canvas.drawLine(
      Offset(cx - 60 * s, bodyTop + 40 * s),
      Offset(cx - 72 * s, bodyTop + 126 * s + pulse * 3 * s),
      armPaint,
    );
    canvas.drawLine(
      Offset(cx + 60 * s, bodyTop + 40 * s),
      Offset(cx + 71 * s, bodyTop + 126 * s - pulse * 3 * s),
      armPaint,
    );
    canvas.drawCircle(
      Offset(cx - 72 * s, bodyTop + 138 * s + pulse * 3 * s),
      10 * s,
      skin,
    );
    canvas.drawCircle(
      Offset(cx + 71 * s, bodyTop + 138 * s - pulse * 3 * s),
      10 * s,
      skin,
    );

    final pants = Path()
      ..moveTo(cx - 44 * s, bodyTop + 137 * s)
      ..lineTo(cx + 44 * s, bodyTop + 137 * s)
      ..lineTo(cx + 35 * s, bodyTop + 254 * s)
      ..quadraticBezierTo(
        cx + 14 * s,
        bodyTop + 260 * s,
        cx + 6 * s,
        bodyTop + 171 * s,
      )
      ..quadraticBezierTo(
        cx - 12 * s,
        bodyTop + 258 * s,
        cx - 35 * s,
        bodyTop + 255 * s,
      )
      ..close();
    canvas.drawPath(
      pants,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFF4117C8), Color(0xFF2B149A)],
        ).createShader(Rect.fromLTWH(48 * s, 210 * s, 98 * s, 118 * s)),
    );
    canvas.drawPath(pants, outline);

    _drawFrontShoe(
      canvas,
      Rect.fromLTWH(cx - 45 * s, bodyTop + 249 * s, 45 * s, 21 * s),
      s,
    );
    _drawFrontShoe(
      canvas,
      Rect.fromLTWH(cx + 10 * s, bodyTop + 249 * s, 45 * s, 21 * s),
      s,
    );
  }

  Path _frontHairPath(double cx, double s) {
    return Path()
      ..moveTo(cx - 30 * s, 36 * s)
      ..cubicTo(cx - 39 * s, 10 * s, cx - 4 * s, 0, cx + 29 * s, 9 * s)
      ..cubicTo(cx + 45 * s, 15 * s, cx + 42 * s, 40 * s, cx + 19 * s, 41 * s)
      ..cubicTo(cx + 4 * s, 33 * s, cx - 6 * s, 37 * s, cx - 26 * s, 42 * s)
      ..close();
  }

  Path _frontHairHighlight(double cx, double s) {
    return Path()
      ..moveTo(cx - 18 * s, 18 * s)
      ..cubicTo(cx - 2 * s, 8 * s, cx + 23 * s, 13 * s, cx + 31 * s, 25 * s)
      ..cubicTo(cx + 10 * s, 20 * s, cx - 2 * s, 25 * s, cx - 18 * s, 36 * s)
      ..close();
  }

  void _drawFrontShoe(Canvas canvas, Rect rect, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10 * s)),
      Paint()..color = const Color(0xFF5E35D7),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left + rect.width * 0.48,
          rect.top + rect.height * 0.38,
          rect.width * 0.50,
          rect.height * 0.52,
        ),
        Radius.circular(10 * s),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10 * s)),
      _outline(1.8 * s),
    );
  }

  @override
  bool shouldRepaint(_StandingPersonPainter oldDelegate) {
    return oldDelegate.motion != motion || oldDelegate.portrait != portrait;
  }
}

class _ProfilePersonPainter extends CustomPainter {
  const _ProfilePersonPainter({required this.motion});

  final double motion;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      size.center(Offset.zero),
      size.shortestSide * 0.50,
      Paint()..color = const Color(0xFFF9F0EA),
    );
    canvas.save();
    canvas.translate(size.width * 0.12, size.height * 0.03);
    canvas.scale(size.width / 190, size.height / 190);
    _StandingPersonPainter(
      motion: motion,
      portrait: true,
    ).paint(canvas, const Size(188, 190));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ProfilePersonPainter oldDelegate) {
    return oldDelegate.motion != motion;
  }
}

class _ArticleThumbPainter extends CustomPainter {
  const _ArticleThumbPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF5D28D8),
            Color(0xFF852FEA),
            Color(0xFFF55EC4),
          ],
        ).createShader(rect),
    );
    final leftPage = Path()
      ..moveTo(size.width * 0.31, size.height * 0.22)
      ..lineTo(size.width * 0.50, size.height * 0.34)
      ..lineTo(size.width * 0.50, size.height * 0.82)
      ..lineTo(size.width * 0.31, size.height * 0.70)
      ..close();
    final rightPage = Path()
      ..moveTo(size.width * 0.51, size.height * 0.34)
      ..lineTo(size.width * 0.68, size.height * 0.22)
      ..lineTo(size.width * 0.68, size.height * 0.70)
      ..lineTo(size.width * 0.51, size.height * 0.82)
      ..close();
    canvas.drawPath(
      leftPage,
      Paint()..color = const Color(0xFFF2CFE5).withValues(alpha: 0.90),
    );
    canvas.drawPath(rightPage, Paint()..color = const Color(0xFFF7DBEA));
    canvas.drawCircle(
      Offset(size.width * 0.76, size.height * 0.55),
      size.width * 0.10,
      Paint()..color = const Color(0xFFFCE4F0),
    );
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.73),
      size.width * 0.28,
      Paint()..color = const Color(0xFFF5C3D9).withValues(alpha: 0.84),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MiniMapPainter extends CustomPainter {
  const _MiniMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF4568F3),
            Color(0xFF4866EA),
            Color(0xFF6E8FFF),
          ],
        ).createShader(rect),
    );

    final road = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.6
      ..color = Colors.white.withValues(alpha: 0.26);
    for (var i = 0; i < 4; i++) {
      final dx = size.width * (0.15 + i * 0.24);
      canvas.drawLine(
        Offset(dx, 0),
        Offset(dx - size.width * 0.22, size.height),
        road,
      );
    }
    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.25 + i * 0.24);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y - size.height * 0.22),
        road,
      );
    }

    final route = Path()
      ..moveTo(size.width * 0.18, size.height * 0.78)
      ..cubicTo(
        size.width * 0.32,
        size.height * 0.48,
        size.width * 0.53,
        size.height * 0.62,
        size.width * 0.59,
        size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.08,
        size.width * 0.83,
        size.height * 0.22,
        size.width * 0.89,
        size.height * 0.10,
      );
    canvas.drawPath(
      route,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3.4
        ..color = const Color(0xFFA5EFE2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

double _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}

Paint _outline(double width) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = width
    ..color = const Color(0xFF332B66).withValues(alpha: 0.72);
}

Paint _highlight(double width) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = width
    ..color = const Color(0xFF6C55FF).withValues(alpha: 0.54);
}

Paint _handLine(double scale) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.3 * scale
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFF7D496A).withValues(alpha: 0.55);
}

Paint _fold(double width) {
  return Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..color = const Color(0xFF3442B6).withValues(alpha: 0.28);
}

Paint _skinShader(Rect rect) {
  return Paint()
    ..shader = RadialGradient(
      center: const Alignment(0.18, -0.24),
      colors: const <Color>[
        Color(0xFFF8C5CF),
        Color(0xFFE7A4BA),
        Color(0xFFD28CA8),
      ],
    ).createShader(rect.inflate(rect.width * 0.40));
}

Paint _hairShader(Rect rect) {
  return Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color(0xFF66F6F1), Color(0xFF34B4EA), Color(0xFF4D5EDA)],
    ).createShader(rect);
}

Paint _shirtShader(Rect rect) {
  return Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color(0xFFA6D2FF), Color(0xFF7D93FA), Color(0xFF5E62E5)],
    ).createShader(rect);
}
