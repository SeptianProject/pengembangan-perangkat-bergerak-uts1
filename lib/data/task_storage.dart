import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

/// Titik akses data tugas.
///
/// Starter memakai memori agar aplikasi dapat langsung dijalankan. Lengkapi
/// TODO 2 dengan SharedPreferences dan JSON; jangan memindahkan akses storage
/// ke widget.
class TaskStorage {
  TaskStorage({this.loadDelay = const Duration(milliseconds: 450)});

  static List<Task> _memory = <Task>[];

  final Duration loadDelay;

  Future<List<Task>> load({bool simulateError = false}) async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw const FormatException('Simulasi data tersimpan yang rusak.');
    }

    // TODO 2a: baca String JSON dari SharedPreferences lalu ubah menjadi
    // List<Task> dengan Task.fromJson. JSON rusak dapat menghasilkan
    // FormatException agar UI menampilkan state error.
    final String? json = await SharedPreferences.getInstance().then(
      (prefs) => prefs.getString('tasks'),
    );
    if (json != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(json) as List<dynamic>;
        _memory =
            jsonList
                .map(
                  (jsonItem) => Task.fromJson(jsonItem as Map<String, dynamic>),
                )
                .toList();
      } catch (e) {
        throw const FormatException('Simulasi data tersimpan yang rusak.');
      }
    }
    return List<Task>.of(_memory);
  }

  Future<void> save(List<Task> tasks) async {
    // TODO 2b: encode seluruh daftar sebagai JSON String dan tulis melalui
    // SharedPreferences. Periksa nilai bool yang dikembalikan setString.
    final String json = jsonEncode(tasks.map((task) => task.toJson()).toList());
    final bool success = await SharedPreferences.getInstance().then(
      (prefs) => prefs.setString('tasks', json),
    );

    if (!success) {
      throw Exception('Gagal menyimpan daftar tugas ke SharedPreferences.');
    }
    _memory = List<Task>.of(tasks);
  }

  Future<void> clear() async {
    // TODO 2c: hapus key daftar tugas dari SharedPreferences.
    final bool success = await SharedPreferences.getInstance().then(
      (prefs) => prefs.remove('tasks'),
    );
    if (!success) {
      throw Exception('Gagal menghapus daftar tugas dari SharedPreferences.');
    }
    _memory = <Task>[];
  }

  /// Hanya untuk mengisolasi pengujian lokal.
  static void resetMemoryForTest() => _memory = <Task>[];
}
