import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}


class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;

  String get userEmail =>
      AuthService
          .firebase()
          .currentUser!
          .email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout == true) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  } else {
                    return;
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('logout'),
                ),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(future: _notesService.getOrCreate(email: userEmail),
        builder:(context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            return StreamBuilder(
              stream: _notesService.allNotes,
              builder: (context, snapshot){
              switch (snapshot.connectionState){

                case ConnectionState.waiting:
                case ConnectionState.active:
                  if(snapshot.hasData){
                    final allNotes = snapshot.data as List<DatabaseNotes>;
                    return ListView.builder(
                    itemCount: allNotes.length,
                    itemBuilder: (context, index){
                      final note = allNotes[index];
                      return ListTile(
                        title: Text(
                          note.text,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },);
                  } else{
                    return const CircularProgressIndicator();
                  }
                default : return const CircularProgressIndicator();
              }
            },
            );
          default: return const CircularProgressIndicator();
        }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed:(){
        Navigator.of(context).pushNamed(newNoteRoute);
      } , backgroundColor: Colors.blue, child: const Icon(Icons.add),),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are You Sure You Want To Sign Out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            )
          ],
        );
      }).then((value) => value ?? false);
}