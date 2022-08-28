import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login'),centerTitle: true,),
    body: Column(
      children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Enter your e-mail',
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: 'Enter a password'),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              final userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: email, password: password);
              dev.log(userCredential.toString());
            } on FirebaseAuthException catch (e){
              if(e.code == 'user-not-found'){
                dev.log('something went wrong ');
                dev.log('user not found');
              } else if (e.code == 'wrong-password'){
                dev.log('wrong password');
              }
            }
          },
          child: const Text('Login'),
        ),
        TextButton(onPressed: (){
          Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
        }, child: const Text('Register Here'))
      ],
    ),
  );
}