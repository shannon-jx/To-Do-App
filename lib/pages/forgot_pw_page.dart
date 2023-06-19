import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/pages/auth_page.dart';
import 'package:todoapp/widgets/custom_button.dart';
import 'package:todoapp/widgets/custom_textfield.dart';

class ForgotPWPage extends StatefulWidget {
  const ForgotPWPage({super.key});

  @override
  State<ForgotPWPage> createState() => _ForgotPWPageState();
}

class _ForgotPWPageState extends State<ForgotPWPage> {
  final emailcontroller = TextEditingController();

  Future resetPW() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text.trim());
      popUp('Password reset link sent! Check your email');
    } on FirebaseAuthException catch (e) {
      popUp(e.message.toString());
    }
  }

  void popUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/purple.jpg'
            ),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Icon(
              Icons.lock_person_rounded,
              size: 200.0,
            ),
            SizedBox(height: 70),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0,),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Text(
                  'Enter your email: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomTextfield(
              controller: emailcontroller,
              hintText: 'Email',
              obscureText: false,
              icon: const Icon(
                Icons.person,
                color: Colors.grey,
              )
            ),
            const SizedBox(height: 30),
            CustomButton(
              onTap: resetPW, 
              text: 'Reset Password'
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AuthPage()
                ));
              },
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Remember your password? ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Login.',
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
      ),
    );
  }
}