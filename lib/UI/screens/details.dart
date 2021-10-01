import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplenote/UI/constants/constants.dart';
import 'package:simplenote/UI/screens/add.dart';
import 'package:simplenote/UI/screens/home.dart';
import 'package:simplenote/core/bloc/note_cubit/note_cubit.dart';
import 'package:simplenote/core/bloc/note_states/note_states.dart';
import 'dart:ui' as ui;

import 'package:simplenote/core/models/note_model.dart';

class NoteDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteStates>(
      listener: (context, state) {
        if (state is NoteDeleteNoteSuccessState) {
          kToast('Note deleted', isSuccess: true);
          navigateAndRemove(context, Home());
        }

        if (state is NoteDeleteNoteErrorState) {
          kToast(state.error);
        }
      },
      builder: (context, state) {
        var cubit = NoteCubit.get(context);
        Note? note = cubit.singleNote;
        return Scaffold(
          appBar: _appBar(cubit, note!, context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              _deleteButtonMethod(cubit, note.id!, context);
            },
            child: Icon(Icons.delete),
          ),
          body: Container(
            color: cubit.isDark ? kDarkModeColor : Color(note.color!),
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: ListView(
              children: [
                _displayDate(
                    date: note.date!, time: note.time!, context: context),
                note.time != note.editTime
                    ? _displayDate(
                        date: note.editDate!,
                        time: note.editTime!,
                        context: context)
                    : SizedBox(),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '${note.content}',
                  textDirection: isRTL('${note.content}')
                      ? ui.TextDirection.rtl
                      : ui.TextDirection.ltr,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _displayDate(
      {required String date,
      required String time,
      required BuildContext context}) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        'Created : $time $date',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  AppBar _appBar(NoteCubit cubit, Note note, BuildContext context) {
    return AppBar(
      iconTheme:
          IconThemeData(color: cubit.isDark ? Colors.white : Colors.black54),
      title: Text(
        '${note.title!}',
        textDirection: isRTL('${note.title}')
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.headline6,
      ),
      backgroundColor: cubit.isDark ? kAppBarDarkColor
       : Color(note.color!),
      actions: [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              navigateTo(
                  context,
                  Add(
                    screenName: 'Edit Note',
                    note: note,
                  ));
            })
      ],
    );
  }

  _deleteButtonMethod(NoteCubit cubit, int noteId, context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                'Are you sure you want to delete this note?',
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      await cubit.deleteNote(noteId);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.green),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ));
  }
}
