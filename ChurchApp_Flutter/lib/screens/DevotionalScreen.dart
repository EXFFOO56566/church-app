import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../utils/img.dart';
import '../utils/ApiUrl.dart';
import '../models/Devotionals.dart';
import '../utils/TextStyles.dart';
import 'NoitemScreen.dart';
import 'package:intl/intl.dart';
import '../i18n/strings.g.dart';

class DevotionalScreen extends StatefulWidget {
  static const routeName = "/devotionals";

  @override
  _DevotionalScreenState createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends State<DevotionalScreen> {
  DateTime selectedDate = DateTime.now();
  String _selecteddate = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
        print(_selecteddate);
      });
    } else {
      print("picked null" + picked.toString());
    }
  }

  @override
  void initState() {
    _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.devotionals),
        actions: [
          SizedBox(
            height: 38,
            width: 38,
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              onTap: () {
                setState(() {
                  selectedDate = selectedDate.subtract(new Duration(days: 1));
                  _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
                });
              },
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(
                    DateFormat('d MMM').format(selectedDate),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 38,
            width: 38,
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              onTap: () {
                setState(() {
                  selectedDate = selectedDate.add(new Duration(days: 1));
                  _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
                });
              },
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: SingleChildScrollView(
          child: DevotionalsPageBody(
            key: UniqueKey(),
            date: _selecteddate,
            dateTime: selectedDate,
          ),
        ),
      ),
    );
  }
}

class DevotionalsPageBody extends StatefulWidget {
  const DevotionalsPageBody({Key key, this.date, this.dateTime})
      : super(key: key);
  final String date;
  final DateTime dateTime;

  @override
  _BranchesPageBodyState createState() => _BranchesPageBodyState();
}

class _BranchesPageBodyState extends State<DevotionalsPageBody> {
  bool isLoading = true;
  bool isError = false;
  Devotionals devotionals;

  Future<void> loadItems() async {
    print(widget.date);
    setState(() {
      isLoading = true;
    });
    try {
      final dio = Dio();

      final response = await dio.post(
        ApiUrl.DEVOTIONALS,
        data: jsonEncode({
          "data": {"date": widget.date}
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        setState(() {
          isLoading = false;
          devotionals = Devotionals.fromJson(res['devotional']);
          print(widget.date);
          print(devotionals);
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setState(() {
          isLoading = false;
          isError = true;
          print(devotionals);
        });
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 600,
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
      );
    } else if (isError || devotionals == null) {
      return Container(
        height: 600,
        child: Center(
          child: NoitemScreen(
              title: t.oops,
              message: t.dataloaderror,
              onClick: () {
                loadItems();
              }),
        ),
      );
    } else
      return Container(
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(devotionals.title,
                textAlign: TextAlign.center,
                style: TextStyles.headline(context)
                    .copyWith(fontWeight: FontWeight.bold)),
            Container(height: 5),
            Text(devotionals.author,
                textAlign: TextAlign.start,
                style: TextStyles.subhead(context)
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
            Divider(height: 5),
            Text(DateFormat('EEE, MMM d, yyyy').format(widget.dateTime),
                textAlign: TextAlign.justify,
                style: TextStyles.subhead(context).copyWith(fontSize: 16)),
            Container(height: 20),
            Container(
              height: 200,
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: CachedNetworkImage(
                  imageUrl: devotionals.thumbnail,
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
                    Img.get('devotionals.jpg'),
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    //color: Colors.black26,
                  )),
                ),
              ),
            ),
            Container(height: 20),
            HtmlWidget(
              devotionals.biblereading,
              webView: false,
              textStyle: TextStyles.medium(context).copyWith(fontSize: 17),
            ),
            Container(height: 20),
            HtmlWidget(
              devotionals.content,
              webView: false,
              textStyle: TextStyles.medium(context).copyWith(fontSize: 20),
            ),
            Container(height: 20),
            HtmlWidget(
              devotionals.confession,
              webView: false,
              textStyle: TextStyles.medium(context).copyWith(fontSize: 20),
            ),
            Container(height: 20),
            HtmlWidget(
              devotionals.studies,
              webView: false,
              textStyle: TextStyles.medium(context).copyWith(fontSize: 20),
            ),
          ],
        ),
      );
  }
}
