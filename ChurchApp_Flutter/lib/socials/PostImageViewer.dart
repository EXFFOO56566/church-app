import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostImageViewer extends StatelessWidget {
  const PostImageViewer({
    Key key,
    this.imgURL,
  }) : super(key: key);
  final String imgURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        imageUrl: imgURL,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black12, BlendMode.darken)),
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
    );
  }
}
