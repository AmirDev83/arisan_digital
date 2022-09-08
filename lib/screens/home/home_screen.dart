import 'package:arisan_digital/blocs/home/group_bloc/group_bloc.dart';
import 'package:arisan_digital/screens/create_group_screen.dart';
import 'package:arisan_digital/screens/history_screen.dart';
import 'package:arisan_digital/screens/home/widgets/group_list.dart';
import 'package:arisan_digital/screens/home/widgets/shimmer_group.dart';
import 'package:arisan_digital/screens/members/member_screen.dart';
import 'package:arisan_digital/screens/settings/setting_screen.dart';
import 'package:arisan_digital/screens/shuffle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<GroupBloc>().add(const GroupFetched(isRefresh: true));
    super.initState();
  }

  Future<void> _refresh() async {
    context.read<GroupBloc>().add(const GroupFetched(isRefresh: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.blue.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: CustomScrollView(slivers: [
          SliverAppBar(
              floating: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.blue[700],
              actions: [
                IconButton(
                    onPressed: () {
                      // widget.googleSignIn!.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return SettingScreen();
                      }));
                    },
                    icon: const Icon(Icons.settings)),
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return MemberScreen();
                      }));
                    },
                    icon: const Icon(Icons.person_add))
              ],
              title: Text('Arisan Digital')),
          SliverList(
              delegate: SliverChildListDelegate([
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                      color: Colors.blue[700]),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) {
                          return CreateGroupScreen();
                        }));
                      },
                      child: Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.only(left: 15, top: 5),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue[700]),
                          child: Icon(
                            Icons.group_add,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 5),
                        height: 30,
                        child: BlocBuilder<GroupBloc, GroupState>(
                          builder: (context, state) {
                            if (state.status == GroupStatus.initial ||
                                state.status == GroupStatus.failure) {
                              return const ShimmerGroups();
                            }

                            if (state.groups.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Tambahkan group arisan kamu dulu!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                            return GroupList(
                              groups: state.groups,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 55, left: 15, right: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 7,
                          offset: Offset(1, 3),
                        )
                      ],
                      color: Colors.white),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saldo Arisan',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rp ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                '10.000.000',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Icon(Icons.visibility_off))
                            ],
                          ),
                        ],
                      )),
                      Container(
                          width: 50,
                          child: Image.network(
                              "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=bauroziq&choe=UTF-8"))
                    ],
                  ),
                ),
              ],
            )
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Terakhir Bayar',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                            return MemberScreen();
                          }));
                        },
                        child: Row(
                          children: [
                            Text('Lihat Semua'),
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child: Image.asset("assets/images/icons/man.png")),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          'Anastasya R.',
                          style: TextStyle(fontSize: 13),
                        )),
                        Text(
                          'Rp1.000.000',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child:
                                Image.asset("assets/images/icons/woman.png")),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          'Budi Raharjo',
                          style: TextStyle(fontSize: 13),
                        )),
                        Text(
                          'Rp4.000.000',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child: Image.asset("assets/images/icons/man.png")),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          'Reza Rahardian',
                          style: TextStyle(fontSize: 13),
                        )),
                        Text(
                          'Rp3.600.000',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 7,
                      offset: Offset(1, 3),
                    )
                  ],
                  color: Colors.white),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Belum Setor',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rp ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '-8.000.000',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  )),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.red)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mail,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Tagih',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 7,
                      offset: Offset(1, 3),
                    )
                  ],
                  color: Colors.white),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal Kocok Arisan',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '26 August 2022',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                        child: Icon(
                          Icons.edit_calendar,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.lightBlue[700],
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side:
                                  BorderSide(color: Colors.lightBlue.shade800)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                            return HistoryScreen();
                          }));
                        },
                        child: Text('Lihat Riwayat')),
                  )
                ],
              ),
            ),
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 7,
                      offset: Offset(1, 3),
                    )
                  ],
                  color: Colors.white),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Info Grub',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Grub kantor yang dikelola oleh markom, tim IT, leaders, dan kru OB.',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ])),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) {
                      return ShuffleScreen();
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Kocok Arisan Sekarang!'),
                  )),
            )
          ])),
          SliverList(delegate: SliverChildListDelegate([])),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 50,
            )
          ])),
        ]),
      ),
    );
  }
}
