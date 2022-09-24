import 'package:arisan_digital/repositories/auth_repository.dart';
import 'package:arisan_digital/screens/auth/register_screen.dart';
import 'package:arisan_digital/screens/home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? _currentUser;
  final AuthRepository _authRepo = AuthRepository();

  bool isObscure = true;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  Future<void> _handleSignIn() async {
    context.loaderOverlay.show();
    try {
      _currentUser = await _googleSignIn.signIn();

      if (_currentUser != null) {
        String? token = await _authRepo.login(
            email: _currentUser?.email,
            name: _currentUser?.displayName,
            photoUrl: _currentUser?.photoUrl,
            googleId: _currentUser?.id);
        if (token != null) {
          context.loaderOverlay.hide();
          routeHomeScreen();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    if (mounted) {
      context.loaderOverlay.hide();
    }
  }

  void routeHomeScreen() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeScreen()),
      ModalRoute.withName('/home-screen'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: LoadingAnimationWidget.waveDots(
            color: Colors.white,
            size: 70,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Login 😉',
                style: TextStyle(
                    color: Colors.lightBlue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Masukkan data akun kamu dibawah ini.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 5),
                child: Text(
                  'Email atau Username',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Email...'),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 5),
                child: Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ),
              TextFormField(
                obscureText: isObscure,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    hintText: 'Password...'),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  width: 2, color: Colors.blue.shade500),
                              shape: const StadiumBorder()),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (builder) {
                              return const RegisterScreen();
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade500),
                            ),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          onPressed: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Center(child: Text('Atau')),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.lightBlue.shade900,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.lightBlue.shade900)),
                  ),
                  onPressed: () {
                    _handleSignIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 25,
                            child:
                                Image.asset('assets/images/icons/google.png')),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sign in by Google',
                          style: TextStyle(
                              color: Colors.lightBlue.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
