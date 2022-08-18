import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:
            CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
          SliverAppBar(
              floating: true,
              iconTheme: IconThemeData(color: Colors.grey.shade300),
              titleTextStyle: TextStyle(
                  color: Colors.lightBlue.shade800,
                  fontWeight: FontWeight.w500),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.cloud_download))
              ],
              title: Text('Riwayat')),
          SliverList(
              delegate: SliverChildListDelegate([
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 16,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 15, right: 15),
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 7,
                            offset: Offset(1, 3),
                          )
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 40,
                            child:
                                Image.asset("assets/images/icons/reward.png")),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Zakia Fhadillah',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 5),
                              Text('July, 10 2022')
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Rp 1.000.000'),
                            SizedBox(height: 5),
                            Text(
                              'Periode $index',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                })
          ])),
          SliverList(delegate: SliverChildListDelegate([])),
        ]));
  }
}
