import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_youtrust_lt/slide/all_physics_demo_slide.dart';
import 'package:flutter_youtrust_lt/slide/animation_controller_slide.dart';
import 'package:flutter_youtrust_lt/slide/basics_animation_slide.dart';
import 'package:flutter_youtrust_lt/slide/basics_slide.dart';
import 'package:flutter_youtrust_lt/slide/curve_animations_slide.dart';
import 'package:flutter_youtrust_lt/slide/physics_animations_demo_slide.dart';
import 'package:flutter_youtrust_lt/slide/physics_animations_description_slide.dart';
import 'package:flutter_youtrust_lt/slide/physics_animations_slide.dart';
import 'package:flutter_youtrust_lt/slide/resources_slide.dart';
import 'package:flutter_youtrust_lt/slide/title_slide.dart';
import 'package:flutter_youtrust_lt/slide/velocity_page.dart';
import 'package:flutter_youtrust_lt/slide/wrap_up_slide.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      themeMode: ThemeMode.dark,
      darkTheme: FlutterDeckThemeData.dark().copyWith(
        textTheme: const FlutterDeckTextTheme(
          title: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          subtitle: TextStyle(fontSize: 16),
          header: TextStyle(fontSize: 32),
          bodyMedium: TextStyle(fontSize: 32),
          bodySmall: TextStyle(fontSize: 24),
          bodyLarge: TextStyle(fontSize: 40),
          display: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ja')],

      configuration: const FlutterDeckConfiguration(),
      slides: [
        const TitleSlide(),
        const AnimationControllerSlide(),
        const BasicsSlide(),
        const BasicsAnimationSlide(),
        const CurveAnimationsSlide(),
        const PhysicsAnimationsSlide(),
        const PhysicsAnimationsDescriptionSlide(),
        const VelocityPage(),
        const PhysicsAnimationsDemoSlide(),
        const AllPhysicsDemoSlide(),
        const WrapUpSlide(),
        const ResourcesSlide(),
      ],
    );
  }
}
