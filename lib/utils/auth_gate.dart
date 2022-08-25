import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:serrature/pages/user_keys.dart';
import 'package:serrature/pages/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              // headerBuilder: (context, constraints, _) {
              //   return Padding(
              //     padding: const EdgeInsets.all(20),
              //     child: AspectRatio(
              //       aspectRatio: 1,
              //       // child: Image.network(
              //       //     'https://firebase.flutter.dev/img/flutterfire_600x.png'),
              //     ),
              //   );
              // },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome! Please sign in to continue.'
                        : 'Welcome! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              providerConfigs: const [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                  clientId:
                      '295647266614-9851m3v3fv3ijmiv5svvl90kjr3ds8t7.apps.googleusercontent.com',
                ),
              ]);
        }
        return Home();
      },
    );
  }
}
