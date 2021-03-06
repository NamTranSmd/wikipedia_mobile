import 'package:wikipedia_app/data/model/local_model/wikipedia.dart';

import '../tables/wiki_table.dart';
import 'package:sqflite/sqflite.dart';
import '../dbconfig.dart';

class WikiDAO {
  Database _db;

  WikiDAO() {
    _getDbInstance();
  }

  void _getDbInstance() async => _db = await DbConfig.getInstance();

  Future<Wikipedia> insert(Wikipedia wiki) async {
    List<Map> maps = await _db.query(WikiTable.tableName,
        columns: [WikiTable.columnId],
        where: "${WikiTable.columnId} = ?",
        whereArgs: [wiki.id]);
    if (maps.length > 0) {
      await _db.update(WikiTable.tableName, wiki.toJson(),
          where: '${WikiTable.columnId} = ?', whereArgs: [wiki.id]);
    } else {
      wiki.id = await _db.insert(WikiTable.tableName, wiki.toJson());
    }
    return wiki;
  }

  Future<List<Wikipedia>> getWikies(int limit) async {
    List<Map> maps = await _db.query(WikiTable.tableName,
        orderBy: "${WikiTable.columnId} DESC",
        columns: [
          WikiTable.columnId,
          WikiTable.columnTitle,
          WikiTable.columnKey,
          WikiTable.columnDescription,
          WikiTable.columnExcerpt,
          WikiTable.columnThumbnail
        ],limit: limit);

    List<Wikipedia> wikies = [];
    for (Map<String, dynamic> result in maps) {
      wikies.add(getWikiFromRaw(result));
    }
    return wikies;
  }

  Future<List<Wikipedia>> searchWikies(String searchText) async {
    List<Map> maps = await _db.query(WikiTable.tableName,
        columns: [
          WikiTable.columnId,
          WikiTable.columnTitle,
          WikiTable.columnKey,
          WikiTable.columnDescription,
          WikiTable.columnExcerpt,
          WikiTable.columnThumbnail
        ],
        where:
            "${WikiTable.columnTitle} LIKE '%$searchText%' OR ${WikiTable.columnExcerpt} LIKE '%$searchText%'");

    List<Wikipedia> wikies = [];
    if (maps.length > 0) {
      for (Map<String, dynamic> result in maps) {
        wikies.add(getWikiFromRaw(result));
      }
    }
    return wikies;
  }

  Future<int> delete(int id) async => await _db.delete(WikiTable.tableName,
      where: '${WikiTable.columnId} = ?', whereArgs: [id]);

  Future<int> update(WikiTable wiki) async =>
      await _db.update(WikiTable.tableName, wiki.toJson(),
          where: '${WikiTable.columnId} = ?', whereArgs: [wiki.id]);

  Future close() async => _db.close();

  Future deleteTable() async => await _db.delete(WikiTable.tableName);

  Wikipedia getWikiFromRaw(Map<String, dynamic> result) {
    return Wikipedia(
        id: result[WikiTable.columnId],
        key: result[WikiTable.columnKey],
        title: result[WikiTable.columnTitle],
        excerpt: result[WikiTable.columnExcerpt],
        thumbnail: result[WikiTable.columnThumbnail],
        description: result[WikiTable.columnDescription]);
  }
}
