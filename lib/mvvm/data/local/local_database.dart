import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'local_database.g.dart';

// ===========================
// 📌 Tablas Drift
// ===========================

// Tabla de resúmenes locales existentes
@DataClassName('LocalSummary')
class LocalSummaries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get generatedAt => dateTime().nullable()();
  TextColumn get summaryText => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Nueva tabla: contactos de emergencia
@DataClassName('LocalEmergencyContact')
class LocalEmergencyContacts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get relation => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ===========================
// 📦 Base de datos principal
// ===========================
@DriftDatabase(tables: [LocalSummaries, LocalEmergencyContacts])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // ⬅️ se incrementa por nueva tabla

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Se llama la primera vez
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Se llama cuando hay cambio de schemaVersion
          if (from == 1) {
            await m.createTable(localEmergencyContacts);
          }
        },
        beforeOpen: (details) async {
          // Garantiza integridad o limpieza si hace falta
          await customStatement('PRAGMA foreign_keys = ON');
        },
    );

  // ==============================================
  // 🧠 Métodos para summaries (ya existentes)
  // ==============================================

  Future<void> upsertSummary(LocalSummary summary) async {
    await into(localSummaries).insertOnConflictUpdate(summary);
  }

  Future<List<LocalSummary>> getSummaries(String userId) async {
    return (select(localSummaries)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.generatedAt)]))
        .get();
  }

  Future<void> saveLatestSummary(LocalSummary summary) async {
    await (delete(localSummaries)
          ..where((t) => t.userId.equals(summary.userId)))
        .go();
    await into(localSummaries).insertOnConflictUpdate(summary);
  }

  Future<void> deleteSummary(String id) async {
    await (delete(localSummaries)..where((t) => t.id.equals(id))).go();
  }

  // ==============================================
  // 📞 Métodos para contactos de emergencia
  // ==============================================

  // Inserta o actualiza un contacto
  Future<void> upsertContact(LocalEmergencyContact contact) async {
    await into(localEmergencyContacts).insertOnConflictUpdate(contact);
  }

  // Obtiene todos los contactos de un usuario
  Future<List<LocalEmergencyContact>> getContacts(String userId) async {
    return (select(localEmergencyContacts)
          ..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  // Elimina un contacto específico
  Future<void> deleteContact(String id) async {
    await (delete(localEmergencyContacts)..where((t) => t.id.equals(id))).go();
  }

  // Borra todos los contactos de un usuario (por ejemplo, al re-sincronizar)
  Future<void> clearContactsForUser(String userId) async {
    await (delete(localEmergencyContacts)..where((t) => t.userId.equals(userId))).go();
  }
}

// ===========================
// 📂 Conexión Lazy
// ===========================
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'here4u_local.db'));
    return NativeDatabase.createInBackground(file);
  });
}
