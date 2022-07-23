import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplenote/core/bloc/note_states/note_states.dart';
import 'package:simplenote/core/helper/cache_data.dart';
import 'package:simplenote/core/helper/db_helper.dart';
import 'package:simplenote/core/models/note_model.dart';

class NoteCubit extends Cubit<NoteStates> {
  NoteCubit() : super(NoteInitialState());

  static NoteCubit get(context) => BlocProvider.of(context);

  insertNote(Note note) async {
    try {
      await DatabaseHelper.insertNote(note);
      await getNotes();
      emit(NoteInsertNoteSuccessState());
    } catch (error) {
      emit(NoteInsertNoteErrorState(error.toString()));
    }
  }

  List<Note> notes = [];

  getNotes() async {
    try {
      List<Map<String, Object?>> list = await DatabaseHelper.loadAll();

      notes = list.map((e) => Note.fromMap(e)).toList();
      notes.sort((a, b) => '${b.editDate} ${b.editTime}'
          .compareTo('${a.editDate} ${a.editTime}'));
      emit(NoteGetNoteSuccessState());
    } catch (error) {
      emit(NoteGetNoteErrorState(error.toString()));
    }
  }

  Note? singleNote;

  getSingleNote(int id) async {
    try {
      List<Map<String, Object?>> details = await DatabaseHelper.getDetails(id);
      singleNote = details.map((e) => Note.fromMap(e)).toList().first;
      filteredList = [];
      emit(NoteGetDetailsSuccessState());
    } catch (error) {
      emit(NoteGetDetailsErrorState(error.toString()));
    }
  }

  updateNote(Note note) async {
    try {
      notes.firstWhere((element) => element.id == note.id);
      await DatabaseHelper.updateNote(note);
      await getNotes();
      emit(NoteUpdateNoteSuccessState());
    } catch (error) {
      emit(NoteUpdateNoteErrorState(error.toString()));
    }
  }

  deleteNote(int noteId) async {
    try {
      notes.removeWhere((element) => element.id == noteId);
      await DatabaseHelper.deleteNote(noteId);
      await getNotes();
      emit(NoteDeleteNoteSuccessState());
    } catch (error) {
      emit(NoteDeleteNoteErrorState(error.toString()));
    }
  }

  List<Note> filteredList = [];

  searchNote(String value) async {
    try {
      filteredList = notes
          .where((element) =>
              element.title!.contains(value) ||
              element.content!.contains(value))
          .toList();
      // List<Map<String, Object?>> search = await DatabaseHelper.search(value);
      // for (var note in search) {
      //   filteredList.add(Note.fromMap(note));
      // }
      print('filteredList ${filteredList.length}');
      // filteredList = search.map((e) => Note.fromMap(e)).toList();
      emit(NoteSearchSuccessState());
    } catch (error) {
      emit(NoteSearchErrorState(error.toString()));
    }
  }

  bool isDark = false;

  changeTheme({bool? fromShared}) async {
    if (fromShared == null) {
      isDark = !isDark;
      await CacheData.setBool('isDark', isDark);
      emit(NoteChangeThemeSuccessState());
    } else {
      isDark = fromShared;
      emit(NoteChangeThemeSuccessState());
    }
  }

  int? backgroundColor;

  changeBackgroundColor(int color) {
    backgroundColor = color;
    emit(NoteBackgroundColorSuccessState());
  }

  bool isSeachPressed = false;

  onSearchPressed() {
    isSeachPressed = !isSeachPressed;
    emit(NoteOnSearchPressedSuccessState());
  }
}
