import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String dropdownValue = 'Mingguan';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group'),
        iconTheme: IconThemeData(color: Colors.grey.shade300),
        titleTextStyle: TextStyle(
            color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah Group Arisan!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.lightBlue.shade900),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Tentukan nama group arisan yang kamu kelola sekarang.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    child: Image.asset("assets/images/world-group.png"),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    decoration: InputDecoration(
                        // label: Text('Nama Group'),
                        helperText: "* Contoh: kantor, komplek, dll.",
                        labelText: "Nama Group"),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Nominal Iuran"),
                  )),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                  underline: Container(
                    height: 1,
                    color: Colors.grey.shade500,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Mingguan', 'Bulanan', 'Tahunan']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Tambah Group'),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
