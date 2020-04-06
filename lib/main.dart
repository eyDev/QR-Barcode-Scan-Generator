import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qrreaderapp/src/pages/principal_page.dart';
import 'package:qrreaderapp/src/pages/qrgen_page.dart';
import 'package:provider/provider.dart';
import 'package:qrreaderapp/src/providers/theme_changer.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:qrreaderapp/src/shared_prefs/preferencias.dart';
import 'package:easy_localization/easy_localization.dart';

const String testDevice = 'ca-app-pub-2124163203185830~9084360671';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [
      Locale('en'),
      Locale('es'),
      Locale('fr'),
      Locale('de'),
      Locale('it'),
    ],
    useOnlyLangCode: true,
    path: 'assets/langs',
  ));
}

class MyApp extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: MaterialAppWithTheme(),
      create: (_) => ThemeChanger(
        ThemeData(
          brightness: prefs.darkMode ? Brightness.dark : Brightness.light,
          primaryColor: prefs.primaryColor,
        ),
        FFNavigationBarTheme(
          barBackgroundColor: prefs.darkMode ? Colors.black12 : Colors.white,
          selectedItemBorderColor:
              prefs.darkMode ? Colors.black12 : Colors.white,
          selectedItemBackgroundColor: prefs.primaryColor,
          selectedItemIconColor: prefs.darkMode ? Colors.black : Colors.white,
          selectedItemLabelColor: prefs.darkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  //static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QRREADER',
      initialRoute: 'qrscan',
      routes: {
        'qrscan': (BuildContext context) => PrincipalPage(),
        'qrgen': (BuildContext context) => QrgenPage(),
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: Locale(prefs.language), //EasyLocalization.of(context).locale,
      theme: theme.getTheme(),
    );
  }
}
