import 'package:arisan_digital/blocs/home/group_bloc/group_bloc.dart';
import 'package:arisan_digital/blocs/member_cubit/member_cubit.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/models/member_model.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberScreen extends StatefulWidget {
  final GroupModel? group;
  const MemberScreen({Key? key, this.group}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  final _formKeyCreate = GlobalKey<FormState>();
  final _formKeyUpdate = GlobalKey<FormState>();

  Future<void> _launchUrl(String url) async {
    Uri urlParse = Uri.parse(url);
    if (!await launchUrl(urlParse)) {
      throw 'Could not launch $urlParse';
    }
  }

  @override
  void initState() {
    context.read<MemberCubit>().getMembers(widget.group!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemberCubit, MemberState>(
      listener: (context, state) {
        if (state is MemberSuccessState) {
          _nameController.text = '';
          _emailController.text = '';
          _noTelpController.text = '';
          CustomSnackbar.awesome(context,
              message: state.message, type: ContentType.success);
          context.read<MemberCubit>().getMembers(widget.group!.id!);
          context.read<GroupBloc>().add(const GroupFetched(isRefresh: true));
        }

        if (state is MemberDataState) {
          if (state.memberStatus == MemberStatus.failure) {
            CustomSnackbar.awesome(context,
                message: state.message ?? '', type: ContentType.failure);
            context.read<MemberCubit>().getMembers(widget.group!.id!);
          }
        }
      },
      child: Scaffold(
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
                IconButton(
                    onPressed: () {
                      _createMemberModal(context);
                    },
                    icon: const Icon(Icons.add)),
              ],
              title: const Text('Anggota')),
          SliverList(
              delegate: SliverChildListDelegate([
            BlocBuilder<MemberCubit, MemberState>(
              builder: (context, state) {
                if (state is MemberDataState) {
                  if (state.memberStatus == MemberStatus.success) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        itemCount: state.listMembers!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () =>
                                _detailMemberDialog(state.listMembers![index]),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: state.listMembers![index].statusActive ==
                                      'inactive'
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5)
                                  : null,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      state.listMembers![index].statusActive ==
                                              'inactive'
                                          ? BorderRadius.circular(10)
                                          : null,
                                  color:
                                      state.listMembers![index].statusActive ==
                                              'inactive'
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
                                      state.listMembers![index].isGetReward!
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
                                            state.listMembers![index].name ??
                                                '',
                                            style: TextStyle(
                                                color: state.listMembers![index]
                                                            .statusActive ==
                                                        'inactive'
                                                    ? Colors.white
                                                    : null)),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          state.listMembers![index].noTelp ??
                                              (state.listMembers![index]
                                                      .email ??
                                                  ''),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  state.listMembers![index].statusPaid !=
                                          'unpaid'
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: state.listMembers![index]
                                                        .statusPaid ==
                                                    'paid'
                                                ? Colors.green.shade400
                                                : state.listMembers![index]
                                                            .statusPaid ==
                                                        'cancel'
                                                    ? Colors.red.shade400
                                                    : Colors.blue.shade400,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(state.listMembers![index]
                                                      .statusPaid ==
                                                  'paid'
                                              ? 'Sudah Bayar'
                                              : state.listMembers![index]
                                                          .statusPaid ==
                                                      'cancel'
                                                  ? 'Batal'
                                                  : 'Lewati'))
                                      : Container()
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
                    ),
                  );
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()),
                  ),
                );
              },
            )
          ])),
          SliverList(delegate: SliverChildListDelegate([])),
        ]),
      ),
    );
  }

  Future<void> _detailMemberDialog(MemberModel member) async {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  leading: SizedBox(
                      width: 40,
                      child: Image.asset("assets/images/icons/man.png")),
                  title: Text(member.name ?? ''),
                  subtitle: Text(member.email ?? (member.noTelp ?? '')),
                  trailing: GestureDetector(
                    onTap: () =>
                        _launchUrl('https://wa.me/${member.noWhatsapp}'),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/images/icons/whatsapp.png'),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTile(
                  onTap: () => _statusActiveMemberDialog(member),
                  contentPadding: EdgeInsets.zero,
                  trailing: const Icon(Icons.chevron_right),
                  title: const Text('Status anggota'),
                  subtitle: Text(member.statusActive == 'active'
                      ? 'Aktif'
                      : 'Tidak Aktif'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListTile(
                  onTap: () => _statusPaidMemberDialog(member),
                  contentPadding: EdgeInsets.zero,
                  trailing: const Icon(Icons.chevron_right),
                  title: const Text('Status pembayaran'),
                  subtitle: Text(member.statusPaid == 'paid'
                      ? 'Sudah Bayar'
                      : member.statusPaid == 'unpaid'
                          ? 'Belum Bayar'
                          : member.statusPaid == 'skip'
                              ? 'Lewati'
                              : 'Batal'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: member.canDelete!
                              ? Colors.red.shade400
                              : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Hapus'),
                        onPressed: () {
                          if (member.canDelete!) {
                            Navigator.pop(context);
                            _deleteConfirmationDialog(
                                member.id!, member.name ?? '');
                          }
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
                          child: const Text('Edit'),
                          onPressed: () {
                            Navigator.pop(context);
                            _updateMemberModal(context, member);
                          }),
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

  Future<void> _statusActiveMemberDialog(MemberModel member) async {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text('Ubah Status Anggota'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Inactive'),
                        onPressed: () {
                          if (member.statusActive == 'inactive') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<MemberCubit>().updateStatusActive(
                                MemberModel(
                                    id: member.id, statusActive: 'inactive'));
                          }
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
                        child: const Text('Active'),
                        onPressed: () {
                          if (member.statusActive == 'active') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<MemberCubit>().updateStatusActive(
                                MemberModel(
                                    id: member.id, statusActive: 'active'));
                          }
                        },
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

  Future<void> _statusPaidMemberDialog(MemberModel member) async {
    final DateTime now = DateTime.now();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text('Ubah Status Pembayaran'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Lewati'),
                        onPressed: () {
                          if (member.statusPaid == 'skip') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<MemberCubit>().updateStatusPaid(
                                MemberModel(
                                    id: member.id,
                                    statusPaid: 'skip',
                                    nominalPaid: null,
                                    datePaid:
                                        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}'));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Batalkan'),
                        onPressed: () {
                          if (member.statusPaid == 'cancel') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<MemberCubit>().updateStatusPaid(
                                MemberModel(
                                    id: member.id,
                                    statusPaid: 'cancel',
                                    nominalPaid: null,
                                    datePaid:
                                        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
                        child: const Text('Belum Bayar'),
                        onPressed: () {
                          if (member.statusPaid == 'unpaid') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<MemberCubit>().updateStatusPaid(
                                MemberModel(
                                    id: member.id,
                                    statusPaid: 'unpaid',
                                    nominalPaid: null,
                                    datePaid: null));
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Sudah Bayar'),
                        onPressed: () {
                          if (member.statusPaid == 'paid') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<MemberCubit>().updateStatusPaid(
                                MemberModel(
                                    id: member.id,
                                    statusPaid: 'paid',
                                    nominalPaid: null,
                                    datePaid:
                                        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}'));
                          }
                        },
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

  Future<void> _deleteConfirmationDialog(int id, String name) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apakah kamu yakin ingin menghapus $name'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya, hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<MemberCubit>().deleteMember(id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createMemberModal(BuildContext context) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKeyCreate,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Tambah Anggota',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Masukkan data anggota arisan.',
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama anggota tidak boleh kosong.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "Nama Anggota"),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                helperText:
                                    "* Notifikasi akan dikirimkan melalui email.",
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "Email (Opsional)"),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: _noTelpController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No telp tidak boleh kosong.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "No Telp (Whatsapp)"),
                          )),
                      const SizedBox(
                        height: 25,
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
                            if (_formKeyCreate.currentState!.validate()) {
                              Navigator.pop(context);
                              context.read<MemberCubit>().createMember(
                                  MemberModel(
                                      group: widget.group,
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      noTelp: _noTelpController.text));
                            }
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (builder) {
                            //   return ContactScreen();
                            // }));
                          },
                        ),
                      ),
                      // Container(
                      //     margin: EdgeInsets.symmetric(vertical: 15),
                      //     child: Center(child: const Text('Atau'))),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.white,
                      //       onPrimary: Colors.lightBlue[700],
                      //       shadowColor: Colors.transparent,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(20.0),
                      //           side: BorderSide(color: Colors.lightBlue.shade800)),
                      //     ),
                      //     child: const Text('Tambahkan dari Contact'),
                      //     onPressed: () {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (builder) {
                      //         return ContactScreen();
                      //       }));
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateMemberModal(BuildContext context, MemberModel member) {
    final TextEditingController nameEditController = TextEditingController();
    final TextEditingController emailEditController = TextEditingController();
    final TextEditingController noTelpEditController = TextEditingController();

    nameEditController.text = member.name ?? '';
    emailEditController.text = member.email ?? '';
    noTelpEditController.text = member.noTelp ?? '';
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKeyUpdate,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Wrap(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Update Anggota',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Masukkan data anggota arisan.',
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: nameEditController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama anggota tidak boleh kosong.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "Nama Anggota"),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: emailEditController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                helperText:
                                    "* Notifikasi akan dikirimkan melalui email.",
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "Email (Opsional)"),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: TextFormField(
                            controller: noTelpEditController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No telp tidak boleh kosong.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelStyle: TextStyle(fontSize: 14),
                                labelText: "No Telp (Whatsapp)"),
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        // margin: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('Simpan'),
                          onPressed: () {
                            if (_formKeyUpdate.currentState!.validate()) {
                              Navigator.pop(context);
                              context.read<MemberCubit>().updateMember(
                                  MemberModel(
                                      id: member.id!,
                                      group: widget.group,
                                      name: nameEditController.text,
                                      email: emailEditController.text,
                                      noTelp: noTelpEditController.text));
                            }
                          },
                        ),
                      ),
                      // Container(
                      //     margin: EdgeInsets.symmetric(vertical: 15),
                      //     child: Center(child: const Text('Atau'))),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.white,
                      //       onPrimary: Colors.lightBlue[700],
                      //       shadowColor: Colors.transparent,
                      //       shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(20.0),
                      //           side: BorderSide(color: Colors.lightBlue.shade800)),
                      //     ),
                      //     child: const Text('Tambahkan dari Contact'),
                      //     onPressed: () {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (builder) {
                      //         return ContactScreen();
                      //       }));
                      //     },
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
