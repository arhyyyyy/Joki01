import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseService {
  final String _firebaseVoteUrl =
      'https://pungutsuara-56dc7-default-rtdb.firebaseio.com/votes.json'; // URL untuk menyimpan hasil voting

  Future<void> submitVote(String candidateId) async {
    try {
      final response = await http.post(
        Uri.parse(_firebaseVoteUrl),
        body: json.encode({'candidateId': candidateId}),
      );

      if (response.statusCode == 200) {
        print("Vote berhasil disimpan");
      } else {
        print("Gagal menyimpan vote");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class VisiMisiPage extends StatelessWidget {
  final int candidateIndex;
  final String candidateId;

  const VisiMisiPage({
    super.key,
    required this.candidateIndex,
    required this.candidateId, required String visiMisi,
  });

  Future<String> _fetchVisiMisi() async {
    final url =
        "https://pungutsuara-56dc7-default-rtdb.firebaseio.com/kandidat/$candidateId.json";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['visiMisi'] ?? "Visi dan misi tidak tersedia.";
    } else {
      throw Exception("Gagal mengambil data visi dan misi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A6E),
        title: Text(
          "Visi & Misi Kandidat ${candidateIndex + 1}",
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color(0xFFE8F0FA),
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: _fetchVisiMisi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Gagal memuat visi dan misi.",
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001A6E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "VISI & MISI",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.data ?? "Visi dan misi tidak tersedia.",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final firebaseService = FirebaseService();
                      await firebaseService.submitVote(candidateId);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Vote berhasil dikirim!"),
                        ),
                      );

                      // Kembali ke halaman sebelumnya setelah vote
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001A6E),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Vote",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
