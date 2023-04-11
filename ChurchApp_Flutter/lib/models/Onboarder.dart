import '../utils/StringsUtils.dart';

class Onboarder {
  String image;
  String title;
  String hint;

  static List<Onboarder> getOnboardingItems(
      List<String> onboardertitle, List<String> onboarderhints) {
    List<Onboarder> items = [];
    for (int i = 0; i < onboardertitle.length; i++) {
      Onboarder obj = new Onboarder();
      obj.image = StringsUtils.onboarder_image[i];
      obj.title = onboardertitle[i];
      obj.hint = onboarderhints[i];
      items.add(obj);
    }
    return items;
  }
}
