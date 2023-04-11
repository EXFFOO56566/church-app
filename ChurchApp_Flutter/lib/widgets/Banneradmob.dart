import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utils/Adverts.dart';

class Banneradmob extends StatelessWidget {
  const Banneradmob({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(bottom: 0.0),
        child: AdmobBanner(
          adUnitId: Adverts.getBannerAdUnitId(),
          adSize: AdmobBannerSize.BANNER,
          /* listener:
                          (AdmobAdEvent event, Map<String, dynamic> args) {
                        handleEvent(event, args, 'Banner');
                      },*/
          onBannerCreated: (AdmobBannerController controller) {
            // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
            // Normally you don't need to worry about disposing this yourself, it's handled.
            // If you need direct access to dispose, this is your guy!
            // controller.dispose();
          },
        ),
      ),
    );
  }
}
