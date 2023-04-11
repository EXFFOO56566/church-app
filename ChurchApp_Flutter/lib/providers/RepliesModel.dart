import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../i18n/strings.g.dart';
import '../utils/Utility.dart';
import '../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../utils/ApiUrl.dart';
import '../models/Replies.dart';
import '../models/Userdata.dart';

class RepliesModel with ChangeNotifier {
  List<Replies> _items = [];
  bool isError = false;
  int commentId = 0;
  int totalCommentsReply = 0;
  Userdata userdata;
  bool isLoading = false;
  bool isMakingComment = false;
  bool isMakingCommentsError = false;
  bool hasMoreComments = false;
  bool isLoadingMore = false;
  ScrollController scrollController = new ScrollController();
  final TextEditingController inputController = new TextEditingController();
  final TextEditingController editController = new TextEditingController();
  BuildContext _context;

  RepliesModel(BuildContext context, int commentId, Userdata userdata,
      int totalCommentsReply) {
    _context = context;
    this.commentId = commentId;
    this.userdata = userdata;
    this.totalCommentsReply = totalCommentsReply;
    loadComments();
  }

  bool isUser(String email) {
    if (userdata == null) return false;
    return email == userdata.email;
  }

  loadComments() {
    isLoading = true;
    notifyListeners();
    fetchComments();
  }

  setCommentPostDetails() {}

  List<Replies> get items {
    return _items;
  }

  void setComments(List<Replies> item) {
    _items.clear();
    _items = item.reversed.toList();
    if (item.length == 0)
      isError = true;
    else
      isError = false;
    isLoading = false;
    notifyListeners();
    if (items.length > 2) {
      if (scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: 50), () {
          scrollController?.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  void setComment(Replies item) {
    items.add(item);
    isMakingComment = false;
    inputController.clear();
    notifyListeners();
    if (items.length > 2) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void setMoreArticles(List<Replies> item) {
    _items.insertAll(0, item.reversed.toList());
    isLoadingMore = false;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    //notifyListeners();
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.loadreplies),
          body: jsonEncode({
            "data": {"id": 0, "comment": commentId}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        Map<String, dynamic> res = json.decode(response.body);
        hasMoreComments = res["has_more"];
        List<Replies> comments = await compute(parseComments, response.body);
        setComments(comments);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setCommentsFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setCommentsFetchError();
    }
  }

  setCommentsFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }

  loadMoreComments() {
    isLoadingMore = true;
    fetchMoreComments();
    notifyListeners();
  }

  Future<void> fetchMoreComments() async {
    try {
      final response = await http.post(Uri.parse(ApiUrl.loadreplies),
          body: jsonEncode({
            "data": {"id": items[0].id, "comment": commentId}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        hasMoreComments = res["has_more"];
        List<Replies> articles = await compute(parseComments, response.body);
        setMoreArticles(articles);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        loadMoreCommentsError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      loadMoreCommentsError();
    }
  }

  loadMoreCommentsError() {
    isLoadingMore = false;
    notifyListeners();
    Alerts.showCupertinoAlert(_context, t.error, t.errorloadingmorecomments);
  }

  makeComment(String content) {
    isMakingComment = true;
    constructComment(content);
    notifyListeners();
  }

  Future<void> constructComment(String content) async {
    try {
      var data = {
        "content": Utility.getBase64EncodedString(content),
        "email": userdata.email,
        "comment": commentId
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.replycomment),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          totalCommentsReply = int.parse(res["total_count"]);
          setComment(Replies.fromJson(res["comment"]));
        } else {
          makeCommentsError();
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        makeCommentsError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      makeCommentsError();
    }
  }

  makeCommentsError() {
    isMakingComment = false;
    notifyListeners();
    Alerts.showCupertinoAlert(_context, t.error, t.errormakingcomments);
  }

  Future<void> showDeleteCommentAlert(int commentId, int position) async {
    return showDialog(
        context: _context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.deletecommentalert),
              content: new Text(t.deletecommentalerttext),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteComment(commentId, position);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> deleteComment(int commentId, int position) async {
    Alerts.showProgressDialog(_context, t.deletingcomment);
    try {
      var data = {"id": commentId, "comment": commentId};
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.deletereply),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          totalCommentsReply = int.parse(res["total_count"]);
          Navigator.of(_context).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage(t.errordeletingcomments);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.errordeletingcomments);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.errordeletingcomments);
    }
  }

  static List<Replies> parseComments(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["comments"].cast<Map<String, dynamic>>();
    return parsed.map<Replies>((json) => Replies.fromJson(json)).toList();
  }

  Future<void> showEditCommentAlert(int commentId, int position) async {
    editController.text =
        Utility.getBase64DecodedString(items[position].content);
    await showDialog<void>(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(Strings.edit_comment_alert),
          content: SingleChildScrollView(
            child: TextFormField(
              controller: editController,
              maxLines: 5,
              minLines: 1,
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(t.cancel),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text(t.save),
                onPressed: () {
                  String text = editController.text;
                  if (text != "") {
                    Navigator.of(context).pop();
                    editComment(commentId, text, position);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> editComment(int id, String content, int position) async {
    Alerts.showProgressDialog(_context, t.editingcomment);
    try {
      var encoded = Utility.getBase64EncodedString(content);
      var data = {
        "content": encoded,
        "id": id,
        "email": userdata.email,
        "comment": commentId
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.editreply),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          Navigator.of(_context).pop();
          items[position].content = encoded;
          notifyListeners();
        } else {
          processingErrorMessage(t.erroreditingcomments);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.erroreditingcomments);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.erroreditingcomments);
    }
  }

  Future<void> reportComment(int commentId, int position, String reason) async {
    Alerts.showProgressDialog(_context, t.reportingComment);
    try {
      var data = {
        "id": commentId,
        "type": "replies",
        "reason": reason,
        "email": userdata.email
      };
      print(data.toString());
      final response = await http.post(Uri.parse(ApiUrl.reportcomment),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String _status = res["status"];
        if (_status == "ok") {
          totalCommentsReply -= 1;
          Navigator.of(_context).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage(t.errorReportingComment);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.errorReportingComment);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.errorReportingComment);
    }
  }

  processingErrorMessage(String msg) {
    Navigator.of(_context).pop();
    Alerts.showCupertinoAlert(_context, t.error, msg);
  }
}
