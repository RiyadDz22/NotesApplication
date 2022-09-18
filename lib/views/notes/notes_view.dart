import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/crud/notes_service.dart';
import 'package:notes/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

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
                    return NotesListView(notes: allNotes, onDeleteNote: (note) async {
                      await _notesService.deleteNote(id: note.id);
                    },
                    onTap: (note) {
                      Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note, );
                    },
                    );
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
        Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
      } , backgroundColor: Colors.blue, child: const Icon(Icons.add),),
    );
  }
}
