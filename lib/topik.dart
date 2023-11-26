import 'dart:convert';
import 'dart:io';

import 'package:bangkodeflutter/kategori.dart';
import 'package:bangkodeflutter/materi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopikPage extends StatefulWidget {
  final int id_kategori;
  final String nama_kategori;

  const TopikPage(
      {Key? key, required this.id_kategori, required this.nama_kategori})
      : super(key: key);

  @override
  State<TopikPage> createState() => _TopikPageState();
}

class _TopikPageState extends State<TopikPage> {
  List<Map<String, String>> dataTopik = [];
  late String url;
  int dataLength = 0;

  @override
  void initState() {
    super.initState();
    url = Platform.isAndroid
        ? 'http://192.168.1.9/bangkode/topik.php?id_kategori=${widget.id_kategori}'
        : 'http://localhost/bangkode/topik.php?id_kategori=${widget.id_kategori}';
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataLength = data.length;
        dataTopik = List<Map<String, String>>.from(data.map((item) {
          return {
            'nama_topik': item['nama_topik'] as String,
            'logo_topik': item['logo_topik'] as String,
            'id_kategori': item['id_kategori'].toString(),
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
        title: Text('${widget.nama_kategori}'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize:
              const Size.fromHeight(10.0), // Sesuaikan tinggi sesuai kebutuhan
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '${dataLength} Topik',
              style: const TextStyle(
                fontSize: 14.0,
                fontStyle: FontStyle.normal,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: dataTopik.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Pass ID to the next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MateriPage(
                          id_topik: int.parse(dataTopik[index]['id_topik']!),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(dataTopik[index]['nama_topik']!),
                      subtitle: Text(dataTopik[index]['id_kategori']!),
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
