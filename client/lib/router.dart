import 'package:go_router/go_router.dart';
import './screens/ListScreen.dart';
import './screens/SentenceScreen.dart';
import './screens/TagScreen.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/list',
  routes: [
    GoRoute(
      name: 'List',
      path: '/list',
      builder: (context, state) => const ListScreen()
    ),
    GoRoute(
      name: 'Sentence',
      path: '/sentence/:sentenceID([0-9]+)',
      builder: (context, state) => SentenceScreen(
        sentenceID: state.pathParameters['sentenceID']!
      ),
    ),
    GoRoute(
      name: 'Tag',
      path: '/tag',
      builder: (context, state) => const TagScreen()
    ),
  ],
);