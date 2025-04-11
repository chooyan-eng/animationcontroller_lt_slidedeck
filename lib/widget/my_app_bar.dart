import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(title, style: FlutterDeckTheme.of(context).textTheme.title),
          if (subtitle != null)
            Text(
              subtitle!,
              style: FlutterDeckTheme.of(
                context,
              ).textTheme.bodySmall.copyWith(color: Colors.white70),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
