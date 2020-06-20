import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginsignup/main.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body : Container(
        child: RaisedButton(
          onPressed:logOut,
          child: Text('Log Out'),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                'assets/images/flutter_logo.png',
                height: 10,
                width: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  void logOut() {
    try{
      Widget cancelButton = FlatButton(
        child: Text('Cancel'),
        onPressed: (){
          Navigator.of(context).pop();
        },
      );

      Widget okButton = FlatButton(
        child: Text('Ok'),
        onPressed: (){
          Navigator.of(context).pop();
          FirebaseAuth.instance.signOut();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context)=>MyApp()
              )
          );
          print('Sign Out Successful');
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Are you sure you want to LogOut?'),
        actions: <Widget>[
          okButton,
          cancelButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        }
      );
    }

    catch(e){
      Toast.show(e, context,duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

  }

}
