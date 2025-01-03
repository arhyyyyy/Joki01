import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseService {
  final String _firebaseUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/pemilih.json'; // URL untuk pemilih

  // Menambahkan data pemilih ke Firebase
  Future<void> addPemilih(Map<String, String> pemilih) async {
    try {
      final response = await http.post(
        Uri.parse(_firebaseUrl),
        body: json.encode(pemilih),
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
          if (value != null) {
            pemilihList.add({
              'id': key,
              'nik': value['nik'] ?? '',
              'nama': value['nama'] ?? '',
              'alamat': value['alamat'] ?? '',
              'noTelepon': value['noTelepon'] ?? '',
              'email': value['email'] ?? '',
            });
          }
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

  // Mengupdate data pemilih di Firebase
  Future<void> updatePemilih(String id, Map<String, String> updatedPemilih) async {
    final url = 'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/pemilih/$id.json';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(updatedPemilih),
      );

      if (response.statusCode == 200) {
        print("Data pemilih berhasil diperbarui");
      } else {
        print("Gagal memperbarui data pemilih");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class EditDataPemilih extends StatefulWidget {
  final int index;
  final Map<String, String> pemilihData;
  final Function(int, Map<String, String>) onUpdate;

  const EditDataPemilih({
    super.key,
    required this.index,
    required this.pemilihData,
    required this.onUpdate,
  });

  @override
  State<EditDataPemilih> createState() => _EditDataPemilihState();
}

class _EditDataPemilihState extends State<EditDataPemilih> {
  late TextEditingController _nikController;
  late TextEditingController _ttlController;
  late TextEditingController _namaController;
  late TextEditingController _noTeleponController;
  late TextEditingController _alamatController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    _nikController = TextEditingController(text: widget.pemilihData['nik'] ?? '');
    _ttlController = TextEditingController(text: widget.pemilihData['ttl'] ?? '');
    _namaController = TextEditingController(text: widget.pemilihData['nama'] ?? '');
    _noTeleponController = TextEditingController(text: widget.pemilihData['noTelepon'] ?? '');
    _alamatController = TextEditingController(text: widget.pemilihData['alamat'] ?? '');
  }

  @override
  void dispose() {
    _nikController.dispose();
    _ttlController.dispose();
    _namaController.dispose();
    _noTeleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _ttlController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
  }

  void _updateData() async {
    // Pengecekan null dan validasi input
    if (_nikController.text.isEmpty || _ttlController.text.isEmpty || _namaController.text.isEmpty || _noTeleponController.text.isEmpty || _alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, String> updatedPemilih = {
      'nik': _nikController.text,
      'ttl': _ttlController.text,
      'nama': _namaController.text,
      'noTelepon': _noTeleponController.text,
      'alamat': _alamatController.text,
    };

    // Cek data di Firebase berdasarkan NIK yang dimasukkan
    final response = await http.get(Uri.parse('https://pungutsuara-56dc7-default-rtdb.firebaseio.com/pemilih.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      String? pemilihId;

      data.forEach((key, value) {
        // Pastikan value tidak null sebelum memeriksa NIK
        if (value != null && value['nik'] == _nikController.text) {
          pemilihId = key;
        }
      });

      if (pemilihId != null) {
        // Update data pemilih di Firebase
        await FirebaseService().updatePemilih(pemilihId!, updatedPemilih);

        // Memperbarui data pemilih di halaman sebelumnya
        widget.onUpdate(widget.index, updatedPemilih);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );

        // Kembali ke halaman sebelumnya
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pemilih dengan NIK tersebut tidak ditemukan!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengambil data dari server!'),
          backgroundColor: Colors.red,
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
          'Edit Data Pemilih',
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
              controller: _nikController,
              hintText: 'NIK Pemilih',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _ttlController,
              hintText: 'Tanggal Lahir (DD/MM/YYYY)',
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _namaController,
              hintText: 'Nama Pemilih',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _noTeleponController,
              hintText: 'No Telepon Pemilih',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _alamatController,
              hintText: 'Alamat Pemilih',
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
  final GestureTapCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: onTap,
      readOnly: onTap != null,
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
