import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pungutsuara/admin/edit_data_pemilih.dart';
import 'package:pungutsuara/admin/tambah_data_pemilih.dart';

// FirebaseService untuk komunikasi dengan Firebase
class FirebaseService {
  final String _firebaseUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/pemilih.json';  // Ubah ke pemilih

  // Menambahkan data pemilih ke Firebase
  Future<void> addPemilih(Map<String, String> pemilih) async {
    try {
      final response = await http.post(
        Uri.parse(_firebaseUrl),
        body: json.encode(pemilih),  // Mengonversi pemilih menjadi JSON
      );

      if (response.statusCode == 200) {
        print("Data pemilih berhasil ditambahkan");
      } else {
        print("Gagal menambahkan data pemilih");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Mengambil data pemilih dari Firebase
  Future<List<Map<String, String>>> getPemilihData() async {
    try {
      final response = await http.get(Uri.parse(_firebaseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, String>> pemilihList = [];

        data.forEach((key, value) {
          pemilihList.add({
            'id': key,  // Menyimpan ID pemilih
            'nik': value['nik'],
            'nama': value['nama'],
            'ttl': value['ttl'],
            'noTelepon': value['noTelepon'],
            'alamat': value['alamat'],
          });
        });

        return pemilihList;
      } else {
        print("Gagal mengambil data pemilih");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // Menghapus pemilih
  Future<void> deletePemilih(String id) async {
    final url = 'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/pemilih/$id.json';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print("Data pemilih berhasil dihapus");
      } else {
        print("Gagal menghapus data pemilih");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

// Halaman Kelola Pemilih
class KelolaPemilihPage extends StatefulWidget {
  const KelolaPemilihPage({super.key});

  @override
  _KelolaPemilihPageState createState() => _KelolaPemilihPageState();
}

class _KelolaPemilihPageState extends State<KelolaPemilihPage> {
  // Daftar pemilih
  List<Map<String, String>> pemilihData = [];

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadPemilihData();
  }

  // Mengambil data pemilih dari Firebase
  void _loadPemilihData() async {
    final data = await _firebaseService.getPemilihData();
    setState(() {
      pemilihData = data;
    });
  }

  // Menambah data pemilih
  void _tambahPemilih(Map<String, String> pemilih) {
    setState(() {
      pemilihData.add(pemilih);
    });
    _firebaseService.addPemilih(pemilih);  // Menambahkan data ke Firebase
  }

  // Mengupdate data pemilih
  void _updatePemilih(int index, Map<String, String> updatedData) {
    setState(() {
      pemilihData[index] = updatedData;
    });
    // Anda bisa menambahkan logika untuk memperbarui data di Firebase di sini
  }

  // Menghapus pemilih
  void _deletePemilih(int index) async {
    final id = pemilihData[index]['id'];  // Mengambil ID pemilih
    if (id != null) {
      // Menghapus data dari Firebase
      await _firebaseService.deletePemilih(id);

      setState(() {
        pemilihData.removeAt(index);  // Menghapus data dari UI
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pemilih berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A6E),
        title: const Text(
          'Kelola Pemilih',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'DATA',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001A6E),
              ),
            ),
            Text(
              'PEMILIH',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001A6E),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => const Color(0xFF001A6E),
                  ),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: const [
                    DataColumn(label: Text('NIK')),
                    DataColumn(label: Text('Nama Lengkap')),
                    DataColumn(label: Text('TTL')),
                    DataColumn(label: Text('No. Tlp')),
                    DataColumn(label: Text('Alamat')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(pemilihData.length, (index) {
                    return DataRow(cells: [
                      DataCell(Text(pemilihData[index]['nik']!)),
                      DataCell(Text(pemilihData[index]['nama']!)),
                      DataCell(Text(pemilihData[index]['ttl']!)),
                      DataCell(Text(pemilihData[index]['noTelepon']!)),
                      DataCell(Text(pemilihData[index]['alamat']!)),
                      DataCell(
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDataPemilih(
                                      index: index,
                                      pemilihData: pemilihData[index],
                                      onUpdate: (updatedIndex, updatedData) {
                                        _updatePemilih(updatedIndex, updatedData);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDeleteConfirmationDialog(context, index);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'Hapus',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ActionButton(
              text: 'Tambah Pemilih',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahDataPemilih(onAddPemilih: _tambahPemilih),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus pemilih ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deletePemilih(index);
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}


class ActionButton extends StatelessWidget {
  final String text; // Teks tombol
  final VoidCallback onTap; // Fungsi yang dijalankan saat tombol ditekan

  const ActionButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap, // Menjalankan fungsi onTap ketika tombol ditekan
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF001A6E), // Warna latar belakang tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Membuat sudut tombol membulat
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(
        text, // Menampilkan teks tombol
        style: const TextStyle(
          color: Colors.white, // Warna teks tombol
          fontSize: 18, // Ukuran teks
          fontWeight: FontWeight.bold, // Ketebalan teks
        ),
      ),
    );
  }
}
