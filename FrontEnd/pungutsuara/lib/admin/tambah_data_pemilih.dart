import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk input formatter

class TambahDataPemilih extends StatefulWidget {
  const TambahDataPemilih({super.key});

  @override
  State<TambahDataPemilih> createState() => _TambahDataPemilihState();
}

class _TambahDataPemilihState extends State<TambahDataPemilih> {
  final TextEditingController nikController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController noTlpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nikController.dispose();
    ttlController.dispose();
    namaController.dispose();
    noTlpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        ttlController.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
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
            CustomTextField(
              controller: nikController,
              hintText: 'NIK',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: ttlController,
              hintText: 'DD-MM-YYYY',
              isDate: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: namaController,
              hintText: 'Nama Lengkap',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: noTlpController,
              hintText: 'No. Telepon',
              isNumber: true, // Indikasi bahwa ini untuk angka
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: alamatController,
              hintText: 'Alamat Lengkap',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (nikController.text.isNotEmpty &&
                    ttlController.text.isNotEmpty &&
                    namaController.text.isNotEmpty &&
                    noTlpController.text.isNotEmpty &&
                    alamatController.text.isNotEmpty) {
                  // Send data back to the previous screen
                  Navigator.pop(context, {
                    'nik': nikController.text,
                    'ttl': ttlController.text,
                    'nama': namaController.text,
                    'noTlp': noTlpController.text,
                    'alamat': alamatController.text,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Data berhasil ditambahkan!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Harap lengkapi semua data!'),
                    ),
                  );
                }
              },
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
  final bool isDate;
  final bool isNumber; // Tambahkan flag untuk validasi angka
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isDate = false,
    this.isNumber = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: isDate, // Make TextField readonly if it is a date field
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : null, // Hanya izinkan angka
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
      onTap: isDate ? onTap : null,
    );
  }
}
