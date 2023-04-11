import 'dart:convert';
import 'dart:math';

import 'package:churchapp_flutter/i18n/strings.g.dart';
import 'package:churchapp_flutter/models/Notes.dart';
import 'package:churchapp_flutter/providers/NotesProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:provider/provider.dart';
import 'note_scaffold.dart';

class NotesEditorScreen extends StatefulWidget {
  static const routeName = "/noteditor";
  const NotesEditorScreen({Key key, this.notes}) : super(key: key);
  final Notes notes;
  @override
  _NotesEditorPageState createState() => _NotesEditorPageState();
}

class _NotesEditorPageState extends State<NotesEditorScreen> {
  final FocusNode _focusNode = FocusNode();
  QuillController _controller;
  bool _edit = false;

  @override
  Widget build(BuildContext context) {
    return NoteScaffold(
      content: widget.notes.content,
      builder: _buildContent,
      showToolbar: _edit == true,
      floatingActionButton: FloatingActionButton.extended(
          label: Text(_edit == true ? 'Done' : 'Edit'),
          onPressed: _toggleEdit,
          icon: Icon(_edit == true ? Icons.check : Icons.edit)),
    );
  }

  Widget _buildContent(BuildContext context, QuillController controller) {
    _controller = controller;
    var quillEditor = QuillEditor(
      controller: controller,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: true,
      readOnly: !_edit,
      expands: false,
      padding: EdgeInsets.zero,
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: quillEditor,
      ),
    );
  }

  void _toggleEdit() {
    if (_edit) {
      String name = widget.notes == null ? "" : widget.notes.title;
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                t.savenotetitle,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    t.cancel,
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    t.ok,
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    if (name != "") {
                      Provider.of<NotesProvider>(context, listen: false)
                          .saveNote(
                        new Notes(
                          title: name,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          content: jsonEncode(
                              _controller.document.toDelta().toJson()),
                          date: widget.notes.date,
                          id: widget.notes.id,
                        ),
                      );
                      // Navigator.pop(context);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
              content: TextField(
                controller: TextEditingController(
                    text: widget.notes == null ? "" : widget.notes.title),
                autofocus: true,
                onChanged: (text) {
                  name = text;
                },
                // cursorColor: Colors.black,
              ),
            );
          }).then((val) {
        setState(() {
          _edit = false;
        });
      });
    } else {
      setState(() {
        _edit = !_edit;
      });
    }
  }
}
