import 'package:alarme_notificacao/models/Alarme.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class AlarmeProvider {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE Alarmes(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT,
        hora INTEGER,
        minuto INTEGER,
        domingo INTEGER,
        segunda INTEGER,
        terca INTEGER,
        quarta INTEGER,
        quinta INTEGER,
        sexta INTEGER,
        sabado INTEGER
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'databasealarme_teste.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createAlarme(
      String nome,
      int hora,
      int minuto,
      int domingo,
      int segunda,
      int terca,
      int quarta,
      int quinta,
      int sexta,
      int sabado) async {
    final db = await AlarmeProvider.db();

    final data = {
      'nome': nome,
      'hora': hora,
      'minuto': minuto,
      'domingo': domingo,
      'segunda': segunda,
      'terca': terca,
      'quarta': quarta,
      'quinta': quinta,
      'sexta': sexta,
      'sabado': sabado
    };
    final id = await db.insert('Alarmes', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await AlarmeProvider.db();
    return db.query('Alarmes', orderBy: "id");
  }
}
