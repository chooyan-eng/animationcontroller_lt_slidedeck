import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:flutter_youtrust_lt/widget/play_button.dart';

class BasicsSlide extends FlutterDeckSlideWidget {
  const BasicsSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/basics-slide',
          title: 'AnimationController の基本',
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
        title: AppLocalizations.of(context)!.basicsTitle,
        subtitle: AppLocalizations.of(context)!.basicsSubtitle,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '${_animationController.value}',
                style: FlutterDeckTheme.of(context).textTheme.display,
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
