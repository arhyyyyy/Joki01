import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseService {
  final String _firebaseUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat.json';

  // Menambahkan data kandidat ke Firebase
  Future<void> addKandidat(Map<String, String> kandidat) async {
    try {
      final response = await http.post(
        Uri.parse(_firebaseUrl),
        body: json.encode(kandidat),
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
          if (value != null) {
            kandidatList.add({
              'id': key,
              'noUrut': value['noUrut'] ?? '',
              'namaKetua': value['namaKetua'] ?? '',
              'namaWakil': value['namaWakil'] ?? '',
              'namaPartai': value['namaPartai'] ?? '',
              'visiMisi': value['visiMisi'] ?? '',
            });
          }
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

  // Mengupdate data kandidat di Firebase
  Future<void> updateKandidat(String id, Map<String, String> updatedKandidat) async {
    final url = 'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat/$id.json';

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(updatedKandidat),
      );

      if (response.statusCode == 200) {
        print("Data kandidat berhasil diperbarui");
      } else {
        print("Gagal memperbarui data kandidat");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class EditDataKandidat extends StatefulWidget {
  final int index;
  final Map<String, String> kandidatData;
  final Function(int, Map<String, String>) onUpdate;

  const EditDataKandidat({
    super.key,
    required this.index,
    required this.kandidatData,
    required this.onUpdate,
  });

  @override
  State<EditDataKandidat> createState() => _EditDataKandidatState();
}

class _EditDataKandidatState extends State<EditDataKandidat> {
  late TextEditingController _noUrutController;
  late TextEditingController _namaKetuaController;
  late TextEditingController _namaWakilController;
  late TextEditingController _namaPartaiController;
  late TextEditingController _visiMisiController;

  @override
  void initState() {
    super.initState();

    _noUrutController = TextEditingController(text: widget.kandidatData['noUrut'] ?? '');
    _namaKetuaController = TextEditingController(text: widget.kandidatData['namaKetua'] ?? '');
    _namaWakilController = TextEditingController(text: widget.kandidatData['namaWakil'] ?? '');
    _namaPartaiController = TextEditingController(text: widget.kandidatData['namaPartai'] ?? '');
    _visiMisiController = TextEditingController(text: widget.kandidatData['visiMisi'] ?? '');
  }

  @override
  void dispose() {
    _noUrutController.dispose();
    _namaKetuaController.dispose();
    _namaWakilController.dispose();
    _namaPartaiController.dispose();
    _visiMisiController.dispose();
    super.dispose();
  }

  void _updateData() async {
    String noUrut = _noUrutController.text;

    if (noUrut.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Urut tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, String> updatedKandidat = {
      'noUrut': _noUrutController.text,
      'namaKetua': _namaKetuaController.text,
      'namaWakil': _namaWakilController.text,
      'namaPartai': _namaPartaiController.text,
      'visiMisi': _visiMisiController.text,
    };

    final response = await http.get(Uri.parse('https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String? candidateId;

      data.forEach((key, value) {
        if (value['noUrut'] == noUrut) {
          candidateId = key;
        }
      });

      if (candidateId != null) {
        await FirebaseService().updateKandidat(candidateId!, updatedKandidat);
        widget.onUpdate(widget.index, updatedKandidat);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kandidat dengan No Urut tersebut tidak ditemukan!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("Gagal mengambil data kandidat");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A6E),
        title: const Text(
          'Edit Data Kandidat',
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              controller: _noUrutController,
              hintText: 'No Urut',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _namaKetuaController,
              hintText: 'Nama Ketua Kandidat',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _namaWakilController,
              hintText: 'Nama Wakil Kandidat',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _namaPartaiController,
              hintText: 'Nama Partai',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _visiMisiController,
              hintText: 'Visi & Misi',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001A6E),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Perbarui',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF001A6E)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}