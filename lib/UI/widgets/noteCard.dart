import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simplenote/UI/constants/constants.dart';
import 'package:simplenote/core/bloc/note_cubit/note_cubit.dart';
import 'dart:ui' as ui;
import 'package:simplenote/core/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final NoteCubit cubit;

  const NoteCard(this.note, this.cubit);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cubit.isDark ? Colors.white : Colors.black),
              ),
              Text(
                '${note.time}',
                style: TextStyle(
                    height: 1,
                    color: cubit.isDark ? Colors.white : Colors.black),
              ),
              Text(
                '${note.date}',
                style: TextStyle(
                    color: cubit.isDark ? Colors.white : Colors.black),
              )
            ],
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              await cubit.getSingleNote(note.id!);
            },
            child: Card(
              color: cubit.isDark ? kDarkModeColor : Color(note.color!),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: cubit.isDark
                      ? BorderSide(
                          color: note.color != kDarkModeInt
                              ? Color(note.color!)
                              : Colors.white)
                      : BorderSide.none),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ListTile(
                      title: noteText('${note.title}', context, isTitle: true),
                      subtitle: noteText('${note.content}', context)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  noteText(String text, context, {bool isTitle = false}) {
    return Text(
      text,
      textDirection: isRTL(text) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: isTitle ? 1 : 2,
    );
  }
}
