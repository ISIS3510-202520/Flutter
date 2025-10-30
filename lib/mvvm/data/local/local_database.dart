import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// This part will be generated automatically
part 'local_database.g.dart';

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

@DriftDatabase(tables: [LocalSummaries])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
    await (delete(localSummaries)..where((t) => t.userId.equals(summary.userId))).go();

    await into(localSummaries).insertOnConflictUpdate(summary);
  }


  Future<void> deleteSummary(String id) async {
    await (delete(localSummaries)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'here4u_local.db'));
    return NativeDatabase.createInBackground(file);
  });
}


