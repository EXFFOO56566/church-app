import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../screens/EventsViewerScreen.dart';
import '../models/ScreenArguements.dart';
import 'dart:async';
import 'dart:convert';
import '../utils/img.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/ApiUrl.dart';
import '../models/Events.dart';
import '../utils/TextStyles.dart';
import 'NoitemScreen.dart';
import 'package:intl/intl.dart';
import '../i18n/strings.g.dart';

class EventsListScreen extends StatefulWidget {
  static const routeName = "/eventslist";

  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
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
        title: Text(t.events),
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
        child: EventsListScreenPageBody(
          key: UniqueKey(),
          date: _selecteddate,
          dateTime: selectedDate,
        ),
      ),
    );
  }
}

class EventsListScreenPageBody extends StatefulWidget {
  const EventsListScreenPageBody({Key key, this.date, this.dateTime})
      : super(key: key);
  final String date;
  final DateTime dateTime;
  @override
  _BranchesPageBodyState createState() => _BranchesPageBodyState();
}

class _BranchesPageBodyState extends State<EventsListScreenPageBody> {
  bool isLoading = true;
  bool isError = false;
  List<Events> items = [];

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiUrl.EVENTS,
        data: jsonEncode({
          "data": {"date": widget.date}
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Events> _items = parseBranches(res);
        setState(() {
          isLoading = false;
          items = _items;
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setState(() {
          isLoading = false;
          isError = true;
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

  static List<Events> parseBranches(dynamic res) {
    // final res = jsonDecode(responseBody);
    final parsed = res["events"].cast<Map<String, dynamic>>();
    return parsed.map<Events>((json) => Events.fromJson(json)).toList();
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
      return Center(
          child: CupertinoActivityIndicator(
        radius: 20,
      ));
    } else if (isError) {
      return NoitemScreen(
          title: t.oops,
          message: t.dataloaderror,
          onClick: () {
            loadItems();
          });
    } else
      return ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(3),
        itemBuilder: (BuildContext context, int index) {
          return ItemTile(
            index: index,
            events: items[index],
          );
        },
      );
  }
}

class ItemTile extends StatelessWidget {
  final Events events;
  final int index;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.events,
  })  : assert(index != null),
        assert(events != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(events.date);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(EventsViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: events,
              itemsList: [],
            ));
      },
      child: Container(
        height: 90,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 40,
                        width: 40,
                        child: CachedNetworkImage(
                          imageUrl: events.thumbnail,
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
                            Img.get('event.jpg'),
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                            //color: Colors.black26,
                          )),
                        ),
                      )),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                                DateFormat('EEE, MMM d, yyyy').format(tempDate),
                                style: TextStyles.caption(context)
                                //.copyWith(color: MyColors.grey_60),
                                ),
                            Spacer(),
                            Text(events.time, style: TextStyles.caption(context)
                                //.copyWith(color: MyColors.grey_60),
                                ),
                          ],
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(events.title,
                              maxLines: 2,
                              style: TextStyles.subhead(context).copyWith(
                                  //color: MyColors.grey_80,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                ],
              ),
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
