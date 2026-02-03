import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DB {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'row_edge.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tickets(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          ticketNumber INTEGER,
          date TEXT,
          phoneType TEXT,
          price INTEGER,
          customerName TEXT,
          phoneModel TEXT,
          status TEXT
        )
        ''');
      },
    );
  }

  static Future<int> nextTicketNumber() async {
    final db = await instance;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final res = await db.rawQuery(
      'SELECT MAX(ticketNumber) as max FROM tickets WHERE date = ?',
      [today],
    );

    final max = res.first['max'] as int?;
    return (max ?? 0) + 1;
  }

  static Future<void> insertTicket({
    required int ticketNumber,
    required String phoneType,
    required int price,
    String? customerName,
    String? phoneModel,
  }) async {
    final db = await instance;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await db.insert('tickets', {
      'ticketNumber': ticketNumber,
      'date': today,
      'phoneType': phoneType,
      'price': price,
      'customerName': customerName,
      'phoneModel': phoneModel,
      'status': 'charging',
    });
  }

  static Future<List<Map<String, dynamic>>> activeTickets() async {
    final db = await instance;
    return db.query(
      'tickets',
      where: 'status = ?',
      whereArgs: ['charging'],
      orderBy: 'ticketNumber DESC',
    );
  }

  static Future<void> completeTicket(int id) async {
    final db = await instance;
    await db.update(
      'tickets',
      {'status': 'completed'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
