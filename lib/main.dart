import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

import 'config.dart';
// import 'decorations.dart';

final actionCodeSettings = ActionCodeSettings(
  url: 'https://flutterfire-e2e-tests.firebaseapp.com',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  androidPackageName: 'io.flutter.plugins.firebase_ui.firebase_ui_example',
  iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
);
final emailLinkProviderConfig = EmailLinkAuthProvider(
  actionCodeSettings: actionCodeSettings,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    emailLinkProviderConfig,
    PhoneAuthProvider(),
    GoogleProvider(clientId: GOOGLE_CLIENT_ID),
    // AppleProvider(),
    // FacebookProvider(clientId: FACEBOOK_CLIENT_ID),
    TwitterProvider(
      apiKey: TWITTER_API_KEY,
      apiSecretKey: TWITTER_API_SECRET_KEY,
      // redirectUri: TWITTER_REDIRECT_URI,
    ),
  ]);

  runApp(const MyApp());
}

// Overrides a label for en locale
// To add localization for a custom language follow the guide here:
// https://flutter.dev/docs/development/accessibility-and-localization/internationalization#an-alternative-class-for-the-apps-localized-resources
class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'メールアドレス';
  String get passwordInputLabel => 'パスワード';
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  String get initialRoute {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return '/';
    }

    if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
      return '/verify-email';
    }

    return '/profile';
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    final mfaAction = AuthStateChangeAction<MFARequired>(
      (context, state) async {
        final nav = Navigator.of(context);

        await startMFAVerification(
          resolver: state.resolver,
          context: context,
        );

        nav.pushReplacementNamed('/profile');
      },
    );

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.standard,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction((context, email) {
                Navigator.pushNamed(
                  context,
                  '/forgot-password',
                  arguments: {'email': email},
                );
              }),
              VerifyPhoneAction((context, _) {
                Navigator.pushNamed(context, '/phone');
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                if (!state.user!.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                if (!state.credential.user!.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
              }),
              mfaAction,
              EmailLinkSignInAction((context) {
                Navigator.pushReplacementNamed(context, '/email-link-sign-in');
              }),
            ],
            styles: const {
              EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  action == AuthAction.signIn
                      ? 'Firebase UIへようこそ！ サインインしてください'
                      : 'Firebase UIへようこそ！ アカウントを作成してください',
                ),
              );
            },
            footerBuilder: (context, action) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'サインインした場合、利用規約に同意したものとみなします'
                        : 'アカウント登録をした場合、利用規約に同意したものとみなします',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
        '/verify-email': (context) {
          return EmailVerificationScreen(
            actionCodeSettings: actionCodeSettings,
            actions: [
              EmailVerifiedAction(() {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
              AuthCancelledAction((context) {
                FirebaseUIAuth.signOut(context: context);
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
          );
        },
        '/phone': (context) {
          return PhoneInputScreen(
            actions: [
              SMSCodeRequestedAction((context, action, flowKey, phone) {
                Navigator.of(context).pushReplacementNamed(
                  '/sms',
                  arguments: {
                    'action': action,
                    'flowKey': flowKey,
                    'phone': phone,
                  },
                );
              }),
            ],
          );
        },
        '/sms': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return SMSCodeInputScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.of(context).pushReplacementNamed('/profile');
              })
            ],
            flowKey: arguments?['flowKey'],
            action: arguments?['action'],
          );
        },
        '/forgot-password': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
          );
        },
        '/email-link-sign-in': (context) {
          return EmailLinkSignInScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/');
              }),
            ],
            provider: emailLinkProviderConfig,
            headerMaxExtent: 200,
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/');
              }),
              mfaAction,
            ],
            actionCodeSettings: actionCodeSettings,
            showMFATile: true,
          );
        },
      },
      title: 'Firebase UI demo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('jp'),
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
    );
  }
}
