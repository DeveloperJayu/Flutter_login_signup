import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginsignup/forgotPassword.dart';
import 'package:loginsignup/homePage.dart';
import 'package:loginsignup/main.dart';
import 'package:loginsignup/registerPage.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
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
                  decoration: InputDecoration(
                      labelText: 'Email'
                  ),
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value)=> _email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password'
                  ),
                  obscureText: true,
                  onSaved: (value) => _password = value,
                  validator: (value)=> value.isEmpty? 'Password can\'t be empty' : null,
                ),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> ForgotPassword()
                          )
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.topRight,
                      child : Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15.0
                        ),
                      ),
                    )
                ),
                RaisedButton(
                  child: Text('Login',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  onPressed: validateAndSubmit,
                ),
                GestureDetector(

                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context)=> RegisterPage()
                        )
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child : Text(
                        'Create an Account',
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
        )
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

        FirebaseUser userData = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.trim(), password: _password)).user;
        print('Signed in Email: ${userData.email}');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()
            )
        );
      }

      catch(e){

        Toast.show(e.toString(), context, duration: Toast.LENGTH_SHORT, gravity : Toast.CENTER);
        print('Error is $e');

      }

    }

    else{

      Toast.show('Please check your entry', context, duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

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

