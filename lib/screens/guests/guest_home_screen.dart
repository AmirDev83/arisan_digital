import 'package:arisan_digital/blocs/guest/guest_group_cubit/guest_group_cubit.dart';
import 'package:arisan_digital/models/member_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:arisan_digital/screens/history_screen.dart';
import 'package:arisan_digital/screens/starting_screen.dart';
import 'package:arisan_digital/utils/currency_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class GuestHomeScreen extends StatefulWidget {
  final String? code;
  const GuestHomeScreen({Key? key, this.code}) : super(key: key);

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  final GroupRepository _groupRepo = GroupRepository();
  bool isShow = false;

  void routeToStartingScreen() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const StartingScreen()),
      ModalRoute.withName('/starting-screen'),
    );
  }

  Future closeGroup() async {
    context.loaderOverlay.show();
    await _groupRepo.removeGroupCode();

    context.loaderOverlay.hide();
    routeToStartingScreen();
  }

  @override
  void initState() {
    context.read<GuestGroupCubit>().getGuestGroup(widget.code ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<GuestGroupCubit, GuestGroupState>(
        listener: (context, state) {
          if (state is GuestGroupDataState) {
            if (state.guestGroupStatus == GuestGroupStatus.loading) {
              context.loaderOverlay.show();
            } else {
              context.loaderOverlay.hide();
            }
          }
        },
        child: LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.6,
          overlayWidget: Center(
            child: LoadingAnimationWidget.waveDots(
              color: Colors.white,
              size: 70,
            ),
          ),
          child: CustomScrollView(slivers: [
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
                      onPressed: () => _showCloseGroupDialog(context))
                ],
                title: BlocBuilder<GuestGroupCubit, GuestGroupState>(
                  builder: (context, state) {
                    if (state is GuestGroupLoadingState) {
                      context.loaderOverlay.show();
                    }
                    if (state is GuestGroupDataState) {
                      if (state.guestGroupStatus == GuestGroupStatus.success) {
                        return Text(state.group!.name ?? '');
                      }
                    }
                    return const Text('Loading...');
                  },
                )),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
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
                                BlocBuilder<GuestGroupCubit, GuestGroupState>(
                                  builder: (context, state) {
                                    if (state is GuestGroupDataState) {
                                      if (state.guestGroupStatus ==
                                          GuestGroupStatus.success) {
                                        return Text(
                                          isShow
                                              ? currencyId.format(
                                                  state.group!.totalBalance)
                                              : '**********',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }
                                    }
                                    return Container();
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isShow = !isShow;
                                    });
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Icon(isShow
                                          ? Icons.visibility
                                          : Icons.visibility_off)),
                                )
                              ],
                            ),
                          ],
                        )),
                        BlocBuilder<GuestGroupCubit, GuestGroupState>(
                          builder: (context, state) {
                            if (state is GuestGroupDataState) {
                              if (state.guestGroupStatus ==
                                  GuestGroupStatus.success) {
                                return GestureDetector(
                                  onTap: () =>
                                      _qrCodeDialog(state.group!.code ?? ''),
                                  child: SizedBox(
                                      width: 50,
                                      child: Image.network(
                                          "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=${state.group!.code}&choe=UTF-8")),
                                );
                              }
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  )
                ],
              )
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              BlocBuilder<GuestGroupCubit, GuestGroupState>(
                builder: (context, state) {
                  if (state is GuestGroupDataState) {
                    if (state.guestGroupStatus == GuestGroupStatus.success) {
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.group!.periodsDateEn ?? '',
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        side: BorderSide(
                                            color: Colors.lightBlue.shade800)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return HistoryScreen(
                                        group: state.group,
                                      );
                                    }));
                                  },
                                  child: const Text('Lihat Riwayat')),
                            )
                          ],
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              BlocBuilder<GuestGroupCubit, GuestGroupState>(
                builder: (context, state) {
                  if (state is GuestGroupDataState) {
                    if (state.guestGroupStatus == GuestGroupStatus.success) {
                      return Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.group!.notes ??
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
                      );
                    }
                  }
                  return Container();
                },
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
              BlocBuilder<GuestGroupCubit, GuestGroupState>(
                builder: (context, state) {
                  if (state is GuestGroupDataState) {
                    if (state.guestGroupStatus == GuestGroupStatus.success) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(15),
                          itemCount: state.group!.members!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            MemberModel member = state.group!.members![index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: member.statusActive == 'inactive'
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5)
                                  : null,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      member.statusActive == 'inactive'
                                          ? BorderRadius.circular(10)
                                          : null,
                                  color: member.statusActive == 'inactive'
                                      ? Colors.red.shade400
                                      : null),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                          width: 40,
                                          child: Image.asset(
                                              "assets/images/icons/man.png")),
                                      member.isGetReward!
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            (member.name ?? '') +
                                                (member.canDelete != true
                                                    ? ' (Admin)'
                                                    : ''),
                                            style: TextStyle(
                                                color: member.statusActive ==
                                                        'inactive'
                                                    ? Colors.white
                                                    : null)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          member.noWhatsapp ??
                                              member.noTelp ??
                                              member.email ??
                                              '',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  member.statusActive != 'unpaid'
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: member.statusPaid == 'paid'
                                                ? Colors.green.shade400
                                                : member.statusPaid == 'cancel'
                                                    ? Colors.red.shade400
                                                    : Colors.blue.shade400,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(member.statusPaid ==
                                                  'paid'
                                              ? 'Sudah Bayar'
                                              : member.statusPaid == 'cancel'
                                                  ? 'Batal'
                                                  : 'Lewati'))
                                      : Container()
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
          ]),
        ),
      ),
    );
  }

  Future<void> _qrCodeDialog(String code) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.all(15),
          titlePadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Image.network(
                    "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=$code&choe=UTF-8"),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Salin Kode'),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: code));
                          Fluttertoast.showToast(msg: 'Kode berhasil di salin');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Bagikan'),
                        onPressed: () => Share.share(
                            'Yuk buka group lewat kode group dibawah ini!\n\nKode: $code'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCloseGroupDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Group',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Apakah kamu yakin ingin menutup group dari aplikasi?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: const Text('Batal', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue.shade700),
              child: const Text('Tutup', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                closeGroup();
              },
            ),
          ],
        );
      },
    );
  }
}
