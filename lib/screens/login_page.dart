import 'package:MentalHealthApp/providers/authorization.dart';
import 'package:MentalHealthApp/widgets/bottom_tabs.dart';
import 'package:MentalHealthApp/widgets/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum LoginMode { Email, Phone }

enum AuthMode { Login, SignUP }

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  LoginMode _loginMode = LoginMode.Email;
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//logging in with phone which is UpCOMING
  // void _switchLoginMode(LoginMode mode) {
  //   setState(() {
  //     _loginMode = mode;
  //   });
  // }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUP;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.red[900], Colors.red[800], Colors.red[400]])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //HEADING
                  FadeAnimation(
                      1,
                      Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  //SUBHEADING
                  FadeAnimation(
                      1.3,
                      Text(
                        _authMode == AuthMode.Login
                            ? 'Welcome Back'
                            : 'Hi There',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeAnimation(
                            1.4,
                            Form(
                              key: _formKey,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(225, 95, 27, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, 10))
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    if (_authMode == AuthMode.SignUP)
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey[200]))),
                                        child: TextFormField(
                                          validator: (val) {
                                            if (val.isEmpty)
                                              return 'USERNAME CANNOT BE EMPTY';

                                            return null;
                                          },
                                          controller: userNameController,
                                          decoration: InputDecoration(
                                              hintText: "User Name",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (val) {
                                          if (val.isEmpty)
                                            return 'EMAIL CANNOT BE EMPTY';
                                          else if (!(val.contains('@'))) {
                                            return 'ENTER A VALID EMAIL ADRESS';
                                          }
                                          return null;
                                        },
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        controller: passwordController,
                                        validator: (val) {
                                          if (val.isEmpty) {
                                            return 'PASSWORD CANNOT BE EMPTY';
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                          1.6,
                          Container(
                            child: GestureDetector(
                              onTap: () async {
                                if (emailController.text.isEmpty ||
                                    !(emailController.text.contains('@')))
                                  errorWidget(context,
                                      'Please Enter valid email address to reset password');
                                else {
                                  final result = await context
                                      .read<AuthenticationService>()
                                      .resetPassword(
                                          emailController.text.trim());
                                  if (result == 'success')
                                    errorWidget(context, result,
                                        isSuccess: true);
                                  else
                                    errorWidget(context, result);
                                }
                              },
                              child: Text(
                                "Reset Password?",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        if (_isLoading)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            child: CircularProgressIndicator(),
                          )
                        else
                          //LOGIN METHOD
                          GestureDetector(
                            onTap: () async {
                              final form = _formKey.currentState;

                              if (form.validate()) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                setState(() {
                                  print('TAPPED');
                                  _isLoading = true;
                                });
                                if (_authMode == AuthMode.Login) {
                                  final result = await context
                                      .read<AuthenticationService>()
                                      .signIn(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                                  if (result == 'success')
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (_) {
                                      return BottomTabs();
                                    }));
                                  else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    errorWidget(context, result);
                                  }
                                } else {
                                  final result = await context
                                      .read<AuthenticationService>()
                                      .signUp(
                                          // name: userNameController.text,
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim());
                                  if (result == 'success')
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (_) {
                                      return BottomTabs();
                                    }));
                                  else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    errorWidget(context, result);
                                  }
                                }
                              }

                              // setState(() {
                              //   print('unTapped');
                              //   _isLoading = false;
                              // });
                            },
                            //LOGIN OR SIGNUP BUTTON
                            child: FadeAnimation(
                                1.6,
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.red[900]),
                                  child: Center(
                                    child: Text(
                                      _authMode == AuthMode.Login
                                          ? 'LOGIN'
                                          : 'SIGN UP',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                        SizedBox(
                          height: 5,
                        ),
                        FadeAnimation(
                            1.5,
                            FlatButton(
                              onPressed: () {
                                _switchAuthMode();
                              },
                              child: Text(
                                "${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.7,
                          Text(
                            '- OR -',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await context
                                .read<AuthenticationService>()
                                .signInWithGoogle();
                            if (result == 'success')
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) {
                                return BottomTabs();
                              }));
                            else {
                              setState(() {
                                _isLoading = false;
                              });
                              errorWidget(context, result);
                            }
                          },
                          child: Container(
                            height: 45.0,
                            child:
                                Image.asset('assets/google_light_sign_in.png'),
                          ),
                        ),

                        ///Upcoming feature of ligging in with phone and google

                        // SizedBox(
                        //   height: 40,
                        // ),
                        // FadeAnimation(
                        //     1.7,
                        //     Text(
                        //       _authMode == AuthMode.Login
                        //           ? 'Sign Up WIth'
                        //           : 'Login With',
                        //       style: TextStyle(color: Colors.grey),
                        //     )),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // Row(
                        //   children: <Widget>[
                        //     Expanded(
                        //       child: FadeAnimation(
                        //           1.8,_loginMode == LoginMode.Emaio
                        //           GestureDetector(
                        //             onTap: () {
                        //               _switchAuthMode();
                        //               _switchLoginMode(LoginMode.Email);
                        //             },
                        //             child: Container(
                        //               height: 50,
                        //               decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(50),
                        //                   color: Colors.redAccent[700]),
                        //               child: Center(
                        //                 child: Text(
                        //                   "EMAIL",
                        //                   style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //             ),
                        //           )),
                        //     ),
                        //     SizedBox(
                        //       width: 30,
                        //     ),
                        //     Expanded(
                        //       child: FadeAnimation(
                        //           1.9,
                        //           GestureDetector(
                        //             onTap: () {
                        //               _switchAuthMode();
                        //               _switchLoginMode(LoginMode.Phone);
                        //             },
                        //             child: Container(
                        //               height: 50,
                        //               decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(50),
                        //                   color: Colors.black),
                        //               child: Center(
                        //                 child: Text(
                        //                   "PHONE",
                        //                   style: TextStyle(
                        //                       color: Colors.white,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //             ),
                        //           )),
                        //     )
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<Widget> errorWidget(BuildContext context, String result,
    {bool isSuccess = false}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: isSuccess ? Text("YaaY") : const Text('Oops!'),
      content: Text(result),
      actions: <Widget>[
        FlatButton(
          child: isSuccess ? Text("OK") : const Text('TRY AGAIN'),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
