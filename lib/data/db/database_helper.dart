import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'product.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE Product(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          price REAL,
          quantity INTEGER,
          discount REAL,
          subtotal REAL,
          total REAL
        )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return db.query('Product');
  }

  Future<int> insertProduct(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('Product', data);
  }

  Future<int> updateProduct(Map<String, dynamic> data) async {
    final db = await database;
    return db.update(
      'Product',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return db.delete('Product', where: 'id = ?', whereArgs: [id]);
  }
}