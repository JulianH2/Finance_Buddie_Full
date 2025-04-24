import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "finanzas_local.db";
  static final _databaseVersion = 1;

  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Opcional: para futuras actualizaciones
    );
  }

  // Crear las tablas (versión inicial)
  static Future<void> _onCreate(Database db, int version) async {
    // Tabla MetasAhorro (sin idUsuario)
    await db.execute('''
      CREATE TABLE MetasAhorro (
        idMeta INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreMeta TEXT NOT NULL,
        descripcion TEXT,
        montoObjetivo REAL NOT NULL,
        montoActual REAL DEFAULT 0.00,
        fechaInicio TEXT DEFAULT CURRENT_TIMESTAMP,
        fechaFin TEXT NOT NULL,
        estaCompletada INTEGER DEFAULT 0,
        fechaCreacion TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabla Transacciones (sin idUsuario)
    await db.execute('''
      CREATE TABLE Transacciones (
        idTransaccion INTEGER PRIMARY KEY AUTOINCREMENT,
        monto REAL NOT NULL,
        tipo TEXT CHECK (tipo IN ('Ingreso', 'Gasto')),
        fechaOperacion TEXT NOT NULL,
        categoria TEXT,
        descripcion TEXT,
        fechaCreacion TEXT DEFAULT CURRENT_TIMESTAMP,
        idMeta INTEGER,
        FOREIGN KEY (idMeta) REFERENCES MetasAhorro(idMeta)
      )
    ''');

    // Tabla AportacionesMeta
    await db.execute('''
      CREATE TABLE AportacionesMeta (
        idAportacion INTEGER PRIMARY KEY AUTOINCREMENT,
        idMeta INTEGER,
        monto REAL NOT NULL,
        fechaAportacion TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (idMeta) REFERENCES MetasAhorro(idMeta)
      )
    ''');

    // Tabla HistorialSaldo (sin idUsuario)
    await db.execute('''
      CREATE TABLE HistorialSaldo (
        idHistorial INTEGER PRIMARY KEY AUTOINCREMENT,
        saldo REAL NOT NULL,
        fechaRegistro TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Opcional: Migración si cambias la estructura en futuras versiones
  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      // Ejemplo: Agregar una nueva columna en una actualización futura
      // await db.execute("ALTER TABLE Transacciones ADD COLUMN nuevaColumna TEXT");
    }
  }

  // Métodos para cerrar la base de datos (opcional)
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
