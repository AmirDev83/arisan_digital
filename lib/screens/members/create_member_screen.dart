import 'package:flutter/material.dart';

class CreateMemberScreen extends StatefulWidget {
  const CreateMemberScreen({Key? key}) : super(key: key);

  @override
  State<CreateMemberScreen> createState() => _CreateMemberScreenState();
}

class _CreateMemberScreenState extends State<CreateMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anggota'),
      ),
    );
  }
}
