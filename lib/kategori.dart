import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:bangkodeflutter/topik.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  int dataLength = 0;
  List<Map<String, String>> dataKategori = [];
  String url = Platform.isAndroid
      ? 'http://192.168.1.9/bangkode/kategori.php'
      : 'http://localhost/bangkode/kategori.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataLength = data.length;
        dataKategori = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama_kategori': item['nama_kategori'] as String,
            'foto': item['foto'] as String,
            'id_kategori': item['id_kategori'] as String,
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
          title: const Text('Bahasa Pemrograman'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(10.0), // Sesuaikan tinggi sesuai kebutuhan
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${dataLength} Bahasa',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontStyle: FontStyle.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: dataKategori.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopikPage(
                          id_kategori:
                              int.parse(dataKategori[index]['id_kategori']!),
                          nama_kategori: dataKategori[index]['nama_kategori']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(dataKategori[index]['nama_kategori']!),
                      subtitle: Text(dataKategori[index]['id_kategori']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
