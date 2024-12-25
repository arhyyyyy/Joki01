import 'package:flutter/material.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  int _selectedCandidate = -1;

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
          itemCount: 2,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}', // Nomor urut kandidat
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
                          'assets/Calon.png', // Path gambar kandidat
                          width: 200,
                          height: 160,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCandidate = index; // Set kandidat yang dipilih
                      });
                      // Menampilkan SnackBar untuk notifikasi "Voting Berhasil"
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                    'Voting berhasil untuk kandidat ${index + 1}', // String dinamis diperbolehkan
                    style: const TextStyle(color: Colors.white),
                    ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                      ),
                    );
                      print('Voted for candidate ${index + 1}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001A6E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                    ),
                    child: const Text(
                      'ARDI & GIBRAN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<int>(
                    value: index,
                    groupValue: _selectedCandidate,
                    onChanged: (value) {
                      setState(() {
                        _selectedCandidate = value!;
                      });
                      print('Selected candidate ${index + 1}');
                    },
                    title: const Text(
                      'Vote',
                      style: TextStyle(color: Color(0xFF001A6E)),
                    ),
                    activeColor: const Color(0xFF001A6E),
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
