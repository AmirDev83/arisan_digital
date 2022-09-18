import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        SliverAppBar(
            floating: true,
            iconTheme: IconThemeData(color: Colors.grey.shade300),
            titleTextStyle: TextStyle(
                color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            title: const Text('Tentang Aplikasi')),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Arisan Digital Online adalah aplikasi untuk mengelola arisan kamu menjadi lebih mudah dan cepat. Dengan menggunakan aplikasi Arisan Digital, kamu dapat melihat data-data arisan dimanapun dan kapan pun, jadi kamu tidak perlu membawa buku arisan secara fisik.',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                      'Kocok pemenang arisan hanya dengan sekali klik saja, maka aplikasi akan mencarikan pemenang untuk arisan. Kamu tidak perlu lagi repot-repot membuat kertas kocokan untuk mendapat kan pemenang arisan dalam periode tertentu.',
                      style: TextStyle(color: Colors.grey.shade800)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                      'Lihat riwayat hasil pemenang arisan pada periode tertentu lebih mudah. Bahkan, semua anggota dapat melihat detail tentang arisan yang kamu kelola.',
                      style: TextStyle(color: Colors.grey.shade800)),
                ),
              ],
            ),
          )
        ])),
        SliverList(delegate: SliverChildListDelegate([])),
      ]),
    );
  }
}
