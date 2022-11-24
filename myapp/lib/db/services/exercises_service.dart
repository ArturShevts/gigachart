import 'dart:convert';

import 'package:myapp/db/db_builder.dart';
import '../../model/exercises.dart';

class ExercisesService {
  static final ExercisesService instance = ExercisesService._init();

  ExercisesService._init();

  Future<Exercise> create(Exercise exercise) async {
    final db = await DatabaseBuilder.instance.database;
    final id = await db.insert(tableExercises, exercise.toJson());
    return exercise.copy(id: id);
  }

  Future<Exercise> readExercise(int id) async {
    final db = await DatabaseBuilder.instance.database;

    final maps = await db.query(
      tableExercises,
      columns: ExerciseFields.values,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Exercise.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Exercise>> readExercisesForListItemIds(List<int> ids) async {
    final db = await DatabaseBuilder.instance.database;
    final maps = await db.query(
      tableExercises,
      columns: ExerciseFields.values,
      where: '${ExerciseFields.id} IN (${ids.join(',')})',
    );

    if (maps.isNotEmpty) {
      return maps.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('ID $ids not found');
    }
  }

  Future<List<Exercise>> readAllExercises() async {
    final db = await DatabaseBuilder.instance.database;

    const orderBy = '${ExerciseFields.name} ASC';

    final result = await db.query(tableExercises, orderBy: orderBy);

    return result.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<int> update(Exercise exercise) async {
    final db = await DatabaseBuilder.instance.database;

    return db.update(
      tableExercises,
      exercise.toJson(),
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseBuilder.instance.database;

    return await db.delete(
      tableExercises,
      where: '${ExerciseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await DatabaseBuilder.instance.database;

    db.close();
  }
}