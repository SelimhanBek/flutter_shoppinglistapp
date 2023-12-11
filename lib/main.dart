import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppinglistapp/layout/screen.dart';
import 'package:shoppinglistapp/theme/theme.dart';

void main() {
  /* Be sure init */
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /* Providers */
    final currentThemeMode = ref.watch(themeProvider);

    /* Disable screen rotation */
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Shopping List App',
      themeMode: currentThemeMode,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      home: const ResponsiveLayout(),
    );
  }
}
