import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/BibleModel.dart';
import '../utils/TextStyles.dart';
import 'MarqueeWidget.dart';

class BibleTTSPlayer extends StatefulWidget {
  const BibleTTSPlayer({Key key}) : super(key: key);

  @override
  _AudioPlayout createState() => _AudioPlayout();
}

class _AudioPlayout extends State<BibleTTSPlayer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BibleModel>(
      builder: (context, bibleModel, child) {
        return !bibleModel.isReadingBible
            ? Container()
            : Container(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  margin: EdgeInsets.all(0),
                  elevation: 10,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 15,
                        ),
                        Expanded(
                          child: MarqueeWidget(
                            direction: Axis.horizontal,
                            child: Text(
                              bibleModel.currentReadBibleTitle,
                              maxLines: 1,
                              style: TextStyles.subhead(context)
                                  .copyWith(fontSize: 15),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DropdownButton(
                                value: bibleModel.language,
                                items:
                                    bibleModel.getLanguageDropDownMenuItems(),
                                onChanged:
                                    bibleModel.changedLanguageDropDownItem,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 15,
                        ),
                        ClipOval(
                          child: Container(
                            color: Theme.of(context).accentColor.withAlpha(30),
                            width: 50.0,
                            height: 50.0,
                            child: IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              onPressed: () {
                                bibleModel.stop();
                              },
                              icon: Icon(
                                Icons.stop,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
