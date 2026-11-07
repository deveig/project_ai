import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/view_models/widgets/garden_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                GardenScreen(title: 'Welcome to your garden'),
          ),
        ],
      ),
    );
  }
}
