import 'package:churchapp_flutter/notes/NotesEditorScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import '../models/ScreenArguements.dart';
import 'package:provider/provider.dart';
import '../providers/NotesProvider.dart';
import 'NewNoteScreen.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:toast/toast.dart';
import '../utils/my_colors.dart';
import '../utils/TimUtil.dart';
import '../models/Notes.dart';
import '../i18n/strings.g.dart';
import '../utils/TextStyles.dart';
import '../screens/EmptyListScreen.dart';
import 'package:flutter_quill/models/documents/document.dart';

class NotesListScreen extends StatefulWidget {
  static const routeName = "/noteslist";
  @override
  NotesListScreenRouteState createState() => NotesListScreenRouteState();
}

class NotesListScreenRouteState extends State<NotesListScreen> {
  NotesProvider notesProvider;
  ScrollController controller;
  bool fabIsVisible = true;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        fabIsVisible =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notesProvider = Provider.of<NotesProvider>(context);
    List<Notes> items = notesProvider.notesList;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onChanged: (term) {
            if (term.length > 0) {
              notesProvider.searchNotes(term);
              showClear = true;
            } else if (term.length == 0) {
              showClear = false;
              notesProvider.getNotes();
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.notes,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    setState(() {
                      query = "";
                    });
                    notesProvider.getNotes();
                  },
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: (items.length == 0)
            ? EmptyListScreen(message: t.nonotesfound)
            : ListView.builder(
                controller: controller,
                itemCount: items.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(3),
                itemBuilder: (BuildContext context, int index) {
                  return ItemTile(
                    object: items[index],
                    notesProvider: notesProvider,
                  );
                },
              ),
      ),
      floatingActionButton: AnimatedOpacity(
        child: FloatingActionButton.extended(
          backgroundColor: MyColors.primary,
          onPressed: () {
            Navigator.of(context).pushNamed(NewNotesScreen.routeName);
          },
          icon: Icon(Icons.add_circle),
          label: Text(t.newnote),
        ),
        duration: Duration(milliseconds: 100),
        opacity: fabIsVisible ? 1 : 0,
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final Notes object;
  final NotesProvider notesProvider;

  const ItemTile({
    Key key,
    @required this.object,
    @required this.notesProvider,
  })  : assert(object != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(NotesEditorScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: object,
              itemsList: [],
            ));
      },
      child: Container(
        height: 110,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(0, 5, 15, 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: object.color,
                      child: Text(
                        object.title.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              TimUtil.formatMilliSecondsFullDatestamp(
                                  object.date),
                              style: TextStyles.caption(context)
                                  .copyWith(fontSize: 15),
                            ),
                            Spacer(),
                            Text(
                                TimUtil.formatMilliSecondsFullDTime(
                                    object.date),
                                style: TextStyles.caption(context)
                                //.copyWith(color: MyColors.grey_60),
                                ),
                          ],
                        ),
                        Container(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(object.title,
                              maxLines: 1,
                              style: TextStyles.subhead(context).copyWith(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Spacer(),
                InkWell(
                  child: Icon(Icons.share, color: Colors.lightBlue, size: 21.0),
                  onTap: () async {
                    /*final doc = Document.fromJson(jsonDecode(object.content));
                    QuillController _controller = QuillController(
                        document: doc,
                        selection: const TextSelection.collapsed(offset: 0));*/

                    await FlutterShare.share(
                        title: object.title,
                        text: Document.fromJson(jsonDecode(object.content))
                            .toPlainText());
                  },
                ),
                Container(width: 15),
                InkWell(
                  child: Icon(Icons.content_copy,
                      color: Colors.orange, size: 21.0),
                  onTap: () {
                    FlutterClipboard.copy(
                            Document.fromJson(jsonDecode(object.content))
                                .toPlainText())
                        .then((value) =>
                            Toast.show(t.copiedtoclipboard, context));
                  },
                ),
                Container(width: 15),
                InkWell(
                  child:
                      Icon(Icons.delete_forever, color: Colors.red, size: 21.0),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => new CupertinoAlertDialog(
                        title: new Text(t.deletenote),
                        content: new Text(t.deletenotehint),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text(t.cancel),
                          ),
                          new TextButton(
                            onPressed: () {
                              notesProvider.deleteNote(object);
                              Navigator.of(context).pop();
                            },
                            child: new Text(t.ok),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Divider(
              height: 0.1,
              //color: Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }
}
