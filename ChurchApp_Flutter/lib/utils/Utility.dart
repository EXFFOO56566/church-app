import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/Media.dart';
import '../models/LiveStreams.dart';
//import 'package:music_player/music_player.dart';

class Utility {
  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String getBase64EncodedString(String text) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(text.trim());
  }

  static String getBase64DecodedString(String text) {
    //print(text);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.decode(text.trim());
  }

  static String getFileExtension(String link) {
    String ext = "mp4";
    if (link.contains(".")) {
      ext = link.substring(link.lastIndexOf("."));
    }
    return ext.replaceAll(".", "");
  }

  static List<Media> extractMediaByType(List<Media> mediaList, String type) {
    List<Media> newList = [];
    for (Media item in mediaList) {
      if (item.mediaType == type) {
        newList.add(item);
      }
    }
    return newList;
  }

  static List<Media> removeCurrentMediaFromList(
      List<Media> mediaList, Media media) {
    List<Media> playlist = [];
    for (Media item in mediaList) {
      if (item.id != media.id) {
        playlist.add(item);
      }
    }
    return playlist;
  }

  static List<LiveStreams> removeCurrentLiveStreamsFromList(
      List<LiveStreams> mediaList, LiveStreams media) {
    List<LiveStreams> playlist = [];
    for (LiveStreams item in mediaList) {
      if (item.id != media.id) {
        playlist.add(item);
      }
    }
    return playlist;
  }

  static bool isPreviewDuration(
      Media media, int currentDuration, bool isUserSubscribed) {
    if (isUserSubscribed) return false;
    if (media.isFree) return false;
    if (currentDuration >= media.previewDuration) {
      return true;
    }
    return false;
  }

  static bool isMediaRequireUserSubscription(
      Media media, bool isUserSubscribed) {
    if (isUserSubscribed) return false;
    if (!media.isFree && media.previewDuration == 0) {
      return true;
    }
    return false;
  }
}
