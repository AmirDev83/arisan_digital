import 'package:arisan_digital/screens/members/create_member_screen.dart';
import 'package:flutter/material.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
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
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 500,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Tambah Anggota',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Masukkan data anggota arisan.',
                                style: TextStyle(fontSize: 14),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: "Nama Anggota"),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        helperText:
                                            "* Notifikasi akan dikirimkan melalui email.",
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: "Email (Opsional)"),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelStyle: TextStyle(fontSize: 14),
                                        labelText: "No Telp"),
                                  )),
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Center(child: const Text('Atau'))),
                              Container(
                                // margin: EdgeInsets.all(15),
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: const Text('Tambahkan dari Contact'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (builder) {
                    //   return CreateMemberScreen();
                    // }));
                  },
                  icon: Icon(Icons.add)),
            ],
            title: Text('Anggota')),
        SliverList(
            delegate: SliverChildListDelegate([
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(15),
              itemCount: 15,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                              width: 40,
                              child:
                                  Image.asset("assets/images/icons/man.png")),
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.bottomLeft,
                            child: Icon(
                              Icons.circle,
                              color: index % 5 != 0
                                  ? Colors.green.shade500
                                  : Colors.red.shade500,
                              size: 15,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Roziq'),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '0845747854',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      index % 3 != 0
                          ? Container(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text('Sudah Bayar')),
                            )
                          : Container()
                    ],
                  ),
                );
              })
        ])),
        SliverList(delegate: SliverChildListDelegate([])),
      ]),
    );
  }
}
