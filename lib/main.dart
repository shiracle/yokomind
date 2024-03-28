import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yoko_mind/screens/public/auth.dart';
import 'package:yoko_mind/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/public/appState.dart';

void main() async {
  // await Hive.initFlutter();
  runApp(MyApp());
}

final String UrlBase = "http://yokomine.metasoft.mn";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('mn'),
        ],
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const AuthPage(),
        title: (''),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => const AuthPage(),
          // Dun.routeName: (_) => Dun(),
          // Irts.routeName: (_) => Irts(),
          // Plan.routeName: (_) => Plan(),

          // MyHomePage.routeName: (_) => MyHomePage(),
        },
      ),
    );
  }
}
