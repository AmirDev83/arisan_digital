import 'package:arisan_digital/blocs/auth_bloc/auth_bloc.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:arisan_digital/screens/auth/login_screen.dart';
import 'package:arisan_digital/screens/guests/guest_home_screen.dart';
import 'package:arisan_digital/screens/guests/initial_guest_screen.dart';
import 'package:arisan_digital/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  final GroupRepository _groupRepo = GroupRepository();
  void routeHomeScreen() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeScreen()),
      ModalRoute.withName('/home-screen'),
    );
  }

  void routeGuestGroupScreen(String code) {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => GuestHomeScreen(
                code: code,
              )),
      ModalRoute.withName('/guest-group-screen'),
    );
  }

  Future getGroupCode() async {
    String? code = await _groupRepo.getGroupCode();
    if (code != null) {
      routeGuestGroupScreen(code);
    }
  }

  @override
  void initState() {
    context.read<AuthBloc>().add(AuthUserFetched());

    getGroupCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            context.loaderOverlay.show();
          } else if (state is AuthUser) {
            context.loaderOverlay.hide();
            if (state.authStatus == AuthStatus.authenticated) {
              routeHomeScreen();
            }
          } else {
            context.loaderOverlay.hide();
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello 👋',
                        style: TextStyle(
                            color: Colors.lightBlue[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      const Text(
                        'Arisan Digital',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Kocok arisan jadi lebih mudah dan cepat.',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Atur anggota arisan ngga ribet.',
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue[700],
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return const LoginScreen();
                            }));
                          },
                          child: const Text('Pengelola'),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.lightBlue[700],
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(color: Colors.grey)),
                              elevation: 0.5),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return const InitialGuestScreen();
                            }));
                          },
                          child: Text(
                            'Peserta',
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
