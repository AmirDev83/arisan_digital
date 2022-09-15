import 'package:arisan_digital/screens/guests/guest_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class InitialGuestScreen extends StatefulWidget {
  const InitialGuestScreen({Key? key}) : super(key: key);

  @override
  State<InitialGuestScreen> createState() => _InitialGuestScreenState();
}

class _InitialGuestScreenState extends State<InitialGuestScreen> {
  final TextEditingController _codeController = TextEditingController();

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
                      'Masuk Lewat Mana?',
                      style: TextStyle(
                          color: Colors.lightBlue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Pilih lewat scan QRCode atau masukkan kode group kamu.',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.lightBlue.shade900,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        color: Colors.lightBlue.shade900)),
                              ),
                              onPressed: () async {
                                String? cameraScanResult = await scanner.scan();
                                Fluttertoast.showToast(
                                    msg: cameraScanResult ?? 'Failed');
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        width: 25, child: Icon(Icons.qr_code)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'QR Code',
                                      style: TextStyle(
                                          color: Colors.lightBlue.shade900,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.lightBlue.shade900,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: BorderSide(
                                        color: Colors.lightBlue.shade900)),
                              ),
                              onPressed: () => _enterCodeModal(context),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                        width: 25,
                                        child: Icon(Icons.keyboard_outlined)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Ketik Kode',
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
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _enterCodeModal(BuildContext context) {
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
                  'Kode Group',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Text(
                  'Masukkan kode group kamu yang terdaftar.',
                  style: TextStyle(fontSize: 14),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: "Kode Group"),
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
                    child: const Text('Masuk'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) {
                        return const GuestHomeScreen();
                      }));
                      // context
                      //     .read<UpdateGroupCubit>()
                      //     .updateNoteGroup(group.id!, notesController.text);
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
}
