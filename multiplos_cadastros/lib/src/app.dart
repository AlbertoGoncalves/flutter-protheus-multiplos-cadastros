import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multiplos_cadastros/src/core/ui/app_nav_global_key.dart';
import 'package:multiplos_cadastros/src/core/ui/app_theme.dart';
import 'package:multiplos_cadastros/src/core/ui/widgets/app_loader.dart';
import 'package:multiplos_cadastros/src/features/auth/login/login_page.dart';
import 'package:multiplos_cadastros/src/features/register/people/alter_people/people_alter_page.dart';
import 'package:multiplos_cadastros/src/features/register/people/browser_people/browser_people_page.dart';
import 'package:multiplos_cadastros/src/features/register/people/register_people/people_register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const AppLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Multiplos Cadastros',
          theme: AppTheme.themeData,
          navigatorObservers: [asyncNavigatorObserver],
          // navigatorObservers: [
          //   FlutterSmartDialog.observer,
          //   asyncNavigatorObserver
          // ],
          // builder: FlutterSmartDialog.init(),
          navigatorKey: AppNavGlobalKey.instance.navKey,
          routes: {
            '/': (_) => const LoginPage(),

            '/home': (_) => const BrowserPeoplePage(),
            '/register/people/register': (_) => const PeopleRegisterPage(),
            '/register/people/alter': (_) => const PeopleAlterPage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          locale: const Locale('pt', 'BR'),
        );
      },
    );
  }
}

class FlutterSmartDialog {
}

class BrowserItemsShipmentPage {
  const BrowserItemsShipmentPage();
}
