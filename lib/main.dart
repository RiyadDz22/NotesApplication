import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/views/emailVerification.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as dev;


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'NoteApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/' : (context) => const LoginView(),
        '/register/' : (context) => const RegisterView(),
        '/notes/' : (context) => const NotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
         case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if(user != null){
            if(user.emailVerified){
              return const NotesView();
            } else{
              return const VerifyEmailView();
            }

          } else{
            return const LoginView();
          }
         default:
           return Scaffold(
             body: const CircularProgressIndicator(),
           );
        }
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}
enum MenuAction{
  logout
}


class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch(value)  {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if(shouldLogout == true){
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
                } else{
                  return;
                }
            }
          },
          itemBuilder: (context){
            return [
            const PopupMenuItem<MenuAction>(value: MenuAction.logout,  child: Text('logout'),),
            ];
          },
          )
        ],
      ),
      body: const Text('Hello'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are You Sure You Want To Sign Out'),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: const Text('Cancel'),),
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: const Text('Log Out'),)
      ],
    );
  }).then((value) => value ?? false);
}



