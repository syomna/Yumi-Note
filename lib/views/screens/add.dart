import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simplenote/views/constants/constants.dart';
import 'package:simplenote/views/screens/home.dart';
import 'package:simplenote/views/widgets/content_text_field.dart';
import 'package:simplenote/views/widgets/title_text_field.dart';
import 'package:simplenote/core/bloc/note_cubit/note_cubit.dart';
import 'package:simplenote/core/bloc/note_states/note_states.dart';
import 'package:simplenote/core/models/note_model.dart';

class Add extends StatelessWidget {
  final String screenName;
  final Note? note;
  Add({required this.screenName, this.note});

  String date = DateFormat.yMd().format(DateTime.now());
  String time = DateFormat.Hm().format(DateTime.now());

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteStates>(
      listener: (context, state) {
        if (state is NoteInsertNoteSuccessState) {
          kToast('Note Added', isSuccess: true);
          navigateAndRemove(context, Home());
        }
        if (state is NoteInsertNoteErrorState) {
          kToast('Something went wrong');
        }
        if (state is NoteUpdateNoteSuccessState) {
          kToast('Note edited', isSuccess: true);
          navigateAndRemove(context, Home());
        }
        if (state is NoteUpdateNoteErrorState) {
          kToast('Something went wrong');
        }
      },
      builder: (context, state) {
        var cubit = NoteCubit.get(context);
        if (screenName == 'Edit Note') {
          _titleController.text = note!.title!;
        }
        if (screenName == 'Edit Note') {
          _contentController.text = note!.content!;
        }
        return Scaffold(
          appBar: _appBar(cubit, context),
          body: _body(cubit, context),
        );
      },
    );
  }

  Widget _body(NoteCubit cubit, BuildContext context) {
    return Form(
      key: _key,
      child: Container(
        color: containerColor(cubit),
        padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '$date - $time',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TitleTextField(titleController: _titleController),
            ContentTextField(contentController: _contentController),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(NoteCubit cubit, BuildContext context) {
    return AppBar(
      iconTheme:
          IconThemeData(color: cubit.isDark ? Colors.white : Colors.black54),
      title: Text(
        screenName,
        style: Theme.of(context).textTheme.headline6,
      ),
      backgroundColor: containerColor(cubit, isDarkAppBar: true),
      actions: [
        cubit.isDark
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  buildShowModalBottomSheet(cubit, context);
                }),
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              screenName == 'Add Note'
                  ? _addNoteMethod(cubit)
                  : _editNoteMethod(cubit);
            }),
      ],
    );
  }

  Color containerColor(NoteCubit cubit, {bool isDarkAppBar = false}) {
    if (cubit.isDark) {
      if (isDarkAppBar) {
        return kAppBarDarkColor;
      }
      return kDarkModeColor;
    }
    if (screenName == 'Edit Note' && cubit.backgroundColor == null) {
      cubit.changeBackgroundColor(note!.color!);
      return Color(cubit.backgroundColor!);
    } else if (cubit.backgroundColor == null) {
      return kMyPrimaryColor;
    } else {
      return Color(cubit.backgroundColor!);
    }
  }

  Future buildShowModalBottomSheet(NoteCubit cubit, BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) => BottomSheet(
            onClosing: () {
              Navigator.of(context).pop();
            },
            builder: (context) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  child: colorPickerBar(cubit, context),
                )));
  }

  Widget colorPickerBar(NoteCubit cubit, context) {
    return Wrap(
        children: kColorPickerList
            .map((e) => InkWell(
                  onTap: () {
                    cubit.changeBackgroundColor(e);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(e),
                    ),
                  ),
                ))
            .toList());
  }

  _addNoteMethod(NoteCubit cubit) async {
    if (!_key.currentState!.validate()) {
      return kToast('Empty content');
    } else {
      Note note = Note(
          id: DateTime.now().microsecondsSinceEpoch,
          title: _titleController.text.isEmpty
              ? _titleController.text = 'Untitled'
              : _titleController.text,
          content: _contentController.text,
          color: _addColor(cubit),
          date: date,
          time: time,
          editDate: date,
          editTime: time);

      await cubit.insertNote(note);
    }
  }

  int? _addColor(NoteCubit cubit) {
    if (cubit.backgroundColor == null) {
      return kColorPickerList[0];
    }
    return cubit.backgroundColor;
  }

  _editNoteMethod(NoteCubit cubit) async {
    if (_titleController.text == note!.title &&
        _contentController.text == note!.content) {
      print('No edit');
    }
    if (!_key.currentState!.validate()) {
      return kToast('Empty content');
    } else {
      Note updatedNote = Note(
          id: note!.id,
          title: _titleController.text == note!.title
              ? note!.title
              : _titleController.text,
          content: _contentController.text == note!.content
              ? note!.content
              : _contentController.text,
          color: _editColor(cubit),
          date: note!.date,
          time: note!.time,
          editDate: date,
          editTime: time);
      await cubit.updateNote(updatedNote);
    }
  }

  int? _editColor(NoteCubit cubit) {
    if (cubit.backgroundColor == null) {
      return note!.color;
    }
    return cubit.backgroundColor;
  }
}
