import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/auth_repository.dart';
import 'package:arisan_digital/screens/auth/register_screen.dart';
import 'package:arisan_digital/screens/home/home_screen.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:arisan_digital/utils/loading_overlay.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailResetPasswordController =
      TextEditingController();
  final TextEditingController _emailResendVerificationController =
      TextEditingController();

  bool isObscure = true;

  final _formLoginKey = GlobalKey<FormState>();

  Future _loginManual() async {
    if (!_formLoginKey.currentState!.validate()) return null;
    LoadingOverlay.show(context);
    try {
      ResponseModel? response = await _authRepo.loginManual(
          email: _emailController.text, password: _passwordController.text);
      if (response == null) {
        return;
      }

      if (response.status == 'unverified') {
        _resendVerificationModal(_emailController.text,
            message: response.message);
      }

      if (response.status == 'failed') {
        Fluttertoast.showToast(msg: response.message ?? '');
      }

      if (response.status == 'success') {
        if (mounted) {
          LoadingOverlay.hide(context);
        }
        routeHomeScreen();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (mounted) {
      LoadingOverlay.hide(context);
    }
  }

  Future _resetPassword() async {
    LoadingOverlay.show(context);
    try {
      ResponseModel? response = await _authRepo.resetPassword(
          email: _emailResetPasswordController.text);
      if (response == null) {
        return;
      }

      if (response.status == 'failed') {
        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message, type: ContentType.failure);
      }

      if (response.status == 'success') {
        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message, type: ContentType.success);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (mounted) {
      LoadingOverlay.hide(context);
    }
  }

  Future _resendVerification() async {
    if (!_formLoginKey.currentState!.validate()) return null;
    LoadingOverlay.show(context);
    try {
      ResponseModel? response = await _authRepo.resendVerification(
          email: _emailResendVerificationController.text);
      if (response == null) {
        return;
      }

      if (response.status == 'failed') {
        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message, type: ContentType.failure);
      }

      if (response.status == 'success') {
        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message, type: ContentType.success);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (mounted) {
      LoadingOverlay.hide(context);
    }
  }

  // Google Sign In
  Future<void> _handleSignIn() async {
    LoadingOverlay.show(context);
    try {
      _currentUser = await _googleSignIn.signIn();

      if (_currentUser != null) {
        String? token = await _authRepo.login(
            email: _currentUser?.email,
            name: _currentUser?.displayName,
            photoUrl: _currentUser?.photoUrl,
            googleId: _currentUser?.id);
        if (token != null) {
          // ignore: use_build_context_synchronously
          LoadingOverlay.hide(context);
          routeHomeScreen();
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    if (mounted) {
      LoadingOverlay.hide(context);
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
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
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
      body: Form(
        key: _formLoginKey,
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
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
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
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong.';
                  }
                  return null;
                },
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
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
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
                          onPressed: () => _loginManual(),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: GestureDetector(
                    onTap: () => _resetPasswordModal(),
                    child: Center(
                      child: Text(
                        'Lupa Password? Reset Disini.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPasswordModal() {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      'Reset Password',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const Text(
                      'Masukkan email yang ingin kamu reset passwordnya.',
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: TextField(
                          controller: _emailResetPasswordController,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(fontSize: 14),
                              labelText: "Email"),
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
                        child: const Text('Submit'),
                        onPressed: () async {
                          if (_emailResetPasswordController.text != '') {
                            Navigator.pop(context);
                            await _resetPassword();
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Email tidak boleh kosong');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _resendVerificationModal(String email, {String? message}) {
    _emailResendVerificationController.text = email;
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      'Verifikasi Email',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    message != null
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              message,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          )
                        : Container(),
                    const Text(
                      'Masukkan email yang ingin diverifikasi ulang.',
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: TextField(
                          controller: _emailResendVerificationController,
                          decoration: const InputDecoration(
                              labelStyle: TextStyle(fontSize: 14),
                              labelText: "Email"),
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
                        child: const Text('Submit'),
                        onPressed: () async {
                          if (_emailResendVerificationController.text != '') {
                            Navigator.pop(context);
                            await _resendVerification();
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Email tidak boleh kosong');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
