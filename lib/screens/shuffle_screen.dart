import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ShuffleScreen extends StatefulWidget {
  const ShuffleScreen({Key? key}) : super(key: key);

  @override
  State<ShuffleScreen> createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
          backgroundColor: Colors.lightBlue.shade800,
          centerTitle: true,
          elevation: 0,
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         // createMemberModal(context);
          //       },
          //       icon: Icon(Icons.add)),
          // ],
          title: Text('')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.lightBlue.shade800,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kocok Sekarang!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ayo Goyangkan Smartphone-mu',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image.asset("assets/images/icons/shuffle.png"),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: LinearPercentIndicator(
                      // width: MediaQuery.of(context).size.width,
                      lineHeight: 25,
                      percent: 0.5,
                      barRadius: Radius.circular(10),
                      backgroundColor: Colors.grey,
                      progressColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.lightBlue.shade900,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.lightBlue.shade900)),
                    ),
                    onPressed: () {},
                    child: Text('Ulangi'),
                  )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlue.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text('Simpan'),
                  )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
