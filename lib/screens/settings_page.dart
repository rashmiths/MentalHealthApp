import 'package:MentalHealthApp/providers/authorization.dart';
import 'package:MentalHealthApp/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[100],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () async {
                    final result = await Provider.of<AuthenticationService>(
                            context,
                            listen: false)
                        .signOut();
                    if (result == 'signed out')
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => SignInPage()));
                    else
                      errorWidget(context, result);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                        //textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Divider()
              ],
            )
          ],
        ),
      ),
    );
  }
}
