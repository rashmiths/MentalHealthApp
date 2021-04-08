import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> locations = ['India', "USA", "Europe"];
  String country = "India";
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    void presentDatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) {
          return;
        }

        setState(() {
          selectedDate = pickedDate;
        });
      });
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
          ),
        ),
        Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Align(
              alignment: Alignment(-1.2, -1.1),
              child: GestureDetector(
                  child: Container(
                      width: 100,
                      height: 90,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
          GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2.0)),
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1554126807-6b10f6f6692a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                  ),
                ),
              ),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                //   return FullImage(url);
                // }));
              }),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Anonymous',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.android),
              Text(' & '),
              Text(
                'ios  ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
              Text(
                'APP Developer',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      icon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //_launchURL('rashmiths28@gmail.com', 'PartnerShip', '');
                      }),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      onPressed: null),
                ),
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: IconButton(
                      icon: Icon(
                        Icons.open_in_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        //_launchlinkedin();
                      }),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       'https://images.unsplash.com/photo-1594652634010-275456c808d0?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80'),
                  // ),
                  title: Text('Full Name'),
                  subtitle: Text('Anonymous boy'),
                  trailing: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  // leading: CircleAvatar(
                  //     child: Icon(
                  //   Icons.school,
                  //   size: 40,
                  // )),
                  title: Text('Date of Birth'),
                  subtitle: Text(DateFormat.yMd().format(selectedDate)),
                  trailing: IconButton(
                      icon: Icon(Icons.date_range_rounded),
                      onPressed: () {
                        presentDatePicker();
                      }),
                ),
                Divider(),
                ListTile(
                  // leading: CircleAvatar(
                  //   child: Icon(
                  //     Icons.web,
                  //     size: 40,
                  //   ),
                  // ),
                  title: Text('Address'),
                  subtitle: Text("102/80 Kamala street,malleswaram,Bangalore"),
                  trailing: Icon(Icons.edit),
                ),
                Divider(),
                ListTile(
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //       'https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1352&q=80'),
                  // ),
                  title: Text('Country'),
                  subtitle: DropdownButtonFormField(
                      iconSize: 30,
                      iconDisabledColor: Colors.black,
                      items: locations.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      value: country,
                      hint: Text('Please Select Your Country'),
                      onChanged: (newValue) {
                        setState(() {
                          country = newValue;
                        });
                      },
                      validator: (prev) {
                        if (prev == null) return "Please select your country";

                        return null;
                      },
                      onSaved: (val) {
                        //user.country = val;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      )),
                ),
                Divider(),
              ],
            ),
          )
        ]),
      ],
    ));
  }
}

// _launchURL(String toMailId, String subject, String body) async {
//   var url = 'mailto:$toMailId?subject=$subject&body=$body';
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// _launchlinkedin() async {
//   String url = 'https://in.linkedin.com/in/rashmith-s-b6576019a';
//   if (await canLaunch('https://in.linkedin.com/in/rashmith-s-b6576019a')) {
//     await launch('https://in.linkedin.com/in/rashmith-s-b6576019a');
//   } else {
//     throw 'Could not launch $url';
//   }
// }
