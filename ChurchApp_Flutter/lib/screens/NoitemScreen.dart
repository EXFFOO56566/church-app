import 'package:flutter/material.dart';
import '../utils/TextStyles.dart';
import '../utils/my_colors.dart';
import '../i18n/strings.g.dart';

class NoitemScreen extends StatelessWidget {
  final String title;
  final String message;
  final Function onClick;

  const NoitemScreen({
    Key key,
    @required this.title,
    @required this.message,
    @required this.onClick,
  })  : assert(title != null),
        assert(message != null),
        assert(onClick != null),
        super(key: key);

  void onItemClick() {
    onClick();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: InkWell(
          onTap: () {
            onItemClick();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(title,
                  style: TextStyles.display1(context).copyWith(
                      //color: MyColors.primary,
                      fontWeight: FontWeight.bold)),
              Container(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyles.medium(context).copyWith(
                        //color: MyColors.primary
                        )),
              ),
              Container(height: 25),
              Container(
                width: 180,
                height: 40,
                child: TextButton(
                  child: Text(t.retry, style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    onItemClick();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
