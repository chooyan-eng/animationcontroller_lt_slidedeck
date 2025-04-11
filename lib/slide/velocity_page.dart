import 'package:animated_to/animated_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VelocityPage extends FlutterDeckSlideWidget {
  const VelocityPage({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/velocity-page',
          title: 'Velocity',
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

  final _boxSize = 60.0;
  double _value = 200;
  double? _velocity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)..addListener(() {
      setState(() {
        _value = _controller.value;
      });
      final ground = MediaQuery.of(context).size.height - _boxSize;

      if (_value > ground) {
        // box now touches the ground

        // retrieve the velocity of slightly weaker to opposite(upper) direction
        final velocity = _controller.velocity * -1 * 0.7;

        // stop previous animation
        _controller.stop();

        // start new animation
        _controller.animateWith(
          GravitySimulation(2000, ground, double.infinity, velocity),
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
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.velocityTitle),
      extendBodyBehindAppBar: true,

      body: DefaultTextStyle(
        style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.velocityLabel,
                        style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      AnimatedTo.spring(
                        globalKey: GlobalObjectKey('2-1'),
                        slidingFrom: Offset(0, 80),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.velocityDescriptionItem1,
                        ),
                      ),
                      AnimatedTo.spring(
                        globalKey: GlobalObjectKey('2-2'),
                        slidingFrom: Offset(0, 120),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.velocityDescriptionItem2,
                        ),
                      ),
                      AnimatedTo.spring(
                        globalKey: GlobalObjectKey('2-3'),
                        slidingFrom: Offset(0, 160),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.velocityDescriptionItem3,
                        ),
                      ),
                      AnimatedTo.spring(
                        globalKey: GlobalObjectKey('2-4'),
                        slidingFrom: Offset(0, 200),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.velocityDescriptionItem4,
                        ),
                      ),
                      AnimatedTo.spring(
                        globalKey: GlobalObjectKey('2-5'),
                        slidingFrom: Offset(0, 200),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.velocityDescriptionItem5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onPanStart: (details) => _controller.stop(),
                    // grab and move the box
                    onPanUpdate: (details) {
                      setState(() {
                        _value = details.globalPosition.dy - _boxSize / 2;
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
                      setState(() {
                        _velocity = details.velocity.pixelsPerSecond.dy;
                      });
                    },
                    child: Stack(
                      children: [
                        Positioned(
                          right: 32,
                          top: 160,
                          child: Text('Velocity: ${_velocity ?? "-"}'),
                        ),
                        Positioned(
                          left: constraints.maxWidth / 2,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
