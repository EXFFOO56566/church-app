import 'package:flutter/material.dart';
import '../utils/TextStyles.dart';

class EmptyListScreen extends StatelessWidget {
  final String message;

  const EmptyListScreen({
    Key key,
    @required this.message,
  })  : assert(message != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(message,
              textAlign: TextAlign.center,
              style: TextStyles.medium(context).copyWith(
                  //color: MyColors.primary
                  )),
        ),
      ),
    );
  }
}
