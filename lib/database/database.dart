import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  static const dbname = 'Localdb.db';

  static const dbversion = 1;
  static const tablename = 'teachers';
  static const idcolumn = 'id';
  static const namecolumn = 'name';
  static const emailcolumn = 'email';
  static const passwordcolumn = 'password';
  static final DBhelper instanse = DBhelper();
  static Database? _database;
  Future<Database?> get database async {
    _database ??= await initdb();

    return _database;
  }

  initdb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    return await openDatabase(path, version: dbversion, onCreate: oncreate);
  }

  Future oncreate(Database db, int version) async {
    db.execute(
      '''create table $tablename($idcolumn integer primary key autoincrement,$namecolumn text not null ,$emailcolumn unique not null,$passwordcolumn text not null)''',
    );
    await db.execute(
      '''create table students(id integer primary key autoincrement,
    name text not null,
    studentid text unique not null , phone text not null ) ''',
    );
    await db.execute(
      ''' create table attendance(id integer primary key autoincrement,studentid text not null,date text not null ,status text not null,unique(studentid, date))''',
    );
  }
}
