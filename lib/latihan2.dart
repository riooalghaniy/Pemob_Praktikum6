import 'package:flutter/material.dart'; // Mengimpor pustaka flutter material.
import 'package:http/http.dart' as http; // Mengimpor pustaka http dari package:http.
import 'dart:convert'; // Mengimpor pustaka dart:convert.

void main() {
  runApp(const MyApp()); // Menjalankan aplikasi Flutter.
}

// Kelas untuk menampung data hasil pemanggilan API.
class Activity {
  String aktivitas; // Variabel untuk menampung aktivitas.
  String jenis; // Variabel untuk menampung jenis aktivitas.

  Activity({required this.aktivitas, required this.jenis}); // Constructor.

  // Method untuk mapping dari JSON ke atribut.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

// Kelas utama aplikasi Flutter.
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan state dari aplikasi.
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; // Variabel untuk menampung hasil aktivitas dari future.

  String url = "https://www.boredapi.com/api/activity"; // URL endpoint API.

  // Inisialisasi futureActivity.
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: ""); // Mengembalikan objek Activity kosong.
  }

  // Method untuk mengambil data dari API.
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url)); // Melakukan HTTP GET request ke URL.
    if (response.statusCode == 200) {
      // Jika server mengembalikan status code 200 OK (berhasil),
      // parse JSON dan mengembalikan objek Activity.
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal (bukan 200 OK), lempar exception.
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Menginisialisasi futureActivity.
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Mengambil data baru saat tombol ditekan.
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity, // Future yang akan dipantau.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika ada data yang berhasil diambil dari future.
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas), // Menampilkan aktivitas.
                      Text("Jenis: ${snapshot.data!.jenis}") // Menampilkan jenis aktivitas.
                    ]));
              } else if (snapshot.hasError) {
                // Jika terjadi error dalam pengambilan data.
                return Text('${snapshot.error}');
              }
              // Default: menampilkan loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}
