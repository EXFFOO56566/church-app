import 'dart:convert';

import 'package:churchapp_flutter/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/toolbar.dart';

typedef DemoContentBuilder = Widget Function(
    BuildContext context, QuillController controller);

// Common scaffold for all examples.
class NoteScaffold extends StatefulWidget {
  const NoteScaffold({
    this.content,
    this.builder,
    this.actions,
    this.showToolbar = true,
    this.floatingActionButton,
    Key key,
  }) : super(key: key);

  /// Filename of the document to load into the editor.
  final String content;
  final DemoContentBuilder builder;
  final List<Widget> actions;
  final Widget floatingActionButton;
  final bool showToolbar;

  @override
  _DemoScaffoldState createState() => _DemoScaffoldState();
}

class _DemoScaffoldState extends State<NoteScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  QuillController _controller;

  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null && !_loading) {
      _loading = true;
      _loadFromAssets();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadFromAssets() async {
    try {
      final doc = Document.fromJson(jsonDecode(widget.content));
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
        _loading = false;
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actions ?? <Widget>[];
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              Icons.backspace,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(t.notes),
          actions: actions,
        ),
        floatingActionButton: widget.floatingActionButton,
        body: Column(
          children: [
            _loading || widget.showToolbar == false
                ? Container()
                : QuillToolbar.basic(controller: _controller),
            Expanded(
              child: _loading
                  ? const Center(child: Text('Loading...'))
                  : widget.builder(context, _controller),
            )
          ],
        ));
  }
}
