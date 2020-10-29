import 'package:localstorage/localstorage.dart';

class TrackToSave {
  int id;
  String name;
  TrackToSave({this.id, this.name});
  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['id'] = id;
    m['name'] = name;
    return m;
  }
}

class TrackBookMarkList {
  Map<int, String> items;
  TrackBookMarkList() {
    items = new Map();
  }

  getListItem(id) {
    return items[id];
  }

  hasItemInList(id) {
    return items.containsKey(id);
  }

  saveItemInList(int key, String value) {
    Map<int, String> newMapItem = new Map();
    newMapItem[key] = value;
    items.addAll(newMapItem);
  }

  removeDataItem(id) {
    items.remove(id);
  }

  toJSONEncodable() {
    return items.toString();
  }
}

class SharingData {
  static TrackBookMarkList storageList = new TrackBookMarkList();
  static LocalStorage storage = new LocalStorage('TRACK_BOOKMARK_DETAILS');

  static isTrackBookMark(int id) {
    return SharingData.storageList.hasItemInList(id);
  }

  static setTrackAsBookMark(int id, String name) {
    SharingData.storageList.saveItemInList(id, name);
    SharingData.saveToStorage();
  }

  static removeTrackFromBookmark(int id) {
    SharingData.storageList.removeDataItem(id);
    SharingData.saveToStorage();
  }

  static saveToStorage() {
    SharingData.storage
        .setItem('bookmarks', SharingData.storageList.toJSONEncodable());
  }

  static getListOfItems() {
    List<String> items = [];
    SharingData.storageList.items.forEach((key, value) {
      items.add(SharingData.storageList.getListItem(key));
    });
    return items;
  }
}
