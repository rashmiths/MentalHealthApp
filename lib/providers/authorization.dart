import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  bool _isNew = false;
  final GoogleSignIn googleSignIn = GoogleSignIn(
      // clientId:
      //     '375189019598-5aj24qffcv656ish4tlj3q3u8f9u5gph.apps.googleusercontent.com'
      );

  bool get isNewUser {
    return _isNew;
  }

  Future<String> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await googleSignIn.signOut();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.clear();
      return 'signed out';
    } catch (e) {
      print(e);
      return e;
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String> signIn({String email, String password}) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      AdditionalUserInfo _additionalUserInfo = result.additionalUserInfo;
      _isNew = _additionalUserInfo.isNewUser;
      print(user);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool('login', true);
      sharedPreferences.setString('email', user.email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on SocketException {
      return 'check your Internet connection';
    } catch (e) {
      print(e);
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    print('singUP');
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      //await result.user.sendEmailVerification();
      //if (result.user.isEmailVerified)

      //String idToken = await result.user.getIdToken();
      // Hive.box('cart').put('currentuser',result.user.email);

      AdditionalUserInfo _additionalUserInfo = result.additionalUserInfo;
      _isNew = _additionalUserInfo.isNewUser;
      final tokenId = await result.user.getIdToken(true);
      print("######");
      print(tokenId);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool('login', true);
      sharedPreferences.setString('email', result.user.email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on SocketException {
      return 'check your Internet connection';
    } catch (e) {
      print(e);
      return e.message;
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      print(googleUser);
      if (googleUser == null) {
        print("googleUser null");
        return 'cancelled by user';
        //throw LoginCancelledByUserException();
      }
      final GoogleSignInAuthentication googleAuthentication =
          await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );
      print(credential);

      final tokenId = googleAuthentication.idToken;
      print("######");
      print(tokenId);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool('login', true);
      sharedPreferences.setString('email', googleUser.email);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on SocketException {
      return 'check your Internet connection';
    } catch (e) {
      print(e);
      return e.message;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return 'success';
    } on SocketException {
      return 'check your Internet connection';
    } catch (e) {
      return e;
    }
  }

  Future<String> signInWithPhone({String phone}) async {
    try {
      await _firebaseAuth.signInWithPhoneNumber(phone);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } on SocketException catch (e) {
      print(e);
      return 'No INTERNET';
    }
  }
}
