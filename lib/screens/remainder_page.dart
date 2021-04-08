import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


class RemainderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListApp(),
    );
  }
}
void main(){
  runApp(RemainderPage());
}



class ListApp extends StatefulWidget {
  @override
  _ListAppState createState() => _ListAppState();
}
class _ListAppState extends State<ListApp> {
  List todos = [];
  bool selected_drink = true;
  bool selected_break = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todos.add("Remind me to Drink Water");
    todos.add("Remind me to take a break");
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
          ),

        ),
        backgroundColor: Colors.amber[100],
      ),
      body: ListView.builder(itemCount: todos.length, itemBuilder: (BuildContext context, int index){
        return Card(
          child: ListTile(
            title: Text(todos[index]),
            trailing: Icon(Icons.check, color: index==0? (selected_drink ? Colors.green : Colors.red):(selected_break ? Colors.green : Colors.red),),
            onTap: (){
              setState(() { // new line
                // change the bool variable based on the index
                if(index==0)
                  selected_drink = !selected_drink;
                else
                  selected_break=!selected_break;

              });

            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[100],
        child: Icon(Icons.check, color: Colors.black,),
        onPressed: () => updateData(selected_break, selected_drink, context),
      ),
    );
  }
}
updateData(selected_break, selected_drink, BuildContext context) async{
  await Firebase.initializeApp();
  CollectionReference collectionReference=FirebaseFirestore.instance.collection('reminder');
  QuerySnapshot querySnapshot = await collectionReference.get();
  querySnapshot.docs[0].reference.update({"break":selected_break, "drink":selected_drink});
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert(context);
    },
  );

}



// set up the AlertDialog
alert(BuildContext context) {
  return AlertDialog(
    title: Text("Reminder is set"),
    actions: [
      TextButton(
        child: Text("Ok"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
  );
}