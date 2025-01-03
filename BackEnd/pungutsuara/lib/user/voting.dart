import 'package:flutter/material.dart';
import 'package:pungutsuara/user/visimisi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseService {
  final String _firebaseKandidatUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat.json';

  Future<List<Map<String, String>>> getKandidatData() async {
    try {
      final response = await http.get(Uri.parse(_firebaseKandidatUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, String>> kandidatList = [];

        data.forEach((key, value) {
          if (value != null) {
            kandidatList.add({
              'id': key,
              'nama': value['namaPartai'] ?? '',
              'gambar': 'assets/Calon.png',
              'ketua': value['namaKetua'] ?? '',
              'wakil': value['namaWakil'] ?? '',
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
}

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  int _selectedCandidate = -1;
  List<Map<String, String>> _kandidatList = [];

  @override
  void initState() {
    super.initState();
    _getKandidatData();
    _checkIfUserHasVoted();
  }

  // Mengecek apakah pengguna sudah melakukan voting
  Future<void> _checkIfUserHasVoted() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasVoted = prefs.getBool('hasVoted') ?? false;

    if (hasVoted) {
      setState(() {
        _selectedCandidate = -1; // Nonaktifkan pemilihan jika sudah voting
      });
    }
  }

  // Fungsi untuk menyimpan status voting
  Future<void> _setHasVoted() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasVoted', true);
  }

  void _getKandidatData() async {
    final firebaseService = FirebaseService();
    final kandidatData = await firebaseService.getKandidatData();
    setState(() {
      _kandidatList = kandidatData;
    });
  }

  void _navigateToVisiMisiPage(BuildContext context, int candidateIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisiMisiPage(
          candidateIndex: candidateIndex,
          candidateId: _kandidatList[candidateIndex]['id'] ?? '',
          visiMisi: _kandidatList[candidateIndex]['visiMisi'] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A6E),
        title: const Text(
          "Voting",
          style: TextStyle(fontSize: 24, color: Colors.white),
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
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _kandidatList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001A6E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          color: const Color(0xFF001A6E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        child: Image.asset(
                          _kandidatList[index]['gambar'] ?? 'assets/Calon.png',
                          width: 200,
                          height: 160,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error,
                                size: 160, color: Colors.red);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<int>(  // Radio button untuk memilih kandidat
                        value: index,
                        groupValue: _selectedCandidate,
                        onChanged: (value) {
                          if (_selectedCandidate == -1) {
                            setState(() {
                              _selectedCandidate = value!;
                            });
                            _setHasVoted();  // Set status sudah voting
                            _navigateToVisiMisiPage(context, index);
                          }
                        },
                        activeColor: const Color(0xFF001A6E),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _kandidatList[index]['nama'] ?? 'Nama Kandidat',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF001A6E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                'Ketua: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A6E),
                                ),
                              ),
                              Text(
                                _kandidatList[index]['ketua'] ?? 'Tidak ada ketua',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A6E),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                'Wakil: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A6E),
                                ),
                              ),
                              Text(
                                _kandidatList[index]['wakil'] ?? 'Tidak ada wakil',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF001A6E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
