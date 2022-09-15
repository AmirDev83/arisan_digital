import 'package:arisan_digital/blocs/auth_bloc/auth_bloc.dart';
import 'package:arisan_digital/blocs/groups/delete_group_cubit/delete_group_cubit.dart';
import 'package:arisan_digital/blocs/home/group_bloc/group_bloc.dart';
import 'package:arisan_digital/blocs/home/selected_group_cubit/selected_group_cubit.dart';
import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/screens/settings/about_screen.dart';
import 'package:arisan_digital/screens/starting_screen.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  final GroupModel? group;
  const SettingScreen({Key? key, this.group}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  GroupModel? group;

  Future<void> _launchUrl(String url) async {
    Uri urlParse = Uri.parse(url);
    if (!await launchUrl(urlParse)) {
      throw 'Could not launch $urlParse';
    }
  }

  @override
  void initState() {
    context.read<AuthBloc>().add(AuthUserFetched());
    group = widget.group;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              context.loaderOverlay.show();
            } else if (state is AuthLogout) {
              context.loaderOverlay.hide();
              if (state.authStatus == AuthStatus.unauthenticated) {
                context.read<SelectedGroupCubit>().setSelectedIndex(0);
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const StartingScreen()),
                  ModalRoute.withName('/starting-screen'),
                );
              }
            } else {
              context.loaderOverlay.hide();
            }
          },
        ),
        BlocListener<DeleteGroupCubit, DeleteGroupState>(
            listener: (context, state) {
          if (state.status == DeleteGroupStatus.loading) {
            context.loaderOverlay.show();
          } else if (state.status == DeleteGroupStatus.success) {
            context.loaderOverlay.hide();
            CustomSnackbar.awesome(context,
                message: state.message ?? '', type: ContentType.success);
            context.read<GroupBloc>().add(const GroupFetched(isRefresh: true));
            context.read<SelectedGroupCubit>().setSelectedIndex(0);
            Navigator.pop(context);
          } else {
            context.loaderOverlay.hide();
          }
        }),
      ],
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.blue.shade700,
        overlayOpacity: 1,
        overlayWidget: Center(
          child: LoadingAnimationWidget.waveDots(
            color: Colors.white,
            size: 70,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
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
                    title: const Text('Pengaturan')),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthUser) {
                            if (state.authStatus == AuthStatus.authenticated) {
                              return ListTile(
                                leading: CircleAvatar(
                                  child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: ClipOval(
                                        child: Image.network(
                                          state.user?.photoUrl ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                ),
                                title: Text(state.user?.name ?? ''),
                                subtitle: Text(state.user?.email ?? ''),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      ListTile(
                        onTap: () => _showDeleteDialog(context),
                        leading: Icon(
                          Icons.delete_outline,
                          color: Colors.blue.shade700,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        title: Text('Hapus group : ${group!.name}'),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                            return const AboutScreen();
                          }));
                        },
                        leading: Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        title: const Text('Tentang Aplikasi'),
                      ),
                      ListTile(
                        onTap: () =>
                            _launchUrl('https://bit.ly/arisan-digital'),
                        leading: Icon(
                          Icons.comment_outlined,
                          color: Colors.blue.shade700,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        title: const Text('Kritik dan Saran'),
                      ),
                      ListTile(
                        onTap: () => _launchUrl(
                            'https://play.google.com/store/apps/details?id=com.caraguna.arisan.digital'),
                        leading: Icon(
                          Icons.star_outline,
                          color: Colors.blue.shade700,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        title: const Text('Review Aplikasi'),
                      ),
                      ListTile(
                        onTap: () => _showLogoutDialog(context),
                        trailing: const Icon(Icons.chevron_right),
                        leading: Icon(
                          Icons.logout_outlined,
                          color: Colors.blue.shade700,
                        ),
                        title: const Text('Keluar'),
                      ),
                    ],
                  )
                ])),
                SliverList(delegate: SliverChildListDelegate([])),
              ]),
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Keluar Aplikasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Apakah kamu yakin ingin keluar dari aplikasi?'),
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
              child:
                  const Text('Keluar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthOnLogout());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Hapus',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah kamu yakin ingin menghapus group ${group!.name}?'),
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
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<DeleteGroupCubit>().deleteGroup(group!.id!);
              },
            ),
          ],
        );
      },
    );
  }
}
