import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class Firework extends StatefulWidget {
  const Firework({super.key, required this.initialPosition});

  final Offset initialPosition;

  @override
  State<Firework> createState() => _FireworkState();
}

class _FireworkState extends State<Firework> with TickerProviderStateMixin {
  AnimationController? _controller;

  double get _x => widget.initialPosition.dx;
  late double _y = widget.initialPosition.dy;

  List<Offset> _shadows = [];
  List<({double xVelocity, double yVelocity, Color color})> _bursteds = [];

  /// Generates a random base color for the firework
  Color _getRandomFireworkBaseColor() {
    const colors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.yellow,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.green,
      Colors.cyan,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  /// Creates a variation of the base color to look more natural
  Color _getColorVariation(Color baseColor) {
    // Create a slight variation of the base color
    final hslColor = HSLColor.fromColor(baseColor);
    return hslColor
        .withLightness(
          (hslColor.lightness + Random().nextDouble() * 0.3).clamp(0.2, 0.9),
        )
        .withSaturation(
          (hslColor.saturation + Random().nextDouble() * 0.2 - 0.1).clamp(
            0.7,
            1.0,
          ),
        )
        .toColor();
  }

  void _fire() {
    if (_controller != null) return;
    _controller = AnimationController.unbounded(vsync: this);
    _controller!.addListener(() {
      setState(() {
        _y = _controller!.value;
        _shadows = [Offset(_x, _y), ..._shadows].take(16).toList();
      });
      if (_controller!.velocity > -10) {
        _controller!.stop();

        final baseColor = _getRandomFireworkBaseColor();
        _bursteds = List.generate(16, (_) {
          final angle = Random().nextDouble() * 2 * pi;
          final velocity =
              200 +
              Random().nextDouble() * 400; // Random velocity between 400-800
          return (
            xVelocity: cos(angle) * velocity + Random().nextDouble() * 100 - 50,
            yVelocity: sin(angle) * velocity + Random().nextDouble() * 100 - 50,
            color: _getColorVariation(baseColor),
          );
        });
        _shadows = [];
      }
    });
    _controller!.animateWith(
      FrictionSimulation(0.2, widget.initialPosition.dy, -800),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _fire();
        });
        return Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
            ..._shadows.map(
              (e) => Positioned(
                left: e.dx,
                top: e.dy,
                child: Opacity(
                  opacity: 0.03 * (_shadows.length - _shadows.indexOf(e)),
                  child: _Ball(color: Color(0xFFFFA500)),
                ),
              ),
            ),
            if (_bursteds.isEmpty)
              Positioned(
                left: _x,
                top: _y,
                child: _Ball(
                  color: Color(0xFFFFA500),
                ), // Bright orange like a fire
              ),
            ..._bursteds.map(
              (e) => _Bursted(
                initialPosition: Offset(_x, _y),
                xVelocity: e.xVelocity,
                yVelocity: e.yVelocity,
                color: e.color,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Bursted extends StatefulWidget {
  const _Bursted({
    required this.initialPosition,
    required this.xVelocity,
    required this.yVelocity,
    required this.color,
  });

  final Offset initialPosition;
  final double xVelocity;
  final double yVelocity;
  final Color color;

  @override
  State<_Bursted> createState() => _BurstedState();
}

class _BurstedState extends State<_Bursted> with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late AnimationController opacityController;

  late double _x = widget.initialPosition.dx;
  late double _y = widget.initialPosition.dy;

  List<Offset> _shadows = [];

  @override
  void initState() {
    super.initState();
    xController = AnimationController.unbounded(vsync: this);
    yController = AnimationController.unbounded(vsync: this);
    opacityController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
      setState(() {});
    });

    xController.addListener(() {
      setState(() {
        _x = xController.value;
        if (opacityController.status == AnimationStatus.completed) {
          if (_shadows.isNotEmpty) {
            _shadows = [..._shadows]..removeLast();
          }
        } else {
          _shadows = [Offset(_x, _y), ..._shadows].take(16).toList();
        }
      });
    });
    yController.addListener(() {
      setState(() {
        _y = yController.value;
        if (opacityController.status == AnimationStatus.completed) {
          if (_shadows.isNotEmpty) {
            _shadows = [..._shadows]..removeLast();
          }
        } else {
          _shadows = [Offset(_x, _y), ..._shadows].take(16).toList();
        }
      });
    });

    xController.animateWith(
      FrictionSimulation(0.2, widget.initialPosition.dx, widget.xVelocity),
    );
    yController.animateWith(
      GravitySimulation(
        50,
        widget.initialPosition.dy,
        widget.initialPosition.dy + 1000,
        widget.yVelocity,
      ),
    );
    opacityController.forward();
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(),
        ..._shadows.map(
          (e) => Positioned(
            left: e.dx,
            top: e.dy,
            child: Opacity(
              opacity: 0.03 * (_shadows.length - _shadows.indexOf(e)),
              child: _Ball(color: widget.color),
            ),
          ),
        ),
        Positioned(
          left: _x,
          top: _y,
          child: Opacity(
            opacity: max(0.0, 1.0 - opacityController.value),
            child: _Ball(color: widget.color),
          ),
        ),
      ],
    );
  }
}

class _Ball extends StatelessWidget {
  const _Ball({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(100),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
