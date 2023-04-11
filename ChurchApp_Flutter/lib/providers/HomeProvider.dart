import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';
import '../models/Radios.dart';
import '../models/LiveStreams.dart';

class HomeProvider with ChangeNotifier {
  var data = {
    "sliders": [],
    "website": "",
    "livestream": {},
    "radios": {},
    "image1": "",
    "image2": "",
    "image3": "",
    "image4": "",
    "image5": "",
    "image6": "",
    "facebook_page": "",
    "youtube_page": "",
    "twitter_page": "",
    "instagram_page": "",
  };

  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  bool isLoading = true;

  loadItems() {
    print("Initializing home fragment");
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.DISCOVER,
        data: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata.email,
            "version": "v2"
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;

        dynamic res = jsonDecode(response.data);
        print(res);
        data['sliders'] = parseSliderMedia(res);
        data['website'] = res['website_url'];
        data['livestream'] = parseLiveStreams(res);
        data['radios'] = parseRadio(res);
        data['image1'] = res['image_one'];
        data['image2'] = res['image_one'];
        data['image3'] = res['image_three'];
        data['image4'] = res['image_four'];
        data['image5'] = res['image_five'];
        data['image6'] = res['image_six'];
        data['facebook_page'] = res['facebook_page'];
        data['youtube_page'] = res['youtube_page'];
        data['twitter_page'] = res['twitter_page'];
        data['instagram_page'] = res['instagram_page'];
        print(data);
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static Radios parseRadio(dynamic res) {
    return Radios.fromJson(res["radios"]);
  }

  static LiveStreams parseLiveStreams(dynamic res) {
    return LiveStreams.fromJson(res["livestream"]);
  }

  static List<Media> parseSliderMedia(dynamic res) {
    final parsed = res["slider_media"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  setFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }
}
