# TANGAN: Catatan Keuangan

TANGAN adalah aplikasi mobile untuk mencatat dan memantau keuangan pribadi. Aplikasi ini membantu pengguna mengelola pemasukan, pengeluaran, kategori transaksi, rekap periodik, laporan Excel, backup/restore data, serta tampilan nominal dalam berbagai mata uang.

Project ini dikembangkan menggunakan Flutter sebagai tugas akhir mata kuliah Pemrograman Mobile.

## Fitur Utama

- Pencatatan pemasukan dan pengeluaran.
- Manajemen kategori transaksi.
- Kalender transaksi harian.
- Rekap keuangan bulanan dan custom period.
- Detail rekap berdasarkan kategori, grafik, dan daftar transaksi.
- Export laporan rekap ke file Excel.
- Galeri bukti transaksi dari gambar yang tersimpan.
- Backup dan restore database lokal.
- Konversi mata uang manual.
- Pengaturan mata uang tampilan dengan kurs harian dan cache lokal.
- Tema warna, dark mode, dan pilihan bahasa Indonesia/English.

## Teknologi

- Flutter
- Dart
- Drift ORM
- SQLite
- Dio
- Shared Preferences
- Syncfusion XlsIO
- ExchangeRate-API Open Access untuk kurs mata uang

## Persyaratan

- Flutter SDK dengan Dart `>=3.0.5 <4.0.0`
- Android 8.0 atau lebih baru
- Android SDK dan Gradle sesuai konfigurasi project

## Instalasi

Clone repository, lalu jalankan:

```bash
flutter pub get
flutter run
```

Untuk membuat APK debug:

```bash
flutter build apk --debug
```

Untuk membuat APK release:

```bash
flutter build apk --release
```

## Konfigurasi Android

Project menggunakan konfigurasi Android berikut:

- Android Gradle Plugin: `8.3.0`
- Gradle wrapper: `8.4`
- Minimum SDK mengikuti konfigurasi Flutter project

Permission utama yang digunakan:

- Internet dan network state untuk kurs mata uang.
- Storage/file picker untuk backup, restore, export, dan file terkait.
- Camera/gallery untuk bukti transaksi.

## Data dan Penyimpanan

Data transaksi disimpan secara lokal menggunakan SQLite melalui Drift. Nilai transaksi utama disimpan dalam Rupiah Indonesia (IDR), kemudian dikonversi saat ditampilkan sesuai mata uang yang dipilih pengguna.

Backup database menghasilkan file SQLite yang dapat dipulihkan kembali melalui menu Pengaturan.

## Multi-Currency

Aplikasi menggunakan ExchangeRate-API Open Access tanpa API key:

```text
https://open.er-api.com/v6/latest/USD
```

Untuk tampilan nominal aplikasi, kurs disimpan dalam cache lokal agar aplikasi tetap dapat menampilkan data saat offline atau ketika update kurs gagal.

## Struktur Project

```text
lib/
  components/     Komponen UI reusable
  models/         Model data, Drift database, dan response API
  pages/          Halaman utama aplikasi
  utils/          Helper dan konfigurasi utilitas
  widgets/        Widget tampilan khusus
assets/img/       Asset gambar aplikasi
android/          Konfigurasi Android
```

## Tim Pengembang

- Jonathan Zefanya
- Daffa Nur Fakhri
- Rizky Aditya
- Daffa Danindra
- Arief Fahroza

## Link

- Portfolio: https://jojo.tirtagt.xyz
- ExchangeRate-API Open Access: https://www.exchangerate-api.com/docs/free

## Lisensi

Project ini dibuat untuk kebutuhan pembelajaran dan tugas akhir. Penggunaan ulang atau pengembangan lebih lanjut dapat disesuaikan dengan kebutuhan pemilik project.
