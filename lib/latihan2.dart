// Import library yang diperlukan untuk membuat aplikasi Flutter dan melakukan HTTP request
import 'package:flutter/material.dart'; // Paket yang menyediakan berbagai widget dan alat UI untuk membangun aplikasi Flutter
import 'package:http/http.dart' as http; // Paket untuk melakukan HTTP request
import 'dart:convert'; // Paket untuk mengonversi data dari dan ke format JSON

// Fungsi utama yang dipanggil saat aplikasi dimulai
void main() {
  // Menjalankan aplikasi Flutter dengan widget MyApp sebagai root widget
  runApp(const MyApp());
}

// menampung data hasil pemanggilan API
class Activity {
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); //constructor

  //map dari json ke atribut
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

// Kelas MyApp adalah StatefulWidget yang akan menangani perubahan status dalam aplikasi
class MyApp extends StatefulWidget {
  // Konstruktor MyApp dengan parameter key opsional
  const MyApp({Key? key}) : super(key: key);

  @override
  // Method createState() digunakan untuk membuat instance dari MyAppState
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}


class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; //menampung hasil

  //late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  Future<Activity> init() async { // Method init() digunakan untuk menginisialisasi Future
    return Activity(aktivitas: "", jenis: "");
  }

  //fetch data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

// Override method initState() dari State untuk melakukan inisialisasi state
  @override
  void initState() {
    super.initState();
    futureActivity = init();
  }

// Metode build() digunakan untuk merender tampilan widget aplikasi.
// Pada bagian ini, aplikasi menggunakan widget-widget dari Flutter untuk membangun antarmuka pengguna.
  @override
  Widget build(Object context) { // Override method build() untuk merender tampilan widget
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData();
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>( // FutureBuilder digunakan untuk menampilkan hasil dari Future, dalam hal ini, hasil dari permintaan HTTP.
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // default: loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}