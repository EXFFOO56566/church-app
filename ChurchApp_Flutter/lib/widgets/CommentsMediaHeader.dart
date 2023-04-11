import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/Media.dart';
import '../utils/TextStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommentsMediaHeader extends StatelessWidget {
  final Media object;

  const CommentsMediaHeader({
    Key key,
    @required this.object,
  })  : assert(object != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // final articlesModel = Provider.of<ArticlesModel>(context);
    return InkWell(
      onTap: () {},
      child: Container(
        height: 70,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
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
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl: object.coverPhoto,
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
                              child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          )),
                        ),
                      )),
                  Container(width: 10),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(object.title,
                          maxLines: 2,
                          style: TextStyles.subhead(context).copyWith(
                              //color: MyColors.grey_80,
                              fontWeight: FontWeight.w500)),
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
