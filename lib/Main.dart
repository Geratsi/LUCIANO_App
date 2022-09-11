
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Config.dart';
import 'Styles.dart';
import 'firebase_options.dart';
import 'components/ErrorWindow.dart';
import 'screens/login/MainLoginScreen.dart';

void _onMessage(RemoteMessage message) {
  log('_onMessage: $message', name: Config.appName);
  if (message.notification != null) {
    /// local notification
  }
}

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  log('_onBackgroundMessage: $message', name: Config.appName);
  if (message.notification != null) {
    ///
  }
}

void _onMessageOpenedApp(RemoteMessage message) {
  log('_onMessageOpenedApp: $message', name: Config.appName);
  if (message.notification != null) {
    ///
  }
}

void _onTokenRefresh(String? token) {
  log('_onTokenRefresh: $token', name: Config.appName);
}

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    log('main: ${details.exception}', name: Config.appName);
    log('main: trace ${details.stack}', name: Config.appName);

    return ErrorWindow(details: details);
  };

  // runApp(ChangeNotifierProvider(
  //   create: (context) {
  //     log('initialize state');
  //     return ApplicationState();
  //   },
  //   builder: (context, _) => const MyApp(),
  // ));

  runApp(const MyApp(),);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? messageId;

  @override
  void initState() {
    super.initState();

    stderr.writeln('___initialize Firebase___///___///___');
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final FirebaseMessaging fmInstance = FirebaseMessaging.instance;

    _checkForInitialMessage(fmInstance);

    final token = await fmInstance.getToken();
    log('__FCM_token__', name: Config.appName);
    log(token.toString(), name: Config.appName);

    FirebaseMessaging.instance.onTokenRefresh
        .listen(_onTokenRefresh)
        .onError((error) {log(error, name: Config.appName);});

    final NotificationSettings settings = await fmInstance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
      announcement: true,
    );

    log(settings.authorizationStatus.toString(), name: Config.appName);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission', name: Config.appName);

      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      FirebaseMessaging.onMessage.listen(_onMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    } else {
      log('User declined or has not accepted permission', name: Config.appName);
    }
  }

  Future<void> _checkForInitialMessage(FirebaseMessaging instance) async {
    final RemoteMessage? initialMessage = await instance.getInitialMessage();

    log('_checkForInitialMessage: $initialMessage', name: Config.appName);
    if (initialMessage != null) {
      ///
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      // locale: Provider.of<ValueListener<Locale>>(context).getValue,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: const Locale('ru'),
      title: 'TNG',
      theme: ThemeData(
        //AppBar
        primarySwatch: MaterialColor(Config.primaryColor.value, {
          50:Config.primaryColor.withOpacity(.1),
          100:Config.primaryColor.withOpacity(.2),
          200:Config.primaryColor.withOpacity(.3),
          300:Config.primaryColor.withOpacity(.4),
          400:Config.primaryColor.withOpacity(.5),
          500:Config.primaryColor.withOpacity(.6),
          600:Config.primaryColor.withOpacity(.7),
          700:Config.primaryColor.withOpacity(.8),
          800:Config.primaryColor.withOpacity(.9),
          900:Config.primaryColor.withOpacity(1),
        }),
        primaryColorLight: MaterialColor(Config.primaryLightColor.value, {
          50:Config.primaryLightColor.withOpacity(.1),
          100:Config.primaryLightColor.withOpacity(.2),
          200:Config.primaryLightColor.withOpacity(.3),
          300:Config.primaryLightColor.withOpacity(.4),
          400:Config.primaryLightColor.withOpacity(.5),
          500:Config.primaryLightColor.withOpacity(.6),
          600:Config.primaryLightColor.withOpacity(.7),
          700:Config.primaryLightColor.withOpacity(.8),
          800:Config.primaryLightColor.withOpacity(.9),
          900:Config.primaryLightColor.withOpacity(1),
        }),

        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Config.textTitleColor, size: Config.iconSize,
          ),
          centerTitle: true,
          shadowColor: Colors.transparent,
          titleTextStyle: Styles.titleStyle,
          backgroundColor: Config.primaryColor,
        ),

        iconTheme: const IconThemeData(
          color: Config.textTitleColor, size: Config.iconSize,
        ),

        dividerTheme: const DividerThemeData(
          color: Config.infoColor, thickness: 1,
        ),
        fontFamily: 'Geometria',
        splashColor: Config.splashColor,
        shadowColor: Config.shadowColor,
        primaryColor: Config.primaryColor,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Config.activityBackColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // textTheme: GoogleFonts.robotoMonoTextTheme(Theme.of(context).textTheme),
      ),
      // theme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      // darkTheme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: Colors.black,
      //   colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white, primary: Colors.black54),
      // ),

      home: const MainLoginScreen(),

      // initialRoute: '/',
      // routes: {
      //   '/': (context) => AnimatedSwitcher(
      //     duration: Duration(milliseconds: Config.animDuration),
      //     child: finish ? const MainLoginScreen() : const SplashScreen(),
      //   ),
      //   '/register': (context) => const RegisterScreen(),
      //   '/main_login': (context) => const MainLoginScreen(),
      //   '/check_user': (context) => const CheckUserScreen(),
      //   '/check_user/forgot_psw': (context) => const ForgotPasswordScreen(),
      // },
    );

    // return FutureBuilder<Locale>(
    //   future: _getGlobalLanguageCode(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       print('waiting');
    //
    //       return const Center(
    //         child: CircularProgressIndicator.adaptive(), // will be discussing
    //       );
    //
    //     } else if (snapshot.hasError) {
    //       return Center(
    //         child: Text(snapshot.error.toString()),
    //       );
    //     } else {
    //       return ChangeNotifierProvider(
    //         create: (context) => ValueListener<Locale>(
    //           value: snapshot.data,
    //         ),
    //         builder: (context, child) {
    //           return MaterialApp();
    //         },
    //       );
    //     }
    //   },
    // );
  }
}
