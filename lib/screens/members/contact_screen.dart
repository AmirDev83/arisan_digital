import 'package:arisan_digital/blocs/contact_cubit/contact_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    context.read<ContactCubit>().getContacts();
    super.initState();
  }

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
                BlocBuilder<ContactCubit, ContactState>(
                  builder: (context, state) {
                    if (state is ContactDataState) {
                      if (state.contactStatus == ContactStatus.success) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.listContacts!.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: 60),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    state.listContacts![index].displayName),
                                subtitle:
                                    state.listContacts![index].phones.length !=
                                            0
                                        ? Text(state.listContacts![index]
                                            .phones[0].number)
                                        : null,
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
                                    child: Image.asset(
                                        "assets/images/icons/man.png")),
                              );
                            });
                      }
                      return SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator());
                    }
                    return SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator());
                  },
                )
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
