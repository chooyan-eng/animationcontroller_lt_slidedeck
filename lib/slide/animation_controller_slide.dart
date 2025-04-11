import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnimationControllerSlide extends FlutterDeckSlideWidget {
  const AnimationControllerSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/animation-controller',
          header: FlutterDeckHeaderConfiguration(
            title: 'ちゅーやん＠YOUTRUST x Omiai Flutter LT会',
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: AppLocalizations.of(context)!.presentationTitle,
      theme: FlutterDeckTheme.of(context).copyWith(
        bigFactSlideTheme: const FlutterDeckBigFactSlideThemeData(
          titleTextStyle: TextStyle(color: Colors.amber),
        ),
      ),
    );
  }
}
