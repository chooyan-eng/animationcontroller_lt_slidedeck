import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:springster/springster.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllPhysicsDemoSlide extends FlutterDeckSlideWidget {
  const AllPhysicsDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/all-physics-demo',
          title: '物理アニメーションいろいろ',
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

  double _valueX = 200;
  double _valueY = 200;

  bool _isSpring = false;

  @override
  void initState() {
    super.initState();

    /// [AnimationController] for x axis
    _controllerX = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _valueX = _controllerX.value;
      });

      if (_isSpring) {
        return;
      }

      final rightBound = MediaQuery.of(context).size.width;
      if (_valueX > rightBound * 2 / 3) {
        _isSpring = true;
        final xVelocity = _controllerX.velocity;
        final yVelocity = _controllerY.velocity;

        _controllerX.stop();
        _controllerY.stop();

        _controllerX.animateWith(
          SpringSimulation(
            Spring.bouncy,
            _valueX,
            rightBound - 170 - (_boxSize / 2),
            xVelocity,
          ),
        );
        _controllerY.animateWith(
          SpringSimulation(
            Spring.bouncy,
            _valueY,
            170 - (_boxSize / 2),
            yVelocity,
          ),
        );
      }
    });

    /// [AnimationController] for y axis
    _controllerY = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _valueY = _controllerY.value;

        if (_isSpring) {
          return;
        }

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
        title: AppLocalizations.of(context)!.allPhysicsDemoTitle,
        subtitle: AppLocalizations.of(context)!.allPhysicsDemoSubtitle,
      ),
      body: GestureDetector(
        onPanStart: (details) {
          _controllerX.stop();
          _controllerY.stop();
          _isSpring = false;
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
              top: 0,
              bottom: 0,
              left: MediaQuery.of(context).size.width / 3 * 2,
              right: 0,
              child: Container(color: Colors.grey[900]),
            ),
            Positioned(
              right: 120,
              top: 120,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
