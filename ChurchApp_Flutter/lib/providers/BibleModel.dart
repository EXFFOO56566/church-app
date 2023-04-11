import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_share/flutter_share.dart';
import 'package:clipboard/clipboard.dart';
import 'package:toast/toast.dart';
import '../i18n/strings.g.dart';
import '../utils/StringsUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/Versions.dart';
import '../models/Bible.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/SQLiteDbProvider.dart';

class BibleModel with ChangeNotifier {
  List<String> bibleBooks = [];
  List<int> bibleBooksPages = [];
  List<int> bibleFontSizes = [];
  List<Versions> downloadedBibleList = [];
  List<Bible> highlightedBibleVerses = [];
  List<Bible> coloredHighlightedBibleVerses = [];
  int selectedFontSize = 0;
  int selectedBookLength = 0;
  String selectedVersion = "";
  String language;
  String selectedBook = "Genesis";
  int selectedChapter = 1;
  bool isStartHighlight = false;
  final _versionPreference = "version_preference";
  final _bookPreference = "book_preference";
  final _chapterPreference = "chapter_preference";
  final _fontPreference = "font_preference";
  final _languagePreference = "language_preference";
  int selectedColor = Colors.yellow[500].value;

  BibleModel() {
    getDownloadedBibleList();
    bibleBooks = StringsUtils.bibleBooks;
    bibleBooksPages = StringsUtils.bibleBooksTotalChapters;
    bibleFontSizes = StringsUtils.bibleFontSizes;
    _loadUserBiblePreference();
    initTts();
  }

  getDownloadedBibleList() async {
    downloadedBibleList = await SQLiteDbProvider.db.getAllBibleVersions();
    if (downloadedBibleList.length != 0 && selectedVersion == "") {
      selectedVersion = downloadedBibleList[0].code;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_versionPreference, selectedVersion);
    }
    coloredHighlightedBibleVerses =
        await SQLiteDbProvider.db.getAllColoredVerses();
    print(
        "colored verses = " + coloredHighlightedBibleVerses.length.toString());
    notifyListeners();
    print(downloadedBibleList.length.toString());
    // downloadedBible = await SQLiteDbProvider.db.getAllBible();
  }

  void _loadUserBiblePreference() {
    SharedPreferences.getInstance().then((prefs) {
      selectedVersion = prefs.getString(_versionPreference) ?? "";
      selectedBook = prefs.getString(_bookPreference) ?? "Genesis";
      selectedBookLength = bibleBooksPages[bibleBooks.indexOf(selectedBook)];
      selectedChapter = prefs.getInt(_chapterPreference) ?? 1;
      selectedFontSize = prefs.getInt(_fontPreference) ?? 20;
      language = prefs.getString(_languagePreference) ?? null;
      notifyListeners();
    });
  }

  addDownloadedBibleVersion(Versions versions) async {
    await SQLiteDbProvider.db.insertBibleVersion(versions);
    getDownloadedBibleList();
  }

  bool isBibleVersionDownloaded(Versions versions) {
    Versions itm = downloadedBibleList
        .firstWhere((itm) => itm.id == versions.id, orElse: () => null);
    return itm != null;
  }

  setCurrentSelectedBibleChapter(int chapter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_chapterPreference, chapter);
  }

  setCurrentSelectedFontSize(int font) async {
    selectedFontSize = font;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_fontPreference, font);
  }

  setCurrentSelectedBibleVersion(String version) async {
    selectedVersion = version;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_versionPreference, version);
  }

  setCurrentSelectedBibleBook(String book) async {
    selectedChapter = 1;
    selectedBook = book;
    selectedBookLength = bibleBooksPages[bibleBooks.indexOf(selectedBook)];
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_bookPreference, book);
  }

  Future<List<Bible>> showCurrentBibleData(int _selectedChapter) async {
    return await SQLiteDbProvider.db
        .getAllBible(selectedVersion, selectedBook, _selectedChapter);
  }

  Future<List<Bible>> showCurrentBibleVerseData(int _verse) async {
    return await SQLiteDbProvider.db.getAllBibleByVerse(
        selectedVersion, selectedBook, selectedChapter, _verse);
  }

  Future<List<Bible>> showColoredHighlightedVerses(
      String query, int color) async {
    if (query != "") {
      return await SQLiteDbProvider.db.searchColoredBibleVerses(query);
    } else if (color != 0) {
      return await SQLiteDbProvider.db.filterColoredVersesByColor(color);
    } else {
      return await SQLiteDbProvider.db.getAllColoredVerses();
    }
  }

  Future<List<Bible>> searchBible(String query, String version, String book,
      bool oldtestament, bool newtestament, int limit) async {
    return await SQLiteDbProvider.db
        .searchBible(query, version, book, oldtestament, newtestament, limit);
  }

  bool isBibleColoredHighlighted(Bible bible) {
    Bible itm = coloredHighlightedBibleVerses.firstWhere(
        (itm) => itm.id == bible.id && itm.version == bible.version,
        orElse: () => null);
    return itm != null;
  }

  Bible getBibleColoredHighlightedVerse(Bible bible) {
    Bible itm = coloredHighlightedBibleVerses.firstWhere(
        (itm) => itm.id == bible.id && itm.version == bible.version,
        orElse: () => null);
    return itm;
  }

  bool isBibleHighlighted(Bible bible) {
    Bible itm = highlightedBibleVerses.firstWhere(
        (itm) => itm.id == bible.id && itm.version == bible.version,
        orElse: () => null);
    return itm != null;
  }

  unselectedHighlightedVerses() {
    highlightedBibleVerses = [];
  }

  colorizeSelectedVerses() async {
    List<Bible> _highlightedBibleVerses = highlightedBibleVerses;
    _highlightedBibleVerses.forEach((element) {
      element.color = selectedColor;
      element.date = DateTime.now().millisecondsSinceEpoch;
    });
    coloredHighlightedBibleVerses.addAll(_highlightedBibleVerses);
    await SQLiteDbProvider.db.insertBatchColoredBible(_highlightedBibleVerses);
    highlightedBibleVerses = [];
    notifyListeners();
    stopHighlight();
  }

  removeColoredVerse(Bible bible) async {
    coloredHighlightedBibleVerses.removeWhere(
        (item) => item.id == bible.id && item.version == bible.version);
    await SQLiteDbProvider.db.deleteColoredBibleVerse(bible);
    notifyListeners();
  }

  onVerseTapped(Bible bible) async {
    if (isBibleColoredHighlighted(bible)) {
      removeColoredVerse(bible);
      return;
    }
    if (isBibleHighlighted(bible)) {
      highlightedBibleVerses.removeWhere(
          (item) => item.id == bible.id && item.version == bible.version);
    } else {
      highlightedBibleVerses.add(bible);
      coloredHighlightedBibleVerses.removeWhere((item) => item.id == bible.id);
    }
    if (highlightedBibleVerses.length == 0) {
      stopHighlight();
    } else {
      startHighlight();
    }
  }

  copyHighlightedVerses(BuildContext context) {
    String formattedverses = prepareHighlightedVerses();
    FlutterClipboard.copy(formattedverses)
        .then((value) => Toast.show(t.copiedtoclipboard, context));
    stopHighlight();
  }

  shareHightlightedVerses() async {
    String formattedverses = prepareHighlightedVerses();
    await FlutterShare.share(
        title: selectedBook + " Chapter " + selectedChapter.toString() + ": \n",
        text: formattedverses);
    stopHighlight();
  }

  bookmarkHightlightedVerses(BuildContext context) {
    stopHighlight();
  }

  String prepareHighlightedVerses() {
    String formattedverses = "";
    formattedverses =
        selectedBook + " Chapter " + selectedChapter.toString() + ": \n";
    highlightedBibleVerses.forEach((element) {
      formattedverses +=
          "Verse " + element.verse.toString() + ": " + element.content + "\n ";
    });
    return formattedverses;
  }

  startHighlight() {
    isStartHighlight = true;
    notifyListeners();
  }

  stopHighlight() {
    highlightedBibleVerses = [];
    isStartHighlight = false;
    notifyListeners();
  }

  //tts
  bool isReadingBible = false;
  String currentReadBibleTitle = "";
  FlutterTts flutterTts;
  dynamic languages;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.7;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  Future speak(String text) async {
    _newVoiceText = text;
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) {
          ttsState = TtsState.playing;
          isReadingBible = true;
          notifyListeners();
        }
      }
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
      isReadingBible = false;
      notifyListeners();
    }
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) {
      ttsState = TtsState.paused;
      notifyListeners();
    }
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    notifyListeners();
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        // _getEngines();
      }
    }

    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
      isReadingBible = false;
      notifyListeners();
    });

    flutterTts.setCancelHandler(() {
      ttsState = TtsState.stopped;
      notifyListeners();
    });

    if (kIsWeb || Platform.isIOS) {
      flutterTts.setPauseHandler(() {
        ttsState = TtsState.paused;
        notifyListeners();
      });

      flutterTts.setContinueHandler(() {
        ttsState = TtsState.continued;
        notifyListeners();
      });
    }

    flutterTts.setErrorHandler((msg) {
      ttsState = TtsState.stopped;
      notifyListeners();
    });
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = [];
    for (dynamic type in languages) {
      items.add(
          DropdownMenuItem(value: type as String, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String selectedType) async {
    language = selectedType;
    flutterTts.setLanguage(language);
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_languagePreference, language);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  readBibleChapter(List<Bible> currentBibleList) {
    if (currentBibleList == null || currentBibleList.length == 0) return;
    currentReadBibleTitle = currentBibleList[0].book +
        " Chapter " +
        currentBibleList[0].chapter.toString();
    notifyListeners();
    String bibletoread = "";
    currentBibleList.forEach((element) {
      bibletoread +=
          "verse " + element.verse.toString() + ". " + element.content + ". ";
    });
    speak(bibletoread);
  }
}

enum TtsState { playing, stopped, paused, continued }
