import 'package:divine/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:divine/components/form_error.dart';
import 'package:divine/values/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';

import 'login.dart';
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      body: Stack(
        children: [
          Container(
            child: Row(
              children: [
                Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),)
              ],
            ),
            margin: EdgeInsets.only(top: 50,left: 20),
          ),
          Container(

            margin: EdgeInsets.only(top: 120),
            height: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                )
            ),
            padding:
            EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Register Account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Complete your details",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        buildEmailFormField(),
                        SizedBox(height: 20),
                        buildPasswordFormField(),
                        SizedBox(height: 30),

                        FormError(errors: errors),
                        SizedBox(height: 20),
                        SizedBox(height:10),
                        GestureDetector(
                          onTap: ()async{
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password
                                ).whenComplete(() {
                                  FirebaseAuth.instance
                                      .authStateChanges()
                                      .listen((User user) {
                                    if (user == null) {
                                      print('User is currently signed out!');
                                    } else {
                                      print('User is signed in!');
                                      Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: HomePage()));
                                    }
                                  });
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                } else if (e.code == 'email-already-in-use') {

                                  print('The account already exists for that email.');
                                }
                              } catch (e) {
                                print(e);
                              }


                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColorDark,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width*0.7,

                            height: 50,
                            child: Text("Register",textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 18),),
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",style: TextStyle(color: Colors.grey[500]),),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Login()));
                        },
                        child: Text(" Sign In",style: TextStyle(color: primaryColorDark),),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0.5,
          ),
        ),
        filled: true,
        prefixIcon: Icon(Icons.lock_outline,color: Colors.black,size: 22,),
        fillColor: Colors.grey[200],
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },

      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0.5,
          ),
        ),
        filled: true,
        prefixIcon: Icon(Icons.email_outlined,color: Colors.black,size: 22,),
        fillColor: Colors.grey[200],
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
