import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.child});
  final Widget child;
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  bool reduced = false, done = false;
  final Set<int> hits = <int>{};
  static const symbols = <String>['₪', r'$', '€', '£', '¥', '₹'];
  static const starts = <double>[.04, .12, .20, .28, .36, .44];
  static const landingX = <double>[-85, -60, -25, 25, 60, 85];
  static const landingY = <double>[-20, -67, -86, -86, -67, -20];
  double _safe(double value) => math.min(1.0, math.max(0.0, value));

  @override void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2650))..addListener(_tick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      reduced = MediaQuery.of(context).disableAnimations;
      if (reduced) setState(() => done = true); else controller.forward();
    });
  }
  void _tick() {
    if (controller.value >= 1 && !done && mounted) setState(() => done = true);
  }
  @override void dispose() { controller.removeListener(_tick); controller.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    if (done) return widget.child;
    final theme = Theme.of(context), accent = theme.colorScheme.primary;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(child: AnimatedBuilder(animation: controller, builder: (_, __) => Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(width: 220, height: 190, child: Stack(alignment: Alignment.center, clipBehavior: Clip.none, children: [_icon(accent), ...List.generate(symbols.length, (i) => _coin(i, accent))])),
        const SizedBox(height: 16), _name(theme), const SizedBox(height: 12), _line(accent),
      ]))),
    );
  }

  Widget _icon(Color accent) {
    final p = Curves.easeOutBack.transform(_safe(controller.value / .24));
    return Transform.scale(scale: reduced ? 1.0 : p, child: Container(width: 112, height: 112, decoration: BoxDecoration(shape: BoxShape.circle, color: accent, boxShadow: [BoxShadow(color: accent.withOpacity(.28), blurRadius: 24)]), child: const Icon(Icons.auto_awesome, color: Colors.white, size: 58)));
  }
  Widget _coin(int i, Color accent) {
    final q = _safe((controller.value - starts[i]) / .40);
    if (controller.value < starts[i]) return const SizedBox.shrink();
    if (q >= .80 && hits.add(i)) HapticFeedback.lightImpact();
    final offset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -220.0, end: 0.0).chain(CurveTween(curve: Curves.easeInSine)), weight: 80),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 4),
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -16.0).chain(CurveTween(curve: Curves.easeOut)), weight: 7),
      TweenSequenceItem(tween: Tween(begin: -16.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)), weight: 9),
    ]).transform(q);
    final squash = q >= .80 && q < .84;
    return Positioned(left: 110 + landingX[i] - 18, top: 95 + landingY[i] + offset - 18, child: Transform(alignment: Alignment.center, transform: Matrix4.diagonal3Values(squash ? 1.16 : 1.0, squash ? .78 : 1.0, 1.0), child: Container(width: 36, height: 36, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withOpacity(.13), border: Border.all(color: accent.withOpacity(.55))), child: Text(symbols[i], style: TextStyle(fontWeight: FontWeight.w700, color: accent, fontSize: 18)))));
  }
  Widget _name(ThemeData theme) {
    const text = 'IncomePulse';
    final r = ((controller.value - .24) / .18).clamp(0.0, 1.0);
    final h = ((controller.value - .52) / .14).clamp(0.0, 1.0);
    final p = ((controller.value - .68) / .1).clamp(0.0, 1.0);
    final word = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(text.length, (i) {
          final q = reduced ? 1.0 : ((r - i * .055) / .12).clamp(0.0, 1.0);
          return Opacity(
            opacity: q,
            child: Transform.translate(
              offset: Offset(0, 8 * (1 - q)),
              child: Text(
                text[i],
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.8 - .3 * h,
                  shadows: [
                    Shadow(color: theme.colorScheme.primary.withOpacity(.42), blurRadius: 12),
                    Shadow(color: theme.colorScheme.primary.withOpacity(.22), blurRadius: 24),
                  ],
                ),
              ),
            ),
          );
        }),
    );
    return Transform.scale(
      scale: reduced ? 1.0 : 1 + .03 * math.sin(p * math.pi),
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.secondary, theme.colorScheme.primary, theme.colorScheme.secondary, theme.colorScheme.primary],
          stops: [0.0, (h - .18).clamp(0.0, 1.0), h, (h + .18).clamp(0.0, 1.0)],
        ).createShader(bounds),
        child: word,
      ),
    );
  }
  Widget _line(Color accent) { final p = reduced ? 1.0 : ((controller.value - .62) / .12).clamp(0.0, 1.0); return SizedBox(width: 112 * p, child: Divider(color: accent, thickness: 3, height: 3)); }
}
