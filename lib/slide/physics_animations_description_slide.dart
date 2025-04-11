import 'package:animated_to/animated_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';

class PhysicsAnimationsDescriptionSlide extends FlutterDeckSlideWidget {
  const PhysicsAnimationsDescriptionSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/physics-animations-description-slide',
          title: '物理アニメーションの説明',
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
            duration: const Duration(milliseconds: 500),
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
        title: AppLocalizations.of(context)!.physicsAnimationsDescriptionTitle,
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTo.spring(
                    globalKey: GlobalObjectKey('1-1'),
                    slidingFrom: Offset(0, 80),
                    child: Text(
                      AppLocalizations.of(context)!.physicsAnimationsGravity,
                      style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedTo.spring(
                    globalKey: GlobalObjectKey('1-2'),
                    slidingFrom: Offset(0, 120),
                    child: Text(
                      AppLocalizations.of(context)!.physicsAnimationsFriction,
                      style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedTo.spring(
                    globalKey: GlobalObjectKey('1-3'),
                    slidingFrom: Offset(0, 160),
                    child: Text(
                      AppLocalizations.of(context)!.physicsAnimationsSpring,
                      style: FlutterDeckTheme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Opacity(
            opacity: _controller.value,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: IntrinsicWidth(
                child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'final controller = AnimationController',
                          ),
                          TextSpan(
                            text: '.unbounded',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: '(vsync: this);'),
                        ],
                      ),
                      style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'controller.'),
                          TextSpan(
                            text: 'animateWith',
                            style: TextStyle(color: Colors.blue),
                          ),
                          TextSpan(text: '('),
                        ],
                      ),
                      style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
                    ),
                    Text.rich(
                      TextSpan(
                        text: '  GravitySimulation(2000, 0, 1000, 1000),',
                      ),
                      style: FlutterDeckTheme.of(
                        context,
                      ).textTheme.bodyMedium.copyWith(color: Colors.green),
                    ),
                    Text.rich(
                      TextSpan(text: ');'),
                      style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
