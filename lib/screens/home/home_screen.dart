import 'package:arisan_digital/blocs/groups/update_group_cubit/update_group_cubit.dart';
import 'package:arisan_digital/blocs/home/group_bloc/group_bloc.dart';
import 'package:arisan_digital/blocs/home/selected_group_cubit/selected_group_cubit.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/models/member_model.dart';
import 'package:arisan_digital/screens/groups/create_group_screen.dart';
import 'package:arisan_digital/screens/history_screen.dart';
import 'package:arisan_digital/screens/home/widgets/group_list.dart';
import 'package:arisan_digital/screens/home/widgets/shimmer_group.dart';
import 'package:arisan_digital/screens/members/member_screen.dart';
import 'package:arisan_digital/screens/settings/setting_screen.dart';
import 'package:arisan_digital/screens/shuffle_screen.dart';
import 'package:arisan_digital/utils/currency_format.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Date Picker
  DateTime selectedDate = DateTime.now();
  DateTime now = DateTime.now();

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
        child: BlocListener<UpdateGroupCubit, UpdateGroupState>(
          listener: (context, state) {
            if (state.status == UpdateGroupStatus.loading) {
              context.loaderOverlay.show();
            } else if (state.status == UpdateGroupStatus.success) {
              context.loaderOverlay.hide();
              CustomSnackbar.awesome(context,
                  message: state.message ?? '', type: ContentType.success);
              context
                  .read<GroupBloc>()
                  .add(const GroupFetched(isRefresh: true));
            } else {
              context.loaderOverlay.hide();
              CustomSnackbar.awesome(context,
                  message: state.message ?? '', type: ContentType.failure);
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
                  elevation: 0,
                  backgroundColor: Colors.blue[700],
                  actions: [
                    BlocBuilder<GroupBloc, GroupState>(
                      builder: (context, stateGroup) {
                        if (stateGroup.groups.isNotEmpty) {
                          return BlocBuilder<SelectedGroupCubit,
                              SelectedGroupState>(
                            builder: (context, state) {
                              return Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (builder) {
                                          return SettingScreen(
                                            group: stateGroup
                                                .groups[state.selectedIndex],
                                          );
                                        }));
                                      },
                                      icon: const Icon(Icons.settings)),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (builder) {
                                          return MemberScreen(
                                            group: stateGroup
                                                .groups[state.selectedIndex],
                                          );
                                        }));
                                      },
                                      icon: const Icon(Icons.person_add))
                                ],
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                  title: const Text('Arisan Digital')),
              SliverList(
                  delegate: SliverChildListDelegate([
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
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
                              return const CreateGroupScreen();
                            }));
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.only(left: 15, top: 5),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 7,
                                      offset: const Offset(1, 3),
                                    )
                                  ],
                                  color: Colors.blue[700]),
                              child: const Icon(
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
                                      'Tambahkan group arisan baru!',
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
                    BlocBuilder<GroupBloc, GroupState>(
                      builder: (context, stateGroup) {
                        if (stateGroup.groups.isEmpty) {
                          return Container();
                        }
                        return BlocBuilder<SelectedGroupCubit,
                            SelectedGroupState>(
                          builder: (context, state) {
                            GroupModel group =
                                stateGroup.groups[state.selectedIndex];
                            return Container(
                              margin: const EdgeInsets.only(
                                  top: 55, left: 15, right: 15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Saldo Arisan',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Rp ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            state.isShowBalance
                                                ? currencyId
                                                    .format(group.totalBalance)
                                                : '**********',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          GestureDetector(
                                            onTap: () => context
                                                .read<SelectedGroupCubit>()
                                                .showBalance(),
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Icon(state.isShowBalance
                                                    ? Icons.visibility
                                                    : Icons.visibility_off)),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                                  GestureDetector(
                                    onTap: () =>
                                        _qrCodeDialog(group.code ?? ''),
                                    child: SizedBox(
                                        width: 50,
                                        child: Image.network(
                                            "https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=${group.code}&choe=UTF-8")),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              ])),
              BlocBuilder<GroupBloc, GroupState>(
                builder: (context, stateGroup) {
                  if (stateGroup.groups.isEmpty) {
                    return SliverList(delegate: SliverChildListDelegate([]));
                  }
                  return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
                    builder: (context, state) {
                      GroupModel group = stateGroup.groups[state.selectedIndex];
                      if ((group.lastPaidMembers ?? []).isEmpty) {
                        return SliverList(
                            delegate: SliverChildListDelegate([]));
                      }
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Expanded(
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
                                        return MemberScreen(
                                          group: group,
                                        );
                                      }));
                                    },
                                    child: Row(
                                      children: const [
                                        Text('Lihat Semua'),
                                        Icon(Icons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              for (MemberModel item
                                  in (group.lastPaidMembers ?? []))
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 40,
                                          child: Image.asset(
                                              "assets/images/icons/man.png")),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child: Text(
                                        item.name ?? '',
                                        style: const TextStyle(fontSize: 13),
                                      )),
                                      Text(
                                        "Rp${currencyId.format(group.dues ?? 0)}",
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      ]));
                    },
                  );
                },
              ),
              BlocBuilder<GroupBloc, GroupState>(
                builder: (context, stateGroup) {
                  if (stateGroup.groups.isEmpty) {
                    return SliverList(delegate: SliverChildListDelegate([]));
                  }
                  return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
                    builder: (context, state) {
                      GroupModel group = stateGroup.groups[state.selectedIndex];
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
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
                                    'Belum Setor',
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
                                      const Text(
                                        'Rp ',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        '-${currencyId.format(group.totalNotDues)}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.red)),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.mail,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Tagih',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ]));
                    },
                  );
                },
              ),
              BlocBuilder<GroupBloc, GroupState>(
                builder: (context, stateGroup) {
                  if (stateGroup.groups.isEmpty) {
                    return SliverList(delegate: SliverChildListDelegate([]));
                  }
                  return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
                    builder: (context, state) {
                      GroupModel group = stateGroup.groups[state.selectedIndex];
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            group.periodsDateEn ?? '',
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
                                  GestureDetector(
                                    onTap: () => _selectDate(context, group),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 5),
                                      child: const Icon(
                                        Icons.edit_calendar,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
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
                                              color:
                                                  Colors.lightBlue.shade800)),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return HistoryScreen(
                                          group: group,
                                        );
                                      }));
                                    },
                                    child: const Text('Lihat Riwayat')),
                              )
                            ],
                          ),
                        ),
                      ]));
                    },
                  );
                },
              ),
              BlocBuilder<GroupBloc, GroupState>(
                builder: (context, stateGroup) {
                  if (stateGroup.groups.isEmpty) {
                    return SliverList(delegate: SliverChildListDelegate([]));
                  }
                  return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
                    builder: (context, state) {
                      GroupModel group = stateGroup.groups[state.selectedIndex];
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          group.notes ??
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
                              GestureDetector(
                                onTap: () => _editNotesModal(context, group),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 5),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]));
                    },
                  );
                },
              ),
              BlocBuilder<GroupBloc, GroupState>(
                builder: (context, stateGroup) {
                  if (stateGroup.groups.isEmpty) {
                    return SliverList(delegate: SliverChildListDelegate([]));
                  }
                  return BlocBuilder<SelectedGroupCubit, SelectedGroupState>(
                    builder: (context, state) {
                      GroupModel group = stateGroup.groups[state.selectedIndex];
                      return SliverList(
                          delegate: SliverChildListDelegate([
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 15, right: 15),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: group.isShuffle!
                                    ? null
                                    : Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                if (group.isShuffle!) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (builder) {
                                    return ShuffleScreen(
                                      members: stateGroup
                                          .groups[state.selectedIndex].members,
                                      group: stateGroup
                                          .groups[state.selectedIndex],
                                    );
                                  }));
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Mohon pastikan semua status member sudah diupdate!');
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text('Kocok Arisan Sekarang!'),
                              )),
                        )
                      ]));
                    },
                  );
                },
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 50,
                )
              ])),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _editNotesModal(BuildContext context, GroupModel group) {
    TextEditingController notesController = TextEditingController();
    notesController.text = group.notes ?? '';
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Edit Info Group',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Ubah info group arisan.',
                  style: TextStyle(fontSize: 14),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: TextField(
                      controller: notesController,
                      maxLines: 2,
                      minLines: 1,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: "Info"),
                    )),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Simpan'),
                    onPressed: () {
                      Navigator.pop(context);
                      context
                          .read<UpdateGroupCubit>()
                          .updateNoteGroup(group.id!, notesController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, GroupModel group) async {
    final DateFormat format = DateFormat("yyyy-MM-dd");
    selectedDate = format.parse(group.periodsDate!);
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue.shade700,
              ),
            ),
            child: child!,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime((now.year - 100), 8),
        lastDate: DateTime(now.year + 1));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      String date =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year.toString().padLeft(2, '0')}';
      // ignore: use_build_context_synchronously
      context.read<UpdateGroupCubit>().updateDateGroup(group.id!, date);
    }
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
}
