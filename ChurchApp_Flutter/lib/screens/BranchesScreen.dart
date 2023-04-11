import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/ApiUrl.dart';
import '../models/Branches.dart';
import '../utils/TextStyles.dart';
import 'NoitemScreen.dart';
import '../i18n/strings.g.dart';

class BranchesScreen extends StatelessWidget {
  static const routeName = "/branches";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.branches),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: BranchesPageBody(),
      ),
    );
  }
}

class BranchesPageBody extends StatefulWidget {
  @override
  _BranchesPageBodyState createState() => _BranchesPageBodyState();
}

class _BranchesPageBodyState extends State<BranchesPageBody> {
  bool isLoading = true;
  bool isError = false;
  List<Branches> items = [];

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.get(
        ApiUrl.FETCH_BRANCHES,
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Branches> _items = parseBranches(res);
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

  static List<Branches> parseBranches(dynamic res) {
    // final res = jsonDecode(responseBody);
    final parsed = res["branches"].cast<Map<String, dynamic>>();
    return parsed.map<Branches>((json) => Branches.fromJson(json)).toList();
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
            branches: items[index],
          );
        },
      );
  }
}

class ItemTile extends StatelessWidget {
  final Branches branches;
  final int index;

  const ItemTile({
    Key key,
    @required this.index,
    @required this.branches,
  })  : assert(index != null),
        assert(branches != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        elevation: 0.9,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: <Widget>[
              Container(width: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(branches.name,
                    maxLines: 2,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
              Container(height: 5),
              Row(
                children: <Widget>[
                  Container(width: 6),
                  Text(branches.pastor,
                      style: TextStyles.subhead(context).copyWith())
                ],
              ),
              Container(height: 20),
              Row(
                children: <Widget>[
                  ClipOval(
                      child: Container(
                    color: Theme.of(context).accentColor.withAlpha(30),
                    width: 50.0,
                    height: 50.0,
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.phone,
                      ),
                    ),
                  )),
                  Container(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(branches.phone,
                          style: TextStyles.subhead(context)
                              .copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              Container(height: 10),
              Row(
                children: <Widget>[
                  ClipOval(
                      child: Container(
                    color: Theme.of(context).accentColor.withAlpha(30),
                    width: 50.0,
                    height: 50.0,
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.email,
                      ),
                    ),
                  )),
                  Container(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(branches.email,
                          style: TextStyles.subhead(context)
                              .copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Spacer(),
                ],
              ),
              Container(height: 10),
              Row(
                children: <Widget>[
                  ClipOval(
                      child: Container(
                    color: Theme.of(context).accentColor.withAlpha(30),
                    width: 50.0,
                    height: 50.0,
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      onPressed: () {},
                      icon: Icon(
                        Icons.location_on,
                      ),
                    ),
                  )),
                  Container(width: 15),
                  Expanded(
                    child: Text(
                      branches.address,
                      style: TextStyles.subhead(context)
                          .copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
