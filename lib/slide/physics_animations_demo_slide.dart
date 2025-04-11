import 'package:animated_to/animated_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _boxSize = 60.0;

class PhysicsAnimationsDemoSlide extends FlutterDeckSlideWidget {
  const PhysicsAnimationsDemoSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/physics-animations-demo',
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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1000),
            upperBound: 1.6,
          )
          ..addListener(() {
            setState(() {});
          })
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.physicsAnimationsDemoTitle,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: (_controller.value).clamp(0.0, 1.0),
              child: Container(
                margin: const EdgeInsets.all(16),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _GravityDemo(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: (_controller.value - 0.3).clamp(0.0, 1.0),
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _FrictionDemo(),
                    ),
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: (_controller.value - 0.6).clamp(0.0, 1.0),
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _SpringDemo(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GravityDemo extends StatefulWidget {
  const _GravityDemo();

  @override
  State<_GravityDemo> createState() => _GravityDemoState();
}

class _GravityDemoState extends State<_GravityDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  double _value = 200;
  late double _ground;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _value = _controller.value;
      });

      if (_value > _ground) {
        // box now touches the ground

        // retrieve the velocity of slightly weaker to opposite(upper) direction
        final velocity = _controller.velocity * -1 * 0.7;

        // stop previous animation
        _controller.stop();

        // start new animation
        _controller.animateWith(
          GravitySimulation(2000, _ground, double.infinity, velocity),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _ground = constraints.maxHeight - _boxSize;
        return GestureDetector(
          onPanStart: (details) => _controller.stop(),
          // grab and move the box
          onPanUpdate: (details) {
            setState(() {
              _value = details.localPosition.dy - _boxSize / 2;
            });
          },
          // slide the ball
          onPanEnd: (details) {
            _controller.animateWith(
              GravitySimulation(
                2000,
                _value,
                double.infinity,
                details.velocity.pixelsPerSecond.dy,
              ),
            );
          },
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 32,
                child: Center(
                  child: Text(
                    'Gravity',
                    style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 2 - _boxSize / 2,
                top: _value,
                child: Container(
                  width: _boxSize,
                  height: _boxSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FrictionDemo extends StatefulWidget {
  const _FrictionDemo();

  @override
  State<_FrictionDemo> createState() => _FrictionDemoState();
}

class _FrictionDemoState extends State<_FrictionDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  double _value = 200;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _value = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanStart: (details) => _controller.stop(),
          // grab and move the box
          onPanUpdate: (details) {
            setState(() {
              _value = details.localPosition.dx - _boxSize / 2;
            });
          },
          // slide the ball
          onPanEnd: (details) {
            _controller.animateWith(
              FrictionSimulation(
                0.5,
                _value,
                details.velocity.pixelsPerSecond.dx,
              ),
            );
          },
          child: Stack(
            children: [
              Positioned(
                left: 32,
                top: 32,
                child: Center(
                  child: Text(
                    'Friction',
                    style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              Positioned(
                top: constraints.maxHeight / 2 - _boxSize / 2 + 32,
                left: _value,
                child: Container(
                  width: _boxSize,
                  height: _boxSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SpringDemo extends StatefulWidget {
  const _SpringDemo();

  @override
  State<_SpringDemo> createState() => _SpringDemoState();
}

class _SpringDemoState extends State<_SpringDemo> {
  bool _isLeft = true;

  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: IconButton(
                iconSize: 40,
                onPressed: () {
                  setState(() => _isLeft = !_isLeft);
                },
                icon: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  width: 60,
                  height: 60,
                  child: Icon(
                    _isLeft ? Icons.arrow_forward : Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Spring',
                style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
              ),
              Expanded(
                child: Align(
                  alignment:
                      _isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  child: AnimatedTo.spring(
                    globalKey: _key,
                    child: Container(
                      width: _boxSize,
                      height: _boxSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
