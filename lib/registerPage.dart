import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginsignup/main.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Container(
            margin: EdgeInsets.only(left:20, top:20, right:20, bottom:0),
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: validateEmail,
                    onSaved: (value)=> _email = value,
                  ),
                  TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) => _password = value,
                      validator: (value)=> value.isEmpty? 'Password can\'t be empty' : null,
                  ),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.only(top:20.0),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Register',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: validateAndSubmit,
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
            )
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

  void validateAndSubmit() async {
    if(validateAndSave()){
      try{
        FirebaseUser userData = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.trim(), password: _password)).user;
        Toast.show('Registration Successfully', context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp()
            )
        );
      }
      catch(e){
        Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        print('error is $e');
      }
    }
    else{
      Toast.show('Please Check your Entry', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
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

