import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final firebase = FirebaseAuth.instance;
  runApp(MaterialApp(
    title: 'google_sign_in_issue',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: StreamBuilder<User>(
      stream: firebase.authStateChanges(),
      builder: (context, snapshot) => snapshot.hasData ? HomeScreen() : LoginScreen(firebase),
    ),
  ));
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth auth;

  LoginScreen(this.auth);

  final signIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Login with Google'),
          onPressed: () async {
            final googleUser = await signIn.signIn();
            final googleAuth = await googleUser.authentication;
            final user = await auth.signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ));
          }
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}
