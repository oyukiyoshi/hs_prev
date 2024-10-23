import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'riverpod/RightNavigationRailSelectedIndex.dart';
import 'package:go_router/go_router.dart';
import '../const.dart';

class RightNavigationRail extends ConsumerWidget {
  final int selectedIndexI;
  const RightNavigationRail({super.key, required this.selectedIndexI});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuSelectedIndex = ref.watch(rightNavigationRailSelectedIndexNotifierProvider);
    
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: NavigationRail(
          selectedIndex: selectedIndexI != 0 ? selectedIndexI : menuSelectedIndex,
          extended: constraints.maxWidth >= extendWidth,
          onDestinationSelected: (value) {
            ref.read(rightNavigationRailSelectedIndexNotifierProvider.notifier).updateState(value);
            switch (value) {
              case 0:
                context.go('/list');
                break;
              case 1:
                context.go('/tag');
                break;
            }
          },
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.article),
              label: Text(
                'Sentences',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.tag),
              label: Text(
                'Tags',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
      );
    });
  }
}