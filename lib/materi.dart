import 'dart:convert';
import 'dart:io';

import 'package:bangkodeflutter/detailMateri.dart';
import 'package:bangkodeflutter/kategori.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MateriPage extends StatefulWidget {
  final int id_topik;

  const MateriPage({Key? key, required this.id_topik}) : super(key: key);

  @override
  State<MateriPage> createState() => _MateriPageState();
}

class _MateriPageState extends State<MateriPage> {
  List<Map<String, String>> dataMateri = [];
  late String url;

  @override
  void initState() {
    super.initState();
    url = Platform.isAndroid
        ? 'http://192.168.1.9/bangkode/materi.php?id_topik=${widget.id_topik}'
        : 'http://localhost/bangkode/materi.php?id_topik=${widget.id_topik}';
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataMateri = List<Map<String, String>>.from(data.map((item) {
          return {
            'judul_materi': item['judul_materi'] as String,
            'url_materi': item['url_materi'] as String,
            'deskripsi_materi': item['deskripsi_materi'] as String,
            'id_topik': item['id_topik'].toString(),
          };
        }));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Topik'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: dataMateri.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Pass ID to the next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMateri(
                          id_materi: int.parse(dataMateri[index]['id_materi']!),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(dataMateri[index]['judul_materi']!),
                      subtitle: Text(dataMateri[index]['id_topik']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
