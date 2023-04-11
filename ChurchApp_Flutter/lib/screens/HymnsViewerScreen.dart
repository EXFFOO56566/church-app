import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../utils/img.dart';
import '../models/Hymns.dart';
import '../utils/TextStyles.dart';
import '../i18n/strings.g.dart';

class HymnsViewerScreen extends StatefulWidget {
  static const routeName = "/hymnsviewer";
  const HymnsViewerScreen({Key key, this.hymns}) : super(key: key);
  final Hymns hymns;

  @override
  _HymnsViewerScreenState createState() => _HymnsViewerScreenState();
}

class _HymnsViewerScreenState extends State<HymnsViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.hymns),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(widget.hymns.title,
                      textAlign: TextAlign.center,
                      style: TextStyles.headline(context)
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Container(height: 20),
                Container(
                  height: 200,
                  //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.hymns.thumbnail,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black12, BlendMode.darken)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Center(
                          child: Image.asset(
                        Img.get('worship.jpg'),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        //color: Colors.black26,
                      )),
                    ),
                  ),
                ),
                Container(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: HtmlWidget(
                    widget.hymns.content,
                    webView: false,
                    textStyle:
                        TextStyles.medium(context).copyWith(fontSize: 20),
                  ),
                ),
                Container(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
