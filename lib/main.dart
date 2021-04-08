import 'package:MentalHealthApp/providers/authorization.dart';
import 'package:MentalHealthApp/providers/posts.dart';
import 'package:MentalHealthApp/screens/login_page.dart';
import 'package:MentalHealthApp/widgets/bottom_tabs.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final isLoggedIn = sharedPreferences.getBool('login') ?? false;
  print(isLoggedIn);
  runApp(MyApp(isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp(this.isLoggedIn);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (_) => Posts([])),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mental Health',
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: AuthenticationWrapper(isLoggedIn)),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final isLoggedIn;
  AuthenticationWrapper(this.isLoggedIn);
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print(firebaseUser);
    if (isLoggedIn && firebaseUser != null) {
      return BottomTabs();
    } else
      return SignInPage();
  }
}
