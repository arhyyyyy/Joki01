import 'package:flutter/material.dart';

import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationPage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();  // Changed
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header hijau dengan tombol kembali
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF001A6E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.07,
                horizontal: screenWidth * 0.05,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'REGISTRASI AKUN!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Form input
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input NIK
                  TextField(
                    controller: _nikController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'NIK',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                       fillColor: Color(0xFF001A6E),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Tanggal Lahir
                  TextField(
                    controller: _dobController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFF001A6E),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Nama Lengkap
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Nama Lengkap',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                       fillColor: Color(0xFF001A6E),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Alamat Lengkap (Replaced username with address)
                  TextField(
                    controller: _addressController,  // Changed
                    decoration: InputDecoration(
                      hintText: 'Alamat Lengkap',  // Changed
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                       fillColor: Color(0xFF001A6E),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Nomor Telepon
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Nomor Telepon',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFF001A6E),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Kata Sandi
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Kata Sandi',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                       fillColor: Color(0xFF001A6E),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Konfirmasi Kata Sandi
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi Kata Sandi',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                       fillColor: Color(0xFF001A6E),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Tombol "Daftar"
                  ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text == _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Akun berhasil dibuat')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kata sandi tidak cocok')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFF001A6E),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}