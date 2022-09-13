import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new note'),
      centerTitle: true,
      ),
      body: const Text('write your note here'),
    );
  }
}

