import 'package:arisan_digital/models/arisan_history_model.dart';
import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatefulWidget {
  final ArisanHistoryModel? arisanHistory;
  final int? periode;
  const HistoryDetailScreen({Key? key, this.arisanHistory, this.periode})
      : super(key: key);

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
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
            title: Text(widget.arisanHistory!.winner!.name ?? '')),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            margin:
                const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 7,
                    offset: const Offset(1, 3),
                  )
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 3,
                          child: Text(
                            'Tanggal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          flex: 5,
                          child: Text(widget.arisanHistory!.date ?? '')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 3,
                          child: Text(
                            'Pemenang',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          flex: 5,
                          child:
                              Text(widget.arisanHistory!.winner!.name ?? '')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Expanded(
                          flex: 3,
                          child: Text(
                            'Periode',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Expanded(
                          flex: 5, child: Text(widget.periode!.toString())),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ])),
        SliverList(
            delegate: SliverChildListDelegate([
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: widget.arisanHistory!.arisanHistoryDetails!.length,
              itemBuilder: (context, index) {
                ArisanHistoryDetail arisanHistoryDetail =
                    widget.arisanHistory!.arisanHistoryDetails![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: arisanHistoryDetail.statusActive == 'inactive'
                      ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                      : null,
                  decoration: BoxDecoration(
                      borderRadius:
                          arisanHistoryDetail.statusActive == 'inactive'
                              ? BorderRadius.circular(10)
                              : null,
                      color: arisanHistoryDetail.statusActive == 'inactive'
                          ? Colors.red.shade400
                          : null),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                              width: 40,
                              child:
                                  Image.asset("assets/images/icons/man.png")),
                          arisanHistoryDetail.member!.id! ==
                                  widget.arisanHistory!.winner!.id!
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
                            Text(arisanHistoryDetail.member!.name ?? '',
                                style: TextStyle(
                                    color: arisanHistoryDetail.statusActive ==
                                            'inactive'
                                        ? Colors.white
                                        : null)),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              arisanHistoryDetail.member!.noTelp ??
                                  (arisanHistoryDetail.member!.email ?? ''),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      arisanHistoryDetail.statusPaid != 'unpaid'
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: arisanHistoryDetail.statusPaid ==
                                        'paid'
                                    ? Colors.green.shade400
                                    : arisanHistoryDetail.statusPaid == 'cancel'
                                        ? Colors.red.shade400
                                        : Colors.blue.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(arisanHistoryDetail.statusPaid ==
                                      'paid'
                                  ? 'Sudah Bayar'
                                  : arisanHistoryDetail.statusPaid == 'cancel'
                                      ? 'Batal'
                                      : 'Lewati'))
                          : Container()
                    ],
                  ),
                );
              })
        ])),
      ]),
    );
  }
}
