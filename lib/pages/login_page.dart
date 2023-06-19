import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/forgot_pw_page.dart';
import 'package:todoapp/pages/register_page.dart';
import 'package:todoapp/widgets/custom_button.dart';
import 'package:todoapp/widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  
  void signUserIn() async {
    
    if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
      errorMessage("Please fill in all fields.");
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage('Email Does Not Exist');
      } else if (e.code == 'wrong-password') {
        errorMessage('Incorrect Password');
      } else {
        errorMessage(e.code);
      }
    }
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
                Image.asset(
                  'assets/TODO.png',
                  height: 130.0
                ),
                SizedBox(height: 70.0,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Text(
                      'Login',
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
                  controller: _emailcontroller,
                  hintText: 'Email',
                  obscureText: false,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  )
                ),
                SizedBox(height: 15.0,),
                CustomTextfield(
                  controller: _passwordcontroller,
                  hintText: 'Password',
                  obscureText: true,
                  icon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ForgotPWPage()
                        ));
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      CustomButton(
                        onTap: signUserIn,
                        text: 'Sign In',
                      ),
                      SizedBox(height: 5.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => RegisterPage()
                          ));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: ' Sign Up.',
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