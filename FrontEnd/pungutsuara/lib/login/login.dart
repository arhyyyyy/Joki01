import 'package:flutter/material.dart';
import 'package:pungutsuara/admin/dashboard.dart';
import 'package:pungutsuara/login/lupapasword.dart';
import 'package:pungutsuara/user/dashboard.dart';
import 'registrasi.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true; // Status awal untuk visibilitas sandi
  String? _selectedRole; // Untuk menyimpan jenis pengguna yang dipilih

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFE8E8E8),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Color(0xFF001A6E),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Icon(
                          Icons.how_to_vote,
                          size: 120,
                          color: Color(0xFF001A6E),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'SISTEM',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF001A6E),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'PEMUNGUTAN SUARA',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Color(0xFF001A6E),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 150),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                          hintText: 'Username/NIK',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Color(0xFF001A6E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outlined, color: Colors.white),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Mengubah status visibilitas sandi
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Color(0xFF001A6E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF001A6E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Color(0xFF001A6E),
                        hint: Text(
                          '-Pilih Jenis Pengguna-',
                          style: TextStyle(color: Colors.grey),
                        ),
                        items: ['Admin', 'User']
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue; // Simpan jenis pengguna yang dipilih
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 16),
                            child: Text(
                              'Lupa Password',
                              style: TextStyle(
                                color: Color(0xFF001A6E),
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedRole == 'Admin') {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardAdmin()),
                              (route) => false,
                            );
                          } else if (_selectedRole == 'User') {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => DashboardUser()), // Buat halaman user
                              (route) => false,
                            );
                          } else {
                            // Tampilkan pesan jika jenis pengguna belum dipilih
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Pilih jenis pengguna terlebih dahulu!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF001A6E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: screenWidth * 0.2,
                          ),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum Registrasi Akun? ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Registrasi akun',
                                style: TextStyle(
                                  color: Color(0xFF001A6E),
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
