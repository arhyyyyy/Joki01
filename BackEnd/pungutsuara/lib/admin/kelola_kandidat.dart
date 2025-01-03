// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'edit_data_kandidat.dart';
import 'tambah_data_kandidat.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// FirebaseService untuk komunikasi dengan Firebase
class FirebaseService {
  final String _firebaseUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat.json';

  // Menambahkan data kandidat ke Firebase
  Future<void> addKandidat(Map<String, String> kandidat) async {
    try {
      final response = await http.post(
        Uri.parse(_firebaseUrl),
        body: json.encode(kandidat),  // Mengonversi kandidat menjadi JSON
      );

      if (response.statusCode == 200) {
        print("Data kandidat berhasil ditambahkan");
      } else {
        print("Gagal menambahkan data kandidat");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Mengambil data kandidat dari Firebase
Future<List<Map<String, String>>> getKandidatData() async {
  try {
    final response = await http.get(Uri.parse(_firebaseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<Map<String, String>> kandidatList = [];

      data.forEach((key, value) {
        kandidatList.add({
          'id': key,  // Menyimpan ID kandidat
          'noUrut': value['noUrut'],
          'namaKetua': value['namaKetua'],
          'namaWakil': value['namaWakil'],
          'namaPartai': value['namaPartai'],
          'visiMisi': value['visiMisi'],
        });
      });

      return kandidatList;
    } else {
      print("Gagal mengambil data kandidat");
      return [];
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
  }
  
  deleteKandidat(String id) async {
    final url = 'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat/$id.json';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print("Data kandidat berhasil dihapus");
      } else {
        print("Gagal menghapus data kandidat");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

// Halaman Kelola Kandidat
class KelolaKandidatPage extends StatefulWidget {
  const KelolaKandidatPage({super.key});

  @override
  _KelolaKandidatPageState createState() => _KelolaKandidatPageState();
}

class _KelolaKandidatPageState extends State<KelolaKandidatPage> {
  // Daftar kandidat
  List<Map<String, String>> kandidatData = [];

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadKandidatData();
  }

  // Mengambil data kandidat dari Firebase
  void _loadKandidatData() async {
    final data = await _firebaseService.getKandidatData();
    setState(() {
      kandidatData = data;
    });
  }

  // Menambah data kandidat
  void _tambahKandidat(Map<String, String> kandidat) {
    setState(() {
      kandidatData.add(kandidat);
    });
    _firebaseService.addKandidat(kandidat);  // Menambahkan data ke Firebase
  }

  // Mengupdate data kandidat
  void _updateKandidat(int index, Map<String, String> updatedData) {
    setState(() {
      kandidatData[index] = updatedData;
    });
    // Anda bisa menambahkan logika untuk memperbarui data di Firebase di sini
  }

  // Menghapus kandidat
void _deleteKandidat(int index) async {
  final id = kandidatData[index]['id'];  // Mengambil ID kandidat
  if (id != null) {
    // Menghapus data dari Firebase
    await _firebaseService.deleteKandidat(id);

    setState(() {
      kandidatData.removeAt(index);  // Menghapus data dari UI
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kandidat berhasil dihapus'),
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
          'Kelola Kandidat',
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
              'KANDIDAT',
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
                    DataColumn(label: Text('No Urut')),
                    DataColumn(label: Text('Nama Ketua\nKandidat')),
                    DataColumn(label: Text('Nama Wakil\nKandidat')),
                    DataColumn(label: Text('Nama Partai')),
                    DataColumn(label: Text('Visi & Misi')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(kandidatData.length, (index) {
                    return DataRow(cells: [
                      DataCell(Text(kandidatData[index]['noUrut']!)),
                      DataCell(Text(kandidatData[index]['namaKetua']!)),
                      DataCell(Text(kandidatData[index]['namaWakil']!)),
                      DataCell(Text(kandidatData[index]['namaPartai']!)),
                      DataCell(Text(kandidatData[index]['visiMisi']!)),
                      DataCell(
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDataKandidat(
                                      index: index,
                                      kandidatData: kandidatData[index],
                                      onUpdate: (updatedIndex, updatedData) {
                                        _updateKandidat(updatedIndex, updatedData);
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
              text: 'Tambah',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahDataKandidat(onAddKandidat: _tambahKandidat),
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
          content: const Text('Apakah Anda yakin ingin menghapus kandidat ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                _deleteKandidat(index);
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

// Widget ActionButton
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
