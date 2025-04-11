import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_youtrust_lt/animation/firework.dart';

class TitleSlide extends FlutterDeckSlideWidget {
  const TitleSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/title-slide',
          title: 'Title Slide',
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

class _SlideState extends State<_Slide> {
  final List<Offset> _fireworks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          setState(() => _fireworks.add(details.localPosition - Offset(4, 4)));
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [..._fireworks.map((e) => Firework(initialPosition: e))],
          ),
        ),
      ),
    );
  }
}
