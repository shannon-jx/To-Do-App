import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/auth_page.dart';
import 'package:todoapp/pages/login_page.dart';
import 'package:todoapp/widgets/custom_button.dart';
import 'package:todoapp/widgets/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstncontroller = TextEditingController();
  final TextEditingController _lastncontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller = TextEditingController();
  
  void signUserUp() async {
    String firstname = _firstncontroller.text.trim();
    String lastname = _lastncontroller.text.trim();
    String email = _emailcontroller.text.trim();
    String password = _passwordcontroller.text.trim();
    String confirmPassword = _confirmpasswordcontroller.text.trim();
    
    if (firstname.isEmpty 
      || lastname.isEmpty
      || email.isEmpty
      || password.isEmpty
      || confirmPassword.isEmpty) {
      errorMessage("Please fill in all fields.");
      return;
    }

    try {
      if (password == confirmPassword) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailcontroller.text,
          password: _passwordcontroller.text,
        );

        getDetails(firstname, lastname, email);

        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
      } else {
        errorMessage("Passwords don't match!");
      }
    } on FirebaseAuthException catch (e) {
      errorMessage(e.code);
    }
  }

  Future getDetails(String firstname, String lastname, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'First Name': firstname,
      'Last Name': lastname,
      'Email': email,
    });
  }
  
  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/purple.jpg'
          ),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 100.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                CustomTextfield(
                  controller: _firstncontroller,
                  hintText: 'First Name',
                  obscureText: false,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  )
                ),
                SizedBox(height: 15.0,),
                CustomTextfield(
                  controller: _lastncontroller,
                  hintText: 'Last Name',
                  obscureText: false,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 15.0),
                CustomTextfield(
                  controller: _emailcontroller,
                  hintText: 'Email',
                  obscureText: false,
                  icon: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  )
                ),
                SizedBox(height: 15.0),
                CustomTextfield(
                  controller: _passwordcontroller,
                  hintText: 'Password',
                  obscureText: true,
                  icon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  )
                ),
                SizedBox(height: 15.0),
                CustomTextfield(
                  controller: _confirmpasswordcontroller,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  icon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  )
                ),
                SizedBox(height: 35.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      CustomButton(
                        onTap: signUserUp,
                        text: 'Sign Up',
                      ),
                      SizedBox(height: 5.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => LoginPage()
                          ));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Already a member? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: ' Sign In.',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ]),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }