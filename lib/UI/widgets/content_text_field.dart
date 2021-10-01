import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:simplenote/UI/constants/constants.dart';

class ContentTextField extends StatelessWidget {
  const ContentTextField({
    Key? key,
    required TextEditingController contentController,
  })  : _contentController = contentController,
        super(key: key);

  final TextEditingController _contentController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyText1,
        validator: (value) => value!.isEmpty ? 'Add some text' : null,
        controller: _contentController,
        textDirection: isRTL(_contentController.text)
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.bodyText1,
            hintText: 'Content',
            contentPadding: const EdgeInsets.all(10)),
      ),
    );
  }
}
