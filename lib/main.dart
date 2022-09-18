import 'dart:io';

import 'package:arisan_digital/blocs/arisan_history_cubit/arisan_history_cubit.dart';
import 'package:arisan_digital/blocs/auth_bloc/auth_bloc.dart';
import 'package:arisan_digital/blocs/contact_cubit/contact_cubit.dart';
import 'package:arisan_digital/blocs/groups/create_group_cubit/create_group_cubit.dart';
import 'package:arisan_digital/blocs/groups/delete_group_cubit/delete_group_cubit.dart';
import 'package:arisan_digital/blocs/groups/update_group_cubit/update_group_cubit.dart';
import 'package:arisan_digital/blocs/guest/guest_group_cubit/guest_group_cubit.dart';
import 'package:arisan_digital/blocs/home/group_bloc/group_bloc.dart';
import 'package:arisan_digital/blocs/home/selected_group_cubit/selected_group_cubit.dart';
import 'package:arisan_digital/blocs/member_cubit/member_cubit.dart';
import 'package:arisan_digital/blocs/shuffle_cubit/shuffle_cubit.dart';
import 'package:arisan_digital/screens/onboarding_screen.dart';
import 'package:arisan_digital/screens/starting_screen.dart';
import 'package:arisan_digital/utils/http_overrides.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

int introduction = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Ads init
  MobileAds.instance.initialize();

  // Inisial http method untuk Android versi 6 atau kebawah
  HttpOverrides.global = MyHttpOverrides();

  await dotenv.load(fileName: ".env");

  await initIntroduction();

  runApp(const MyApp());
}

Future initIntroduction() async {
  final prefs = await SharedPreferences.getInstance();
  int? intro = prefs.getInt('introduction');
  if (kDebugMode) {
    print('intro = $intro');
  }

  if (intro != null && intro == 1) {
    return introduction = 1;
  }
  prefs.setInt('introduction', 1);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GroupBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => CreateGroupCubit(),
        ),
        BlocProvider(
          create: (context) => SelectedGroupCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteGroupCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateGroupCubit(),
        ),
        BlocProvider(
          create: (context) => ContactCubit(),
        ),
        BlocProvider(
          create: (context) => MemberCubit(),
        ),
        BlocProvider(
          create: (context) => ShuffleCubit(),
        ),
        BlocProvider(
          create: (context) => ArisanHistoryCubit(),
        ),
        BlocProvider(
          create: (context) => GuestGroupCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Arisan Digital',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: UpgradeAlert(
            upgrader: Upgrader(
                showReleaseNotes: false, showIgnore: false, showLater: false),
            child: introduction == 0
                ? const OnboardingScreen()
                : const StartingScreen()),
      ),
    );
  }
}
