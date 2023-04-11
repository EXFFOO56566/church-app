import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import '../i18n/strings.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../database/SQLiteDbProvider.dart';
import 'package:http/http.dart' as http;
import '../models/Categories.dart';
import '../utils/ApiUrl.dart';
import '../models/Userdata.dart';
import '../models/Media.dart';

class CategoryMediaScreensModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  Userdata userdata;
  List<Media> mediaList = [];
  List<Categories> subCategoriesList = [];
  int category = 0;
  int selectedSubCategory = 0;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;

  CategoryMediaScreensModel() {
    this.mediaList = [];
    getUserData();
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
  }

  loadItems(int category) {
    this.category = category;
    refreshController.requestRefresh();
    page = 0;
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<Media> item) {
    mediaList.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<Media> item) {
    mediaList.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  bool isSubcategorySelected(int index) {
    Categories categories = subCategoriesList[index];
    return categories.id == selectedSubCategory;
  }

  refreshPageOnCategorySelected(int id) {
    if (id != selectedSubCategory) {
      selectedSubCategory = id;
      notifyListeners();
      loadItems(category);
    }
  }

  Future<void> fetchItems() async {
    try {
      var data = {
        "email": userdata == null ? "null" : userdata.email,
        "sub": selectedSubCategory.toString(),
        "category": category.toString(),
        "version": "v2",
        "page": page.toString()
      };

      final response = await http.post(Uri.parse(ApiUrl.FETCH_CATEGORIES_MEDIA),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        List<Media> mediaList = await compute(parseSliderMedia, response.body);
        if (page == 0) {
          if (subCategoriesList.length == 0) {
            subCategoriesList = await compute(parseCategories, response.body);
            addTopItem();
          }
          setItems(mediaList);
        } else {
          setMoreItems(mediaList);
        }
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

  addTopItem() {
    Categories cats = new Categories(
        id: 0, title: t.allitems, mediaCount: 0, thumbnailUrl: "");
    subCategoriesList.insert(0, cats);
  }

  static List<Media> parseSliderMedia(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["media"].cast<Map<String, dynamic>>();
    return parsed.map<Media>((json) => Media.fromJson(json)).toList();
  }

  static List<Categories> parseCategories(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["subcategories"].cast<Map<String, dynamic>>();
    return parsed
        .map<Categories>((json) => Categories.fromJson2(json))
        .toList();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
