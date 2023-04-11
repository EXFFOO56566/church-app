import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AudioPlayerModel.dart';

class RadioCarousal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioPlayerModel radioPlayerModel = Provider.of<AudioPlayerModel>(context);
    return Column(
      children: _controllers(context, radioPlayerModel),
    );
  }

  List<Widget> _controllers(
      BuildContext context, AudioPlayerModel radioPlayerModel) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ClipOval(
                child: Container(
              color: Theme.of(context).accentColor.withAlpha(30),
              width: 100.0,
              height: 100.0,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                onPressed: () {
                  radioPlayerModel.onPressed();
                },
                icon: radioPlayerModel.icon(),
              ),
            )),
          ],
        ),
      ),
    ];
  }
}
