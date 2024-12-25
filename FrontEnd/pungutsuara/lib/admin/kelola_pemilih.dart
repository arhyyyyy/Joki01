import 'package:flutter/material.dart';
import 'package:pungutsuara/admin/edit_data_pemilih.dart';
import 'package:pungutsuara/admin/tambah_data_pemilih.dart';

class KelolaPemilihPage extends StatefulWidget {
  const KelolaPemilihPage({super.key});

  @override
  _KelolaPemilihPageState createState() => _KelolaPemilihPageState();
}

class _KelolaPemilihPageState extends State<KelolaPemilihPage> {
  List<Map<String, String>> pemilihData = List.generate(
    5,
    (index) => {
      'nik': '1234567890${index + 1}',
      'ttl': '01-01-200${index + 1}',
      'nama': 'Nama Pemilih ${index + 1}',
      'noTlp': '0812-3456-789${index + 1}',
      'alamat': 'Alamat ${index + 1}, Kota ABC',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF001A6E),
        title: const Text(
          'Kelola Pemilih',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'DATA',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001A6E),
                  ),
                ),
                const SizedBox(height: 5), 
                Text(
                  'PEMILIH',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001A6E),
                  ),
                ),
                const SizedBox(height: 55),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => const Color(0xFF001A6E)),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: const [
                    DataColumn(label: Text('NIK')),
                    DataColumn(label: Text('TTL')),
                    DataColumn(label: Text('Nama Lengkap')),
                    DataColumn(label: Text('No. Tlp')),
                    DataColumn(label: Text('Alamat Lengkap')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: List.generate(pemilihData.length, (index) {
                    return DataRow(cells: [
                      DataCell(Text(pemilihData[index]['nik']!)),
                      DataCell(Text(pemilihData[index]['ttl']!)),
                      DataCell(Text(pemilihData[index]['nama']!)),
                      DataCell(Text(pemilihData[index]['noTlp']!)),
                      DataCell(Text(pemilihData[index]['alamat']!)),
                      DataCell(
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditDataPemilih(
                                          index: index + 1),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showDeleteConfirmationDialog(context, index);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  text: 'Tambah',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahDataPemilih(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus pemilih ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pemilihData.removeAt(index); 
                });
                Navigator.of(context).pop(); 
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF001A6E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
