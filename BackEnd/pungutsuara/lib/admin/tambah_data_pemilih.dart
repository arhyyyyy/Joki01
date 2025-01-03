import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseService {
  final String _firebaseUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/pemilih.json';

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
}

class TambahDataPemilih extends StatefulWidget {
  final Function(Map<String, String>) onAddPemilih;

  TambahDataPemilih({super.key, required this.onAddPemilih});

  @override
  _TambahDataPemilihState createState() => _TambahDataPemilihState();
}

class _TambahDataPemilihState extends State<TambahDataPemilih> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();

  DateTime? _selectedDate;

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
        ttlController.text = "${picked.toLocal()}".split(' ')[0]; // Format tanggal
      });
  }

  // Fungsi untuk menambahkan pemilih
  void _addPemilih() {
    if (nikController.text.isEmpty ||
        namaController.text.isEmpty ||
        noTeleponController.text.isEmpty ||
        alamatController.text.isEmpty ||
        ttlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi untuk NIK dan No Telepon (hanya angka)
    if (!RegExp(r'^[0-9]+$').hasMatch(nikController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NIK hanya boleh angka!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(noTeleponController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Telepon hanya boleh angka!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Menambahkan data pemilih
    final newPemilih = {
      'nik': nikController.text,
      'nama': namaController.text,
      'noTelepon': noTeleponController.text,
      'alamat': alamatController.text,
      'ttl': ttlController.text,
    };

    widget.onAddPemilih(newPemilih);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A6E),
        title: const Text(
          'Tambah Data Pemilih',
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
            CustomTextField(controller: nikController, hintText: 'NIK', inputType: TextInputType.number, inputFormatter: FilteringTextInputFormatter.digitsOnly),
            const SizedBox(height: 15),
            CustomTextField(controller: ttlController, hintText: 'DD/MM/YYYY', inputType: TextInputType.datetime, onTap: () => _selectDate(context)),
            const SizedBox(height: 15),
            CustomTextField(controller: namaController, hintText: 'Nama Lengkap'),
            const SizedBox(height: 15),
            CustomTextField(controller: noTeleponController, hintText: 'No. Tlp', inputType: TextInputType.number, inputFormatter: FilteringTextInputFormatter.digitsOnly),
            const SizedBox(height: 15),
            CustomTextField(controller: alamatController, hintText: 'Alamat'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addPemilih,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001A6E),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Tambah',
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
  final TextEditingController controller;
  final String hintText;
  final TextInputType inputType;
  final GestureTapCallback? onTap;
  final TextInputFormatter? inputFormatter;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.inputType = TextInputType.text,
    this.onTap,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatter != null ? [inputFormatter!] : null, // Apply inputFormatter if provided
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
      onTap: onTap,
    );
  }
}
