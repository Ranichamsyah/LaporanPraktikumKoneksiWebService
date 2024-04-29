// Import library dart:convert untuk mengonversi JSON menjadi objek Dart
import 'dart:convert';

void main() {
  // JSON transkrip mahasiswa
  String jsonTranskrip = '''
  {
    "nama": "Syuraini Noor Chamsyah",
    "nim": "122082010033",
    "program_studi": "Sistem Informasi",
    "mata_kuliah": [
      {
        "kode": "INF101",
        "nama": "Pemrograman Dasar",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "INF102",
        "nama": "Struktur Data",
        "sks": 4,
        "nilai": "A+"
      },
      {
        "kode": "INF201",
        "nama": "Algoritma dan Kompleksitas",
        "sks": 3,
        "nilai": "A"
      },
      {
        "kode": "INF202",
        "nama": "Pemrograman Lanjut",
        "sks": 4,
        "nilai": "A"
      }
    ]
  }
  ''';

  // Mengubah JSON menjadi objek Dart
  Map<String, dynamic> transkrip = jsonDecode(jsonTranskrip);

  // Menghitung total SKS dan nilai rata-rata
  int totalSKS = 0;
  double totalNilai = 0.0;
  for (var matkul in transkrip['mata_kuliah']) {
    totalSKS += int.parse(matkul['sks'].toString()); // Mengonversi sks ke tipe data integer
    totalNilai += _nilaiToBobot(matkul['nilai']) * int.parse(matkul['sks'].toString()); // Menghitung total nilai berdasarkan bobot dan sks
  }

  // Menghitung IPK
  double ipk = totalNilai / totalSKS;

  // Menampilkan informasi transkrip dan IPK
  print('Nama: ${transkrip['nama']}');
  print('NIM: ${transkrip['nim']}');
  print('Program Studi: ${transkrip['program_studi']}');
  print('IPK: ${ipk.toStringAsFixed(2)}');
}

// Fungsi untuk mengonversi nilai huruf menjadi bobot numerik
double _nilaiToBobot(String nilai) {
  switch (nilai) {
    case 'A':
      return 4.0;
    case 'A-':
      return 3.7;
    case 'B+':
      return 3.3;
    // Tambahkan penanganan nilai huruf lain jika diperlukan
    default:
      return 0.0;
  }
}
