import 'package:arisan_digital/blocs/arisan_history_cubit/arisan_history_cubit.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/screens/history_detail_screen.dart';
import 'package:arisan_digital/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
        body: LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.6,
          overlayWidget: Center(
            child: LoadingAnimationWidget.waveDots(
              color: Colors.white,
              size: 70,
            ),
          ),
          child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                    floating: true,
                    iconTheme: IconThemeData(color: Colors.grey.shade300),
                    titleTextStyle: TextStyle(
                        color: Colors.lightBlue.shade800,
                        fontWeight: FontWeight.w500),
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    elevation: 0,
                    // actions: [
                    //   IconButton(onPressed: () {}, icon: Icon(Icons.cloud_download))
                    // ],
                    title: const Text('Riwayat')),
                SliverList(
                    delegate: SliverChildListDelegate([
                  BlocBuilder<ArisanHistoryCubit, ArisanHistoryState>(
                    builder: (context, state) {
                      if (state is ArisanHistoryDataState) {
                        if (state.arisanHistoryStatus ==
                            ArisanHistoryStatus.loading) {
                          context.loaderOverlay.show();
                        } else {
                          context.loaderOverlay.hide();
                        }
                      }
                      if (state is ArisanHistoryDataState) {
                        if (state.arisanHistoryStatus ==
                            ArisanHistoryStatus.failure) {
                          return Container();
                        } else if (state.arisanHistoryStatus ==
                            ArisanHistoryStatus.success) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.arisanHistories!.length,
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return HistoryDetailScreen(
                                        arisanHistory:
                                            state.arisanHistories![index],
                                        periode: index + 1,
                                      );
                                    }));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 40,
                                            child: Image.asset(
                                                "assets/images/icons/reward.png")),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  state.arisanHistories?[index]
                                                          .winner!.name ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(height: 5),
                                              Text(state.arisanHistories?[index]
                                                      .date ??
                                                  '')
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                'Rp${currencyId.format(widget.group!.dues)}'),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Periode ${index + 1}',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      }
                      return Container();
                    },
                  )
                ])),
              ]),
        ));
  }
}
