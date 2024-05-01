import 'dart:convert'; // Mengimpor pustaka dart:convert untuk mengonversi JSON.

void main() {
  // Mendefinisikan string JSON transkrip mahasiswa
  String transkripJson = '''
  {
    "nama": "Rio Alghaniy Putra",
    "npm": "1234567890", 
    "mata_kuliah": [ 
      {"kode": "MK101", "nama": "Pemrograman Mobile", "sks": 3, "nilai": "A"}, 
      {"kode": "MK201", "nama": "Pemrograman Web", "sks": 3, "nilai": "A"}, 
      {"kode": "MK301", "nama": "Interaksi Manusia Komputer", "sks": 3, "nilai": "A"}, 
      {"kode": "MK401", "nama": "Analisis Desain Sistem Informasi", "sks": 3, "nilai": "A-"}, 
      {"kode": "MK501", "nama": "E Bussiness", "sks": 3, "nilai": "A"}, 
      {"kode": "MK601", "nama": "Keamanan Sistem Informasi", "sks": 3, "nilai": "B+"} 
    ]
  }
  ''';

  Map<String, dynamic> transkrip = jsonDecode(transkripJson); // Mendekode JSON menjadi objek Map.

  // Cetak informasi mahasiswa
  print("Nama: ${transkrip['nama']}"); // Cetak nama mahasiswa.
  print("NPM: ${transkrip['npm']}"); // Cetak NPM mahasiswa.
  print("\n");
  print("Mata Kuliah:"); // Cetak label untuk mata kuliah.

  double totalSks = 0; // Inisialisasi total SKS menjadi 0.
  double totalNilai = 0; // Inisialisasi total nilai menjadi 0.

  // Iterasi untuk setiap mata kuliah dalam transkrip
  for (Map<String, dynamic> mk in transkrip['mata_kuliah']) { 
    print("\n");
    print("Kode: ${mk['kode']}"); // Cetak kode mata kuliah.
    print("Nama: ${mk['nama']}"); // Cetak nama mata kuliah.
    print("SKS: ${mk['sks']}"); // Cetak SKS mata kuliah.
    print("Nilai: ${mk['nilai']}"); // Cetak nilai mata kuliah.
    
    // Hitung total SKS dan nilai
    totalSks += mk['sks']; // Menambahkan SKS mata kuliah ke total SKS.
    totalNilai += nilaiKeAngka(mk['nilai']) * mk['sks']; // Menambahkan nilai mata kuliah ke total nilai, dikalikan dengan SKS.

  }

  // Hitung IPK
  double ipk = totalNilai / totalSks; // Menghitung IPK dengan membagi total nilai dengan total SKS.
  print("\n");
  print("-----------------");
  print("IPK: ${ipk.toStringAsFixed(2)}"); // Cetak IPK dengan dua angka di belakang koma.
  print("-----------------");
}

// Fungsi untuk mengubah nilai huruf menjadi angka
double nilaiKeAngka(String nilai) {
  switch (nilai) {
    case "A":
      return 4.0; // Jika nilai adalah A, kembalikan 4.0.
    case "A-":
      return 3.7; // Jika nilai adalah A-, kembalikan 3.7.
    case "B+":
      return 3.3; // Jika nilai adalah B+, kembalikan 3.3.
    case "B":
      return 3.0; // Jika nilai adalah B, kembalikan 3.0.
    case "B-":
      return 2.7; // Jika nilai adalah B-, kembalikan 2.7.
    default:
      return 0.0; // Nilai default jika tidak dikenali.
  }
}