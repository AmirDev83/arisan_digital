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
            elevation: 0,
            backgroundColor: Colors.blue[700],
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            ],
            centerTitle: true,
            title: Text('Member')),
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
