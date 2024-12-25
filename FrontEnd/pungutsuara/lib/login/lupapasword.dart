import 'package:flutter/material.dart';
import 'package:pungutsuara/login/login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with back arrow and "LUPA Password"
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
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
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
                      'LUPA PASSWORD',
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
            Center(
              child: Icon(
                Icons.lock,
                size: 120,
                color: Color(0xFF001A6E),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Description
            const Center(
              child: Text(
                'Atur Ulang Password Anda',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001A6E),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Form input
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input Nama Pengguna
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'NIK',
                      hintStyle:
                          TextStyle(color: Colors.grey), // Grey hint text
                      border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFF001A6E), // Fill color
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Password Baru
                  TextField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password Baru',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFF001A6E),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Input Konfirmasi Password
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFF001A6E),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Tombol "Atur"
                  ElevatedButton(
                    onPressed: () {
                      if (_newPasswordController.text ==
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Password berhasil diubah')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Password tidak cocok')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF001A6E),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Atur Password',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Teks "Kembali ke Halaman Login"
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}