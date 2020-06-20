import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/main.dart';
import 'package:toast/toast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: validateEmail,
                onSaved: (value) => _email = value,
              ),
              GestureDetector(
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.only(top:20.0),
                ),
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: validateAndCheck,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=> MyApp()
                      )
                  );
                },
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child : Text(
                      'Login to Account',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndCheck() async {
    if(validateAndSave()){
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        Toast.show("Check your gmail", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
        print('Successfully sent mail');
      }
      catch(e){
        print('Error is $e');
        Toast.show(e.toString(), context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      }
    }
    else{
      Toast.show('Please check your entry', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
