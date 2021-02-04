import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///D:/Flutter/projecttwo/flutter_appone/lib/widget/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthScreen extends StatefulWidget {

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth =FirebaseAuth.instance;
  var _isLoading =false;
  void _submitAuthForm(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext ctx
      ) async {
    AuthResult authResult;


    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
      }

      await Firestore.instance.
      collection('usersss').
      document(authResult.user.uid).
      setData({
        'username':username,
        'email': email,

      });
    } on PlatformException catch (err) {
      var message = 'An error occurred,plase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
     print("message$message");

      setState(() {
        _isLoading =false;
      });
    } catch (err) {
      print(err);

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body:AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
