import 'package:flutter/material.dart';
import 'package:simplenote/UI/constants/constants.dart';
import 'dart:ui' as ui;

class TitleTextField extends StatelessWidget {
  const TitleTextField({
    Key? key,
    required TextEditingController titleController,
  })  : _titleController = titleController,
        super(key: key);

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: Theme.of(context).textTheme.bodyText1,
      controller: _titleController,
      textDirection: isRTL(_titleController.text)
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyText1,
          hintText: 'Title',
          contentPadding: const EdgeInsets.all(10)),
    );
  }
}
