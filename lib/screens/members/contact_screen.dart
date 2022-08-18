import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
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
                  title: Text('Contact')),
              SliverList(
                  delegate: SliverChildListDelegate([
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 16,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 60),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Zakia Fhadillah'),
                        subtitle: Text('6285604959785'),
                        trailing: Checkbox(
                          checkColor: Colors.white,
                          value: false,
                          onChanged: (bool? value) {
                            setState(() {
                              // isChecked = value!;
                            });
                          },
                        ),
                        leading: SizedBox(
                            width: 40,
                            child: Image.asset("assets/images/icons/man.png")),
                      );
                    })
              ])),
              SliverList(delegate: SliverChildListDelegate([])),
            ]),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Simpan'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return ContactScreen();
                    }));
                  },
                ),
              ),
            )
          ],
        ));
  }
}
