import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-mail Verification'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text("we've already sent you an verification email!"),
          const Text(
              "click on 'send verification email' if you did not receive one!"),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthSendEmailVerificationEvent());

              },
              child: const Text('send verification email')),
          TextButton(onPressed: () {
            context.read<AuthBloc>().add(const AuthEventLogOut());
          }, child: const Text('Restart'),)
        ],
      ),
    );
  }
}
