import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class FirebaseService {
  final String _firebaseKandidatUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat.json'; // URL untuk mengambil data kandidat

  // Fungsi untuk mengambil data kandidat
  Future<List<Map<String, dynamic>>> getKandidat() async {
    try {
      final response = await http.get(Uri.parse(_firebaseKandidatUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> candidates = [];

        data.forEach((key, value) {
          if (value != null) {
            candidates.add({
              'id': key, // Mengambil id kandidat dari Firebase
              'noUrut': value['noUrut'],
              'namaKetua': value['namaKetua'],
              'namaWakil': value['namaWakil'],
              'namaPartai': value['namaPartai'],
              'visiMisi': value['visiMisi'],
            });
          }
        });
        return candidates;
      } else {
        throw Exception("Gagal mengambil data kandidat");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  final String _firebaseVoteUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/votes.json'; // URL untuk mengambil hasil voting

  // Fungsi untuk mengambil hasil voting
  Future<List<Map<String, dynamic>>> getVoteResults() async {
    try {
      final response = await http.get(Uri.parse(_firebaseVoteUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> results = [];

        data.forEach((key, value) {
          if (value != null) {
            results.add({'candidateId': value['candidateId']});
          }
        });
        return results;
      } else {
        throw Exception("Gagal mengambil hasil voting");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}


class HasilVotingPage extends StatefulWidget {
  const HasilVotingPage({super.key});

  @override
  _HasilVotingPageState createState() => _HasilVotingPageState();
}

class _HasilVotingPageState extends State<HasilVotingPage> {
  List<Map<String, dynamic>> _candidates = [];
  List<Map<String, dynamic>> _voteResults = [];

  @override
  void initState() {
    super.initState();
    _getKandidatAndVoteResults();
  }

  Future<void> _getKandidatAndVoteResults() async {
    final firebaseService = FirebaseService();

    // Ambil data kandidat dari Firebase
    final candidates = await firebaseService.getKandidat();

    // Ambil hasil voting dari Firebase
    final results = await firebaseService.getVoteResults();

    // Hitung jumlah suara untuk setiap kandidat
    Map<String, int> voteCount = {};
    for (var result in results) {
      final candidateId = result['candidateId'];
      voteCount[candidateId] = (voteCount[candidateId] ?? 0) + 1;
    }

    // Gabungkan data kandidat dengan jumlah suara
    List<Map<String, dynamic>> candidatesWithVoteCount = [];
    for (var candidate in candidates) {
      final candidateId = candidate['id'];
      final voteCountForCandidate = voteCount[candidateId] ?? 0;
      candidatesWithVoteCount.add({
        'name': candidate['namaKetua'], // Menggunakan nama ketua sebagai nama kandidat
        'voteCount': voteCountForCandidate,
      });
    }

    setState(() {
      _candidates = candidatesWithVoteCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF001A6E),
        title: const Text(
          "Pantau Hasil Voting",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 55),
            const Center(
              child: Text(
                "HASIL VOTING",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001A6E),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: const Color(0xFF001A6E),
                            ),
                            Positioned(
                              top: 10,
                              child: Image.asset(
                                'assets/Calon.png', // Ganti dengan path gambar
                                width: 65,
                                height: 55,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${candidate['voteCount']} Suara", // Tampilkan jumlah suara
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: (candidate['voteCount'] ?? 0) /
                                    (_candidates.isEmpty ? 1 : _candidates.length), // Gunakan 0 jika voteCount null
                                backgroundColor: Colors.grey[300],
                                color: const Color(0xFF001A6E),
                                minHeight: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
