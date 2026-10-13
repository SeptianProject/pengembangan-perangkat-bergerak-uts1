# Laporan UTS Praktikum Pemrograman Perangkat Bergerak

**Tahun Akademik 2026/2027 - Politeknik Negeri Banyuwangi**

> **Catatan UTS**: UTS - Pemrograman Perangkat Bergerak  
> **Datetime**: 2026-10-13

---

## 1. Identitas Mahasiswa

- **Nama**: Septian Asropik
- **NIM**: 362558302064
- **Kelas**: D4 TRPL 2A
- **Mata Kuliah**: Praktikum Pemrograman Perangkat Bergerak
- **Dosen Pengampu**: Galih Hendra Wibowo, S.Tr.Kom., M.T.

---

## 2. Jawaban Pertanyaan Teori (Soal 1 - 5)

### Soal 1: UI & Layout Responsif

**Pertanyaan**: Bagaimana strategi penerapan layout responsif pada Flutter agar aplikasi tidak mengalami _overflow_ pada layar kecil (misal: 360 px) dan mampu menyesuaikan tampilan 2 kolom pada layar tablet (≥ 700 px)?

**Jawaban**:

> _[Gunakan bahasa sendiri untuk menjawab]_  
> Penerapan layout responsif di Flutter dapat dilakukan menggunakan `LayoutBuilder` atau `MediaQuery` untuk mengetahui lebar layar (_screen width_).
>
> - **Layar Telepon (360 px)**: Digunakan layout tunggal (`ListView.builder`) dengan padding/margin yang proporsional serta bungkus teks menggunakan `Expanded` atau `Flexible` untuk mencegah _horizontal overflow_.
> - **Layar Tablet (≥ 700 px)**: Menggunakan `GridView.builder` dengan `crossAxisCount: 2` atau `LayoutBuilder` yang secara dinamis mengubah struktur dari 1 kolom menjadi Grid 2 kolom berdasarkan batasan lebar (`constraints.maxWidth >= 700`).

---

### Soal 2: Form, Validasi, & Navigasi

**Pertanyaan**: Jelaskan mekanisme validasi input (termasuk pembersihan spasi/`trim`) serta alur pemanggilan halaman dan pengembalian data menggunakan `Navigator.push` dan `Navigator.pop`!

**Jawaban**:

> _[Gunakan bahasa sendiri untuk menjawab]_
>
> - **Validasi Form**: Menggunakan `FormState` dan `TextEditingController` atau `FormField.validator`. Fungsi `.trim()` dipanggil pada string input (`titleController.text.trim()`) untuk menghapus spasi berlebih di awal/akhir. Jika hasil `trim()` kosong (`isEmpty`), sistem akan mengembalikan pesan error validasi sehingga data tidak diproses.
> - **Navigasi**: Halaman form dibuka menggunakan `Navigator.push` yang mengembalikan objek `Future<Task?>`. Saat tombol **Simpan** ditekan dan validasi lolos, `Navigator.pop(context, newTask)` dipanggil untuk mengembalikan data `Task` baru ke halaman sebelumnya. Jika tombol **Batal** ditekan, `Navigator.pop(context, null)` dipanggil tanpa mengubah daftar.

---

### Soal 3: State Management & Interaksi Daftar

**Pertanyaan**: Jelaskan bagaimana penambahan tugas baru atau perubahan status tugas (selesai/belum) dapat langsung memperbarui tampilan kartu tugas dan ringkasan jumlah tugas secara _real-time_!

**Jawaban**:

> _[Gunakan bahasa sendiri untuk menjawab]_  
> Pembaruan tampilan secara _real-time_ memanfaatkan `StatefulWidget` dan pemanggilan `setState()`.
>
> - Saat tugas baru ditambahkan atau status tugas diubah (`task.isCompleted = !task.isCompleted`), perubahan dilakukan pada daftar `List<Task>`.
> - Pemanggilan `setState()` memicu Flutter untuk merender ulang (_rebuild_) widget `build()`.
> - Komponen ringkasan yang menghitung tugas selesai/total (`tasks.where((t) => t.isCompleted).length`) serta kartu tugas dalam `ListView`/`GridView` otomatis diperbarui sesuai dengan data state terbaru.

---

### Soal 4: Operasi Asynchronous & State UI

**Pertanyaan**: Mengapa operasi pembacaan data dilakukan secara _asynchronous_ (`Future`/`async-await`), dan bagaimana strategi pengelolaan 4 kondisi state UI (_loading_, _empty_, _data_, dan _error_)?

**Jawaban**:

> _[Gunakan bahasa sendiri untuk menjawab]_
>
> - **Operasi Asynchronous**: Pembacaan data dari penyimpanan lokal (`SharedPreferences`) memerlukan waktu I/O. Menggunakan `async-await` / `Future` mencegah pemblokiran _UI thread_ (mencegah aplikasi _freeze_).
> - **Pengelolaan 4 State UI**: Menggunakan variabel enum/state (misal: `isLoading`, `errorMessage`, dan pengecekan `tasks.isEmpty`).
>   1. **Loading**: Menampilkan `CircularProgressIndicator()`.
>   2. **Error**: Jika terjadi kegagalan/exception, `errorMessage` diisi dan UI menampilkan pesan error beserta tombol **Coba Lagi** yang memanggil ulang fungsi muat data.
>   3. **Empty**: Jika data berhasil dimuat tetapi `tasks.isEmpty`, tampilkan widget _Empty State_.
>   4. **Data**: Jika data tersedia, tampilkan daftar kartu tugas dan ringkasan.

---

### Soal 5: Persistensi Data Lokal & SharedPreferences

**Pertanyaan**: Jelaskan alur serialisasi data `Task` ke format JSON dan mekanisme penyimpanannya ke dalam `SharedPreferences` agar data bertahan saat aplikasi ditutup dan dibuka kembali!

**Jawaban**:

> _[Gunakan bahasa sendiri untuk menjawab]_
>
> - **Serialisasi JSON**: Model `Task` dilengkapi metode `toJson()` (mengubah objek ke `Map<String, dynamic>`) dan `Task.fromJson()` (mengonversi `Map` kembali ke objek `Task`). Daftar tugas `List<Task>` dienkode menjadi string JSON menggunakan `jsonEncode()`.
> - **Penyimpanan**: Menggunakan instance `SharedPreferences.getInstance()`, string JSON disimpan dengan kunci tertentu via `prefs.setString('tasks_key', jsonString)`.
> - **Pembacaan**: Saat aplikasi dibuka, string JSON dibaca via `prefs.getString('tasks_key')`. String didekode dengan `jsonDecode()` menjadi `List<dynamic>`, lalu dipetakan (_mapping_) kembali menjadi `List<Task>` dengan `Task.fromJson()`.

---

## 3. Petunjuk Cara Menjalankan Aplikasi

1. **Persiapan Environtment**: Pastikan Flutter SDK telah terinstal dan emulator/perangkat fisik Android aktif.
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Menjalankan Aplikasi**:
   ```bash
   flutter run
   ```
4. **Pemeriksaan Kode Statis**:
   ```bash
   flutter analyze
   ```
5. **Menjalankan Unit/Widget Test**:
   ```bash
   flutter test
   ```
6. **Jika ada error bisa menggunakan perintah berikut untuk mereset semua dependency**:
   ```bash
   flutter clean
   ```

---

## 4. Status Kriteria Penerimaan (_Acceptance Criteria_ A - H)

| Kriteria | Deskripsi Kriteria Penerimaan                                                                     |    Status Pengerjaan    | Catatan |
| :------: | :------------------------------------------------------------------------------------------------ | :---------------------: | :------ |
|  **A**   | Telepon (360 px): Tidak ada _overflow_ horizontal & kontrol terbaca.                              | [ ] Selesai / [ ] Belum |         |
|  **B**   | Tablet (≥ 700 px): Kartu tersusun 2 kolom dan tetap terbaca.                                      | [ ] Selesai / [ ] Belum |         |
|  **C**   | Form Validasi: Judul/Mata kuliah kosong/spasi ditolak dengan pesan validasi.                      | [ ] Selesai / [ ] Belum |         |
|  **D**   | Navigasi: Detail menerima `Task`; Simpan kembalikan data; Batal tidak ubah data.                  | [ ] Selesai / [ ] Belum |         |
|  **E**   | State: Penambahan & perubahan status langsung perbarui daftar dan ringkasan.                      | [ ] Selesai / [ ] Belum |         |
|  **F**   | Async & State UI: State _loading_, _empty_, _data_, & _error_ tampil; tombol Coba Lagi berfungsi. | [ ] Selesai / [ ] Belum |         |
|  **G**   | Persistensi: Data dan status tetap bertahan setelah aplikasi ditutup & dibuka kembali.            | [ ] Selesai / [ ] Belum |         |
|  **H**   | Verifikasi: Aplikasi berjalan lancar, hasil `flutter analyze` & langkah uji dicatat.              | [ ] Selesai / [ ] Belum |         |

---

## 5. Ringkasan Alur Kode Utama

> **Alur Pengisian Form hingga Persistensi Data**:
>
> 1. Pengguna menekan tombol Tambah Tugas di `TaskListScreen` -> memicu `Navigator.push` ke `TaskFormScreen`.
> 2. Di `TaskFormScreen`, pengguna mengisi Judul & Mata Kuliah. Saat tombol **Simpan** ditekan, input di-`trim()`. Jika valid, objek `Task` baru dibuat dan dikembalikan via `Navigator.pop(context, newTask)`.
> 3. `TaskListScreen` menerima `newTask`, memasukkannya ke dalam `List<Task>`, dan memanggil `TaskStorage.saveTasks(tasks)`.
> 4. `TaskStorage` mengubah `List<Task>` menjadi string JSON via `jsonEncode` dan menguncinya di `SharedPreferences`.
> 5. `setState()` dipanggil di `TaskListScreen` untuk memperbarui tampilan daftar dan ringkasan secara instan.

---

## 6. Catatan Error Tersisa / Belum Selesai

> _Catat jika masih terdapat bug, error, atau kriteria yang belum sempat diselesaikan hingga waktu ujian berakhir:_
>
> - **Status**: (Sebutkan jika semua fitur berfungsi lancar, atau tuliskan bagian yang belum selesai / kendala yang dihadapi).

---

## 7. Bukti Keluaran `flutter analyze`

```text
flutter analyze
Analyzing starter-uts...
No issues found! (ran in 3.4s)
```
