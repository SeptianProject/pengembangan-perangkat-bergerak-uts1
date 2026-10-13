import 'dart:async';

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
    return List<Task>.of(_memory);
  }

  Future<void> save(List<Task> tasks) async {
    // TODO 2b: encode seluruh daftar sebagai JSON String dan tulis melalui
    // SharedPreferences. Periksa nilai bool yang dikembalikan setString.
    _memory = List<Task>.of(tasks);
  }

  Future<void> clear() async {
    // TODO 2c: hapus key daftar tugas dari SharedPreferences.
    _memory = <Task>[];
  }

  /// Hanya untuk mengisolasi pengujian lokal.
  static void resetMemoryForTest() => _memory = <Task>[];
}
