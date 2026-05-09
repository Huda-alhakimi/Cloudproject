import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//_instanceلاستخدام نسخه واحده عند طلب القاعدة
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // قمنا بتغيير اسم قاعدة البيانات هنا لتجنب أي تضارب قديم
    String path = join(await getDatabasesPath(), 'todo_new_database.db'); 
    return await openDatabase(//فتحوانشا القاعدة
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }
  //تفعيل العلاقات

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');//عشان الحذف بالتبعيه وتفعيل العلاقات
  }

  Future _onCreate(Database db, int version) async {//انشا الجدول ينفذ لاول مره عند الانشا
    // 1. جدول المستخدمين
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // 2. جدول التصنيفات المترابط مع المستخدمين
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');//ON DELETE CASCADEلو انحذف المستخدم تنخذف التصنفات تلقائي

    // 3. جدول المهام المترابط مع المستخدمين والتصنيفات
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        userId INTEGER NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
  }
}
