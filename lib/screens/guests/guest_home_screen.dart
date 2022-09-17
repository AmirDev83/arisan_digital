import 'package:arisan_digital/utils/currency_format.dart';
import 'package:flutter/material.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({Key? key}) : super(key: key);

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.grey.shade300),
            // titleTextStyle: TextStyle(
            //     color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
            elevation: 0,
            backgroundColor: Colors.blue[700],
            actions: [
              IconButton(
                  icon: const Icon(
                    Icons.logout,
                  ),
                  onPressed: () {})
            ],
            title: const Text('Tetangga')),
        SliverList(
            delegate: SliverChildListDelegate([
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    color: Colors.blue[700]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 7,
                        offset: const Offset(1, 3),
                      )
                    ],
                    color: Colors.white),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo Arisan',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Rp ",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              false ? currencyId.format(0) : '**********',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              // onTap: () => context
                              //     .read<SelectedGroupCubit>()
                              //     .showBalance(),
                              child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Icon(true
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            )
                          ],
                        ),
                      ],
                    )),
                    GestureDetector(
                      // onTap: () =>
                      //     _qrCodeDialog(group.code ?? ''),
                      child: SizedBox(
                          width: 50,
                          child: Image.network(
                              "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=&choe=UTF-8")),
                    )
                  ],
                ),
              )
            ],
          )
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 7,
                    offset: const Offset(1, 3),
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
                        const Text(
                          'Tanggal Kocok Arisan',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '24 September 2022',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.lightBlue[700],
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: BorderSide(color: Colors.lightBlue.shade800)),
                      ),
                      onPressed: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (builder) {
                        //   return HistoryScreen(
                        //     group: group,
                        //   );
                        // }));
                      },
                      child: const Text('Lihat Riwayat')),
                )
              ],
            ),
          ),
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 7,
                    offset: const Offset(1, 3),
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
                    const Text(
                      'Info Group',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            null ??
                                'Informasi group masih kosong!\nTombol edit untuk merubah.',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Anggota Group',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(15),
              itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  // onTap: () =>
                  //     _detailMemberDialog(state.listMembers![index]),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: true
                        ? const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5)
                        : null,
                    decoration: BoxDecoration(
                        borderRadius: true ? BorderRadius.circular(10) : null,
                        color: true ? Colors.red.shade400 : null),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                                width: 40,
                                child:
                                    Image.asset("assets/images/icons/man.png")),
                            true
                                ? Container(
                                    width: 20,
                                    height: 40,
                                    alignment: Alignment.bottomLeft,
                                    child: Image.asset(
                                        "assets/images/icons/trophy-circle-2.png"),
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Roziq',
                                  style: TextStyle(
                                      color: true ? Colors.white : null)),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '984754453',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        true
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: true
                                      ? Colors.green.shade400
                                      : true == 'cancel'
                                          ? Colors.red.shade400
                                          : Colors.blue.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(true
                                    ? 'Sudah Bayar'
                                    : true
                                        ? 'Batal'
                                        : 'Lewati'))
                            : Container()
                      ],
                    ),
                  ),
                );
              })
        ])),
      ]),
    );
  }
}
