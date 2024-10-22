import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'riverpod/RightNavigationRailSelectedIndex.dart';
import 'package:go_router/go_router.dart';
import '../const.dart';

class RightNavigationRail extends ConsumerWidget {
  const RightNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuSelectedIndex = ref.watch(rightNavigationRailSelectedIndexNotifierProvider);
    
    return LayoutBuilder(builder: (context, constraints) {
      return Center(
        child: NavigationRail(
          selectedIndex: menuSelectedIndex,
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
              label: Text('Sentences'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.tag),
              label: Text('Tags'),
            ),
          ],
        ),
      );
    });
  }
}