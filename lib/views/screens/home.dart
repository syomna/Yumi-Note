import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplenote/views/constants/constants.dart';
import 'package:simplenote/views/screens/add.dart';
import 'package:simplenote/views/screens/details.dart';
import 'package:simplenote/views/widgets/noteCard.dart';
import 'package:simplenote/core/bloc/note_cubit/note_cubit.dart';
import 'package:simplenote/core/bloc/note_states/note_states.dart';
import 'package:simplenote/core/models/note_model.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteStates>(
      listener: (context, state) {
        if (state is NoteGetDetailsSuccessState) {
          navigateTo(context, NoteDetails());
        }
      },
      builder: (context, state) {
        var cubit = NoteCubit.get(context);
        return Scaffold(
            appBar: _appBar(context, cubit),
            floatingActionButton: _floatingButton(context),
            body: Container(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: RefreshIndicator(
                onRefresh: () async => await cubit.getNotes(),
                child: cubit.notes.isEmpty
                    ? Center(
                        child: Text(
                          'No Notes',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    : buildNotes(
                        cubit.filteredList.isNotEmpty
                            ? cubit.filteredList
                            : cubit.notes,
                        cubit),
              ),
            ));
      },
    );
  }

  FloatingActionButton _floatingButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          navigateTo(
              context,
              Add(
                screenName: 'Add Note',
              ));
        },
        backgroundColor: kMyPrimaryColor,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ));
  }

  AppBar _appBar(BuildContext context, NoteCubit cubit) {
    return AppBar(
      title: cubit.isSeachPressed
          ? TextField(
              onChanged: (value) {
                cubit.searchNote(value);
              },
              decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: Theme.of(context).textTheme.bodyText1),
            )
          : Text(
              'My Notes',
              style: Theme.of(context).textTheme.headline6?.copyWith(
                  color: cubit.isDark
                      ? Colors.white
                      : Colors.green.withOpacity(0.8)),
            ),
      actions: [
        IconButton(
            onPressed: () {
              cubit.onSearchPressed();
            },
            icon: Icon(cubit.isSeachPressed ? Icons.close : Icons.search,
                color: cubit.isDark ? Colors.white : Colors.indigo)),
        IconButton(
            onPressed: () {
              cubit.changeTheme();
            },
            icon: Icon(
              cubit.isDark ? Icons.light_rounded : Icons.dark_mode,
              color: cubit.isDark ? Colors.white : Colors.indigo,
            )),
      ],
    );
  }

  Widget buildNotes(List<Note> note, NoteCubit cubit) {
    return ListView.separated(
        itemBuilder: (context, i) {
          return NoteCard(note[i], cubit);
        },
        separatorBuilder: (context, i) {
          return const SizedBox(
            height: 4,
          );
        },
        itemCount: note.length);
  }
}
