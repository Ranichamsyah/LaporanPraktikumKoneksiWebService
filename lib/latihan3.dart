// Import library yang diperlukan untuk membuat aplikasi Flutter dan melakukan HTTP request
import 'package:flutter/material.dart'; // Paket yang menyediakan berbagai widget dan alat UI untuk membangun aplikasi Flutter
import 'package:http/http.dart' as http; // Paket untuk melakukan HTTP request
import 'dart:convert'; // Paket untuk mengonversi data dari dan ke format JSON

// Fungsi utama yang dipanggil saat aplikasi dimulai
void main() {
  // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root widget
  runApp(MyApp());
}


// Class untuk merepresentasikan data universitas
class University {
  final String name;
  final String website;

  University({required this.name, required this.website});

  // Factory method untuk membuat instance University dari JSON
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0], // Ambil website pertama dari list
    );
  }
}

// Kelas MyApp adalah widget utama dari aplikasi
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {  // Method build digunakan untuk merender tampilan aplikasi
    return MaterialApp(
      title: 'University List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UniversityList(),
    );
  }
}

// Kelas UniversityList adalah StatefulWidget yang akan menangani perubahan status dalam aplikasi
class UniversityList extends StatefulWidget {
  @override
  // Method createState() digunakan untuk membuat instance dari _UniversityListState
  _UniversityListState createState() => _UniversityListState();
}


// Kelas _UniversityListState adalah State dari widget UniversityList
class _UniversityListState extends State with WidgetsBindingObserver {
  late Future<List<dynamic>> _universityData; // Variabel untuk menampung hasil dari HTTP request


 // Override method initState() dari State untuk melakukan inisialisasi state
@override
void initState() {
  super.initState();
  _universityData = fetchUniversityData(); // Memanggil fungsi untuk mengambil data universitas
}


  // Method untuk mengambil data universitas dari API
  Future<List<dynamic>> fetchUniversityData() async {
    final response =
        await http.get(Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      // Jika HTTP request berhasil, decode JSON dan kembalikan datanya
      return json.decode(response.body);
    } else {
      // Jika gagal, lemparkan Exception
      throw Exception('Failed to load university data');
    }
  }

// Override method build() untuk merender tampilan widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University List'),
      ),
      // Widget body untuk menampilkan konten utama aplikasi
      body: FutureBuilder<List<dynamic>>(
        future: _universityData, // Gunakan hasil future dari HTTP request
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Jika snapshot memiliki data
            return ListView.builder(
              itemCount: snapshot.data!.length, // Tentukan jumlah item dalam ListView
              itemBuilder: (context, index) {
                // Bangun setiap item ListView
                return ListTile(
                  title: Text(snapshot.data![index]['name']), // Tampilkan nama universitas
                  subtitle: Text(snapshot.data![index]['web_pages'][0]), // Tampilkan situs universitas
                );
              },
            );
          } else if (snapshot.hasError) {
            // Jika terjadi error saat fetching data
            return Center(
              child: Text('Error: ${snapshot.error}'), // Tampilkan pesan error
            );
          }
          // Default: tampilkan loading spinner.
          return Center(
            child: CircularProgressIndicator(), // Tampilkan loading spinner saat data sedang dimuat
          );
        },
      ),
    );
  }
}