import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Categories.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/Media.dart';
import '../providers/CategoryMediaScreensModel.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/MediaItemTile.dart';
import '../screens/NoitemScreen.dart';
import '../i18n/strings.g.dart';

class CategoriesMediaScreen extends StatelessWidget {
  static const routeName = "/categoriesmedia";
  final Categories categories;
  CategoriesMediaScreen({this.categories});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryMediaScreensModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            categories.title + " " + t.category,
            maxLines: 1,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(0),
          child: MediaScreen(
            categories: categories,
          ),
        ),
      ),
    );
  }
}

class MediaScreen extends StatefulWidget {
  final Categories categories;
  MediaScreen({this.categories});

  @override
  _CategoriesMediaScreenState createState() => _CategoriesMediaScreenState();
}

class _CategoriesMediaScreenState extends State<MediaScreen> {
  CategoryMediaScreensModel mediaScreensModel;
  List<Media> items;

  void _onRefresh() async {
    mediaScreensModel.loadItems(widget.categories.id);
  }

  void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<CategoryMediaScreensModel>(context, listen: false)
          .loadItems(widget.categories.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaScreensModel = Provider.of<CategoryMediaScreensModel>(context);
    items = mediaScreensModel.mediaList;

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: mediaScreensModel.refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (mediaScreensModel.isError == true && items.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  mediaList: items,
                  index: index,
                  object: items[index],
                );
              },
            ),
    );
  }
}
