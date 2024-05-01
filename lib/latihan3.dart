import 'package:flutter/material.dart'; // Mengimpor pustaka flutter material.
import 'package:http/http.dart'
    as http; // Mengimpor pustaka http dari package:http.
import 'dart:convert'; // Mengimpor pustaka dart:convert.

// Kelas untuk merepresentasikan data universitas.
class University {
  String name; // Nama universitas.
  String website; // Situs web universitas.

  // Constructor dengan parameter wajib.
  University({required this.name, required this.website});

  // Factory method untuk membuat objek University dari JSON.
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'].isNotEmpty
          ? json['web_pages'][0]
          : "", // Mengambil situs web pertama, jika ada.
    );
  }
}

// Kelas utama aplikasi Flutter.
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState(); // Mengembalikan state dari aplikasi.
  }
}

class MyAppState extends State<MyApp> {
  late Future<List<University>>
      futureUniversities; // Variabel untuk menampung future hasil pengambilan data.

  String url =
      "http://universities.hipolabs.com/search?country=Indonesia"; // URL endpoint API.

  // Method untuk mengambil data dari API.
  Future<List<University>> fetchData() async {
    final response =
        await http.get(Uri.parse(url)); // Melakukan HTTP GET request ke URL.

    if (response.statusCode == 200) {
      List<dynamic> data =
          jsonDecode(response.body); // Mendecode JSON response.
      List<University> universities =
          []; // Inisialisasi list untuk menyimpan data universitas.

      data.forEach((university) {
        universities.add(University.fromJson(
            university)); // Menambahkan data universitas ke dalam list.
      });

      return universities; // Mengembalikan list universitas.
    } else {
      throw Exception(
          'Gagal load'); // Lemparkan exception jika terjadi error dalam pengambilan data.
    }
  }

  @override
  void initState() {
    super.initState();
    futureUniversities =
        fetchData(); // Menginisialisasi future untuk pengambilan data.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universities di Indonesia', // Judul aplikasi.
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Universities di Indonesia'), // Judul AppBar.
          backgroundColor: Colors.red, // Mengubah warna AppBar menjadi merah.
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities, // Future yang akan dipantau.
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia, tampilkan ListView dengan data universitas.
                return ListView.builder(
                  itemCount:
                      snapshot.data!.length, // Jumlah item dalam ListView.
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(snapshot.data![index]
                              .name), // Menampilkan nama universitas.
                          subtitle: Text(snapshot.data![index]
                              .website), // Menampilkan situs web universitas.
                        ),
                        Divider(
                          // Menambahkan garis batas antara setiap elemen ListView.
                          height: 0,
                          thickness: 1,
                          color: Colors.grey[300],
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika terjadi error dalam pengambilan data, tampilkan pesan error.
                return Text('${snapshot.error}');
              }
              // Default: menampilkan loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp()); // Menjalankan aplikasi Flutter.
}
