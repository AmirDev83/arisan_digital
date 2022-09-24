import 'dart:math';

import 'package:arisan_digital/blocs/home/group_bloc/group_bloc.dart';
import 'package:arisan_digital/blocs/shuffle_cubit/shuffle_cubit.dart';
import 'package:arisan_digital/models/arisan_history_model.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/models/member_model.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:arisan_digital/utils/date_config.dart';
import 'package:arisan_digital/utils/loading_overlay.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShuffleScreen extends StatefulWidget {
  final List<MemberModel>? members;
  final GroupModel? group;
  const ShuffleScreen({Key? key, this.members, this.group}) : super(key: key);

  @override
  State<ShuffleScreen> createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen>
    with TickerProviderStateMixin {
  MemberModel? winner;
  bool isInit = true;

  late AnimationController controller;

  Future<MemberModel> getRandomWinner() async {
    final random = Random();
    MemberModel item = widget.members![random.nextInt(widget.members!.length)];
    // print(item);
    return item;
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void startShuffle() async {
    winner = null;
    isInit = false;
    setState(() {});
    controller.reset();
    playMusicLoading();
    await controller.forward();
    winner = await getRandomWinner();
    playMusicWinner();
    setState(() {});
  }

  void playMusicLoading() {
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/audios/loading.wav"),
      showNotification: false,
    );
  }

  void playMusicWinner() {
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/audios/winner.wav"),
      showNotification: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShuffleCubit, ShuffleState>(
      listener: (context, state) {
        if (state is ShuffleDataState) {
          if (state.shuffleStatus == ShuffleStatus.loading) {
            LoadingOverlay.show(context);
          } else if (state.shuffleStatus == ShuffleStatus.success) {
            LoadingOverlay.hide(context);
            CustomSnackbar.awesome(context,
                message: state.message ?? '', type: ContentType.success);
            context.read<GroupBloc>().add(const GroupFetched(isRefresh: true));
            Navigator.pop(context);
          } else {
            LoadingOverlay.hide(context);
            CustomSnackbar.awesome(context,
                message: state.message ?? '', type: ContentType.failure);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
            backgroundColor: winner == null
                ? Colors.lightBlue.shade800
                : Colors.lightGreen.shade800,
            centerTitle: true,
            elevation: 0,
            title: const Text('')),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: GestureDetector(
                onTap: () {
                  if (isInit) {
                    startShuffle();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: winner == null
                          ? Colors.lightBlue.shade800
                          : Colors.lightGreen.shade800,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        winner == null
                            ? 'Kocok Sekarang!'
                            : 'Selamat Kepada\n🎉🎉🎉\n${winner!.name}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        winner == null
                            ? isInit
                                ? 'Tap untuk memulai mengocok!'
                                : 'Mohon tunggu...'
                            : 'Telah memenangkan arisan hari ini.',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      winner == null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Image.asset(
                                  "assets/images/icons/shuffle.png"),
                            )
                          : Stack(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Image.asset(
                                      "assets/images/icons/trophy.png"),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Image.asset(
                                      "assets/images/icons/trophy-circle.png"),
                                )
                              ],
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      // winner == null
                      //     ? Container(
                      //         margin: const EdgeInsets.symmetric(horizontal: 25),
                      //         child: LinearProgressIndicator(
                      //           minHeight: 25,
                      //           color: Colors.white,
                      //           backgroundColor: Colors.grey,
                      //           value: controller.value,
                      //           semanticsLabel: 'Linear progress indicator',
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    winner == null
                        ? Expanded(
                            child: LinearProgressIndicator(
                            minHeight: 25,
                            color: Colors.lightBlue.shade800,
                            backgroundColor: Colors.grey.shade300,
                            value: controller.value,
                            semanticsLabel: 'Linear progress indicator',
                          ))
                        : Container(),
                    winner != null
                        ? Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: winner == null
                                    ? Colors.lightBlue.shade900
                                    : Colors.lightGreen.shade900,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        color: winner == null
                                            ? Colors.lightBlue.shade900
                                            : Colors.lightGreen.shade900)),
                              ),
                              onPressed: () => startShuffle(),
                              child: const Text('Ulangi'),
                            ),
                          )
                        : Container(),
                    winner != null
                        ? const SizedBox(
                            width: 10,
                          )
                        : Container(),
                    winner != null
                        ? Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: winner == null
                                    ? Colors.lightBlue.shade800
                                    : Colors.lightGreen.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                context
                                    .read<ShuffleCubit>()
                                    .saveShuffleResult(ArisanHistoryModel(
                                      date: DateConfig.dateToString(
                                          DateTime.now()),
                                      notes: '',
                                      winner: MemberModel(
                                        id: winner!.id,
                                        group: widget.group,
                                      ),
                                    ));
                              },
                              child: const Text('Simpan'),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
