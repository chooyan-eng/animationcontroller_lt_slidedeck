import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:flutter_youtrust_lt/widget/play_button.dart';

class BasicsAnimationSlide extends FlutterDeckSlideWidget {
  const BasicsAnimationSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/basics-animation-slide',
          title: 'AnimationController を使ったアニメーション',
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

class _SlideState extends State<_Slide> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.basicsAnimationTitle,
        subtitle: AppLocalizations.of(context)!.basicsAnimationSubtitle,
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            '${_animationController.value}',
            style: FlutterDeckTheme.of(context).textTheme.display,
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 100,
                width: 1000,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 100,
                    width: _animationController.value * 1000,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          PlayButton(
            isPlaying: _animationController.isAnimating,
            onPressed: (value) {
              if (_animationController.isAnimating) {
                _animationController.stop();
              } else {
                _animationController.reset();
                _animationController.forward();
              }
              setState(() {});
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
