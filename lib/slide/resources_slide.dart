import 'package:animated_to/animated_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_youtrust_lt/widget/my_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResourcesSlide extends FlutterDeckSlideWidget {
  const ResourcesSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/resources',
          title: 'あわせて見ておきたい',
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

class _Slide extends StatelessWidget {
  const _Slide();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: AppLocalizations.of(context)!.resourceTitle),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            _Resource(
              title: 'All I Know about AnimationController',
              url:
                  'https://chooyan.hashnode.dev/all-i-know-about-animationcontroller',
              index: 0,
            ),
            _Resource(
              title: AppLocalizations.of(context)!.resourcesAnimatedTo,
              url: 'https://pub.dev/packages/animated_to',
              index: 1,
            ),
            _Resource(
              title: AppLocalizations.of(context)!.resourcesSpringster,
              url: 'https://pub.dev/packages/springster',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Resource extends StatelessWidget {
  const _Resource({
    required this.title,
    required this.url,
    required this.index,
  });

  final String title;
  final String url;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedTo.spring(
      globalKey: GlobalKey(),
      slidingFrom: Offset(0, 100 + index * 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(title, style: FlutterDeckTheme.of(context).textTheme.bodyLarge),
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(url)),
            child: Text(
              url,
              style: FlutterDeckTheme.of(
                context,
              ).textTheme.bodySmall.copyWith(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
