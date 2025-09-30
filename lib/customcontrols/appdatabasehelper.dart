import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String databaseName = 'nass_food_wms_db.db';

  // Table 1: Users
  static const String itemTable = 'items';
  static const String itemId = 'id';
  static const String itemCode = 'code';
  static const String itemDescription = 'description';

  // Table 2: Settings
  static const String locatorTable = 'locators';
  static const String locatorId = 'id';
  static const String locator = 'description';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    // Create the users table
    await db.execute('''
      CREATE TABLE $itemTable (
        $itemId INTEGER PRIMARY KEY AUTOINCREMENT,
        $itemCode TEXT NOT NULL,
        $itemDescription TEXT UNIQUE
      )
    ''');
    //debugPrint('Table "$itemTable" created.');

    // Create the settings table
    await db.execute('''
      CREATE TABLE $locatorTable (
        $locatorId INTEGER PRIMARY KEY AUTOINCREMENT,        
        $locator TEXT
      )
    ''');
    //debugPrint('Table "$locatorTable" created.');
  }

  // --- Operations for Users Table ---

  Future<int> insertItem(Map<String, dynamic> item) async {
    Database db = await database;
    return await db.insert(itemTable, item);
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    Database db = await database;
    await db.delete(itemTable);
    return await db.query(itemTable);
  }

  Future<List<Map<String, dynamic>>> getAllItemsByPattern(
    String pattern,
  ) async {
    Database db = await database;
    List<Map<String, dynamic>> results = List.empty(growable: true);
    if (pattern.isEmpty) {
      results = await db.query(itemTable, limit: 6);
      return results;
    } else {
      results = await db.query(
        itemTable,
        where: '$itemDescription LIKE ?',
        whereArgs: ['%$pattern%'],
        limit: 8,
      );
    }
    return results;
  }

  // Method to get an item by its ID
  Future<Map<String, dynamic>?> getItemByCode(String code) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      itemTable,
      where: '$itemCode = ?',
      whereArgs: [code],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // --- Operations for Settings Table ---

  Future<int> insertSlocator(Map<String, dynamic> locator) async {
    Database db = await database;
    return await db.insert(locatorTable, locator);
  }

  Future<List<Map<String, dynamic>>> getAllSettings() async {
    Database db = await database;
    return await db.query(locatorTable);
  }

  // Optional: Get a specific setting by key
  Future<Map<String, dynamic>?> getSettingByKey(String key) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      locatorTable,
      where: '$locatorId = ?',
      whereArgs: [key],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      //debugPrint('Database closed.');
    }
  }
}

/*
void main() async {
  // Get an instance of the DatabaseHelper
  DatabaseHelper dbHelper = DatabaseHelper();

  // Initialize the database
  Database db = await dbHelper.database;
  print('Database initialized or already exists.');

  // --- Example Operations for Users Table ---
  print('\n--- Users Operations ---');

  // Insert users
  int userId1 = await dbHelper.insertUser({DatabaseHelper.userName: 'Alice', DatabaseHelper.userEmail: 'alice@example.com'});
  print('User inserted with ID: $userId1');
  int userId2 = await dbHelper.insertUser({DatabaseHelper.userName: 'Bob', DatabaseHelper.userEmail: 'bob@example.com'});
  print('User inserted with ID: $userId2');

  // Get all users
  List<Map<String, dynamic>> allUsers = await dbHelper.getAllUsers();
  print('All users:');
  allUsers.forEach((user) {
    print('ID: ${user[DatabaseHelper.userId]}, Name: ${user[DatabaseHelper.userName]}, Email: ${user[DatabaseHelper.userEmail]}');
  });

  // --- Example Operations for Settings Table ---
  print('\n--- Settings Operations ---');

  // Insert settings
  int settingId1 = await dbHelper.insertSetting({DatabaseHelper.settingKey: 'theme', DatabaseHelper.settingValue: 'dark'});
  print('Setting inserted with ID: $settingId1');
  int settingId2 = await dbHelper.insertSetting({DatabaseHelper.settingKey: 'notifications', DatabaseHelper.settingValue: 'enabled'});
  print('Setting inserted with ID: $settingId2');

  // Get all settings
  List<Map<String, dynamic>> allSettings = await dbHelper.getAllSettings();
  print('All settings:');
  allSettings.forEach((setting) {
    print('ID: ${setting[DatabaseHelper.settingId]}, Key: ${setting[DatabaseHelper.settingKey]}, Value: ${setting[DatabaseHelper.settingValue]}');
  });

  // Get a specific setting by key
  Map<String, dynamic>? themeSetting = await dbHelper.getSettingByKey('theme');
  print('\nTheme setting: $themeSetting');

  Map<String, dynamic>? languageSetting = await dbHelper.getSettingByKey('language');
  print('Language setting: $languageSetting'); // Will be null as it's not inserted

  // Close the database
  await dbHelper.close();
}*/
