class NoteStates {}

class NoteInitialState extends NoteStates {}

class NoteInsertNoteSuccessState extends NoteStates {}

class NoteInsertNoteErrorState extends NoteStates {
  final String error;
  NoteInsertNoteErrorState(this.error);
}

class NoteGetNoteSuccessState extends NoteStates {}

class NoteGetNoteErrorState extends NoteStates {
  final String error;
  NoteGetNoteErrorState(this.error);
}

class NoteUpdateNoteSuccessState extends NoteStates {}

class NoteUpdateNoteErrorState extends NoteStates {
  final String error;
  NoteUpdateNoteErrorState(this.error);
}

class NoteDeleteNoteSuccessState extends NoteStates {}

class NoteDeleteNoteErrorState extends NoteStates {
  final String error;
  NoteDeleteNoteErrorState(this.error);
}

class NoteSearchSuccessState extends NoteStates {}

class NoteSearchErrorState extends NoteStates {
  final String error;
  NoteSearchErrorState(this.error);
}

class NoteGetDetailsSuccessState extends NoteStates {}

class NoteGetDetailsErrorState extends NoteStates {
  final String error;
  NoteGetDetailsErrorState(this.error);
}

class NoteChangeThemeSuccessState extends NoteStates {}

class NoteBackgroundColorSuccessState extends NoteStates {}

class NoteOnSearchPressedSuccessState extends NoteStates {}
