import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../models/Downloads.dart';
import '../database/SQLiteDbProvider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';
import 'dart:isolate';
import 'package:flutter_downloader/flutter_downloader.dart';
import '../i18n/strings.g.dart';

class DownloadsModel with ChangeNotifier {
  List<Downloads> downloadsList = [];
  List<Downloads> _downloadsList = [];
  bool isLoading = true;
  bool permissionReady = false;
  String localPath;
  ReceivePort _port = ReceivePort();
  TargetPlatform platform;
  bool shouldRequestDownload = false;
  bool isLoaded = false;

  DownloadsModel() {
    getDownloads();
    _bindBackgroundIsolate();
  }

  searchDownloads(String query) {
    _downloadsList.addAll(downloadsList);
    downloadsList.clear();
    _downloadsList.forEach((p) {
      if (p.title.contains(query) || p.description.contains(query)) {
        downloadsList.add(p);
      }
    });
    notifyListeners();
  }

  cancelSearch() {
    downloadsList.addAll(_downloadsList);
    _downloadsList.clear();
    notifyListeners();
  }

  initDownloads(TargetPlatform platform, Downloads downloads) async {
    this.platform = platform;
    await setLocalPath();
    if (downloads != null && isMediaInDownloads(downloads.id) == null) {
      shouldRequestDownload = true;
      downloads.downloadUrl = downloads.streamUrl;
      String _extension = p.extension(downloads.downloadUrl);
      downloads.streamUrl = localPath + "/" + downloads.title + _extension;
      await saveDownloadMedia(downloads);
      downloadsList.insert(0, downloads);
    } else {
      shouldRequestDownload = false;
    }
    await getDownloads();
    FlutterDownloader.registerCallback(downloadCallback);
    isLoading = true;
    permissionReady = false;
    _prepare();
  }

  getDownloads() async {
    downloadsList = await SQLiteDbProvider.db.getAllDownloads();
    notifyListeners();
  }

  saveDownloadMedia(Downloads media) async {
    await SQLiteDbProvider.db.addNewDownloadItem(media);
  }

  removeDownloadedMedia(BuildContext context, int id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.deletemedia),
              content: new Text(t.deletemediahint),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    SQLiteDbProvider.db.deleteDownloadMedia(id);
                    getDownloads();
                    Downloads downloads = isMediaInDownloads(id);
                    if (downloads != null) {
                      delete(downloads);
                    }
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Downloads isMediaInDownloads(int id) {
    Downloads itm =
        downloadsList.firstWhere((itm) => itm.id == id, orElse: () => null);
    return itm;
  }

  void requestDownload(Downloads task) async {
    print("task.downloadUrl = " + task.downloadUrl);
    String _extension = p.extension(task.downloadUrl);
    print("_extension =" + _extension);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.downloadUrl,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: localPath,
        showNotification: true,
        requiresStorageNotLow: true,
        fileName: task.title + _extension,
        openFileFromNotification: false);

    final itm = downloadsList?.firstWhere((itm) => itm.taskId == task.taskId,
        orElse: () => null);
    if (itm != null) {
      downloadsList[downloadsList.indexOf(itm)].taskId = task.taskId;
    }
  }

  void pauseDownload(Downloads task) async {
    await FlutterDownloader.pause(taskId: task.taskId);
  }

  void resumeDownload(Downloads task) async {
    String newTaskId = await FlutterDownloader.resume(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void retryDownload(Downloads task) async {
    String newTaskId = await FlutterDownloader.retry(taskId: task.taskId);
    task.taskId = newTaskId;
  }

  void delete(Downloads task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    await _prepare();
    //notifyListeners();
  }

  Future<bool> checkPermission() async {
    /*if (platform == TargetPlatform.android) {
      return await Permission.storage.request().isGranted;
    }
    return false;*/
     if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  requestPermission() async {
    if (platform == TargetPlatform.android) {
      permissionReady = await Permission.storage.request().isGranted;
    }
    //return false;
    notifyListeners();
  }

  setLocalPath() async {
    localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    print("localPath = " + localPath.toString());
    List contents = savedDir.listSync();
    for (var fileOrDir in contents) {
      if (fileOrDir is File) {
        print(fileOrDir.absolute);
      } else if (fileOrDir is Directory) {
        print(fileOrDir.path);
      }
    }
  }

  Future<bool> _prepare() async {
    permissionReady = await checkPermission();
    isLoading = false;
    notifyListeners();
    await loadTasks();
    return true;
  }

  Future<bool> loadTasks() async {
    final tasks = await FlutterDownloader.loadTasks();
    tasks?.forEach((task) {
      for (Downloads info in downloadsList) {
        if (info.downloadUrl == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });
    notifyListeners();
    if (shouldRequestDownload && permissionReady) {
      requestDownload(downloadsList[0]);
    }
    return true;
  }

  Future<String> _findLocalPath() async {
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (downloadsList.length > 0) {
        print("current task downloadsList id = " + downloadsList[0].taskId);
        print("current task id = " + id);
        final task = downloadsList?.firstWhere((task) => task.taskId == id,
            orElse: () => null);
        if (task != null) {
          task.status = status;
          task.progress = progress;
          notifyListeners();
        }
      }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
