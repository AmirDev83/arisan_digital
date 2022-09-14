import 'package:arisan_digital/blocs/arisan_history_cubit/arisan_history_cubit.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatefulWidget {
  final GroupModel? group;
  const HistoryScreen({Key? key, this.group}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    context.read<ArisanHistoryCubit>().getArisanHistories(widget.group!.id!);
    super.initState();
  }

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
            BlocBuilder<ArisanHistoryCubit, ArisanHistoryState>(
              builder: (context, state) {
                print(state);
                if (state is ArisanHistoryDataState) {
                  if (state.arisanHistoryStatus ==
                      ArisanHistoryStatus.failure) {
                    return Container();
                  } else if (state.arisanHistoryStatus ==
                      ArisanHistoryStatus.success) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.arisanHistories!.length,
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
                                    child: Image.asset(
                                        "assets/images/icons/reward.png")),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          state.arisanHistories?[index].winner!
                                                  .name ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 5),
                                      Text(state.arisanHistories?[index].date ??
                                          '')
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Rp 1.000.000'),
                                    SizedBox(height: 5),
                                    Text(
                                      'Periode ${index + 1}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }
                }
                return Container();
              },
            )
          ])),
          SliverList(delegate: SliverChildListDelegate([])),
        ]));
  }
}
