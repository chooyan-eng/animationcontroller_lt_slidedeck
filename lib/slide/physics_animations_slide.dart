import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhysicsAnimationsSlide extends FlutterDeckSlideWidget {
  const PhysicsAnimationsSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/physics-animations-slide',
          title: '物理アニメーション',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.custom(
      builder: (context) {
        return const _Slide();
      },
    );
  }
}

class _Slide extends StatefulWidget {
  const _Slide();

  @override
  State<_Slide> createState() => _SlideState();
}

class _SlideState extends State<_Slide> with TickerProviderStateMixin {
  late final AnimationController _controllerX;
  late final AnimationController _controllerY;

  final _boxSize = 60.0;

  double _valueX = 600;
  double _valueY = 400;

  @override
  void initState() {
    super.initState();

    /// [AnimationController] for x axis
    _controllerX = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _valueX = _controllerX.value;
      });
    });

    /// [AnimationController] for y axis
    _controllerY = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _valueY = _controllerY.value;
        final ground = MediaQuery.of(context).size.height - _boxSize;

        if (_valueY > ground) {
          // box now touches the ground

          // retrieve the velocity of slightly weaker to opposite(upper) direction
          final velocity = _controllerY.velocity * -1 * 0.7;

          // stop previous animation
          _controllerY.stop();

          // start new animation
          _controllerY.animateWith(
            GravitySimulation(2000, ground, double.infinity, velocity),
          );
        }
      });
    });
  }

  void _startFriction(Offset initialPosition, Offset velocity) {
    // start animation for x axis
    _controllerX.animateWith(
      FrictionSimulation(0.5, initialPosition.dx, velocity.dx),
    );

    /// simulate y-axis with [GravitySimulation] with previous bouncing logic
    _controllerY.animateWith(
      GravitySimulation(2000, initialPosition.dy, double.infinity, velocity.dy),
    );
  }

  @override
  void dispose() {
    _controllerX.dispose();
    _controllerY.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.physicsAnimationsTitle,
        subtitle: AppLocalizations.of(context)!.physicsAnimationsSubtitle,
      ),
      body: GestureDetector(
        onPanStart: (details) {
          _controllerX.stop();
          _controllerY.stop();
        },
        // grab and move the box
        onPanUpdate: (details) {
          setState(() {
            _valueX = details.globalPosition.dx - _boxSize / 2;
            _valueY = details.globalPosition.dy - _boxSize / 2;
          });
        },
        // slide the ball
        onPanEnd: (details) {
          _startFriction(
            Offset(_valueX, _valueY),
            details
                .velocity
                .pixelsPerSecond, // velocity exposed by GestureDetector
          );
        },
        child: Stack(
          children: [
            Positioned(
              top: _valueY,
              left: _valueX,
              child: Container(
                width: _boxSize,
                height: _boxSize,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 140,
              left: 32,
              child: Text(
                'X: $_valueX',
                style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
              ),
            ),
            Positioned(
              top: 184,
              left: 32,
              child: Text(
                'Y: $_valueY',
                style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
