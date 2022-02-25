import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';


const table = "Clipboard";
const columnID = 'id';
const columnEntry = "entry";

class ClipboardEntry {
  final String id;
  final String entry;
  ClipboardEntry(this.id, this.entry);
  ClipboardEntry.fromJson(data)
      : id = data['_id'],
        entry = data['entry'];
  Map<String, dynamic> toJson() => {
    '_id': id,
    'entry': entry,
  };
}


class ClipboardDatabase {
  static const host = "cluster.ncnvu.mongodb.net/";
  static const database = "MongoDatabase";
  static const collection = "Clipboard";

  // static const url = "mongodb+srv://"+ username +":"+ password +"@cluster.ncnvu.mongodb.net/"+ database +"?retryWrites=true&w=majority";


  Future<void> insertIntoClipboard(String entry) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final username = await sharedPreferences.getString('username');
    final password = await sharedPreferences.getString('password');
    var url;
    if (username != null && password != null) {
      url = "mongodb+srv://"+ username +":"+ password +"@cluster.ncnvu.mongodb.net/"+ database +"?retryWrites=true&w=majority";
    }

    final db = await Db.create(url);
    await db.open();
    var date = DateTime.parse(DateTime.now().toString());
    var formatedDate = "${date.day}${date.month}${date.year}${date.hour}${date.month}${date.second}";
    var openCollection = db.collection(collection);
    await openCollection.insert({'_id':formatedDate, 'entry': entry});
    db.close();
  }


  Future<List<ClipboardEntry>> retriveFromClipboard() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final username = await sharedPreferences.getString('username');
    final password = await sharedPreferences.getString('password');
    var url;
    if (username != null && password != null) {
      url = "mongodb+srv://"+ username +":"+ password +"@cluster.ncnvu.mongodb.net/"+ database +"?retryWrites=true&w=majority";
    }

    final db = await Db.create(url);
    await db.open();
    List<ClipboardEntry> clipboardEntriesList = [];
    var openCollection = db.collection(collection);
    List responseList = await openCollection.find().toList();
    for (var element in responseList) {
      clipboardEntriesList.add(ClipboardEntry.fromJson(element));
    }
    db.close();
    return clipboardEntriesList;
    }

  Future<void> deleteFromClipboard(String id) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final username = await sharedPreferences.getString('username');
    final password = await sharedPreferences.getString('password');
    var url;
    if (username != null && password != null) {
      url = "mongodb+srv://"+ username +":"+ password +"@cluster.ncnvu.mongodb.net/"+ database +"?retryWrites=true&w=majority";
    }

    final db = await Db.create(url);
    await db.open();
    var openCollection = db.collection(collection);
    await openCollection.deleteOne({"_id": id});
    db.close();
  }
}
