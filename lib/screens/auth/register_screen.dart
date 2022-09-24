import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/auth_repository.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:arisan_digital/utils/loading_overlay.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthRepository _authRepo = AuthRepository();
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future _register() async {
    if (!_formKey.currentState!.validate()) return null;
    LoadingOverlay.show(context);
    try {
      ResponseModel? response = await _authRepo.register(
          email: _emailController.text,
          name: _nameController.text,
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmationController.text);
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
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message, type: ContentType.success);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (mounted) LoadingOverlay.hide(context);
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
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register',
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
                  'Nama',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: 'Nama...'),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 5),
                child: Text(
                  'Email',
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
                obscureText: isObscurePassword,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(isObscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscurePassword = !isObscurePassword;
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
              Container(
                margin: const EdgeInsets.only(bottom: 5, left: 5),
                child: Text(
                  'Konfirmasi Password',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800),
                ),
              ),
              TextFormField(
                controller: _passwordConfirmationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong.';
                  }
                  return null;
                },
                obscureText: isObscureConfirmPassword,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(isObscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscureConfirmPassword = !isObscureConfirmPassword;
                        });
                      },
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: 'Konfirmasi Password...'),
              ),
              const SizedBox(
                height: 30,
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
                          onPressed: () => _register(),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
