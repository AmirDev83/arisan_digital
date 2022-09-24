import 'package:arisan_digital/models/group_model.dart';
import 'package:arisan_digital/models/response_model.dart';
import 'package:arisan_digital/repositories/group_repository.dart';
import 'package:arisan_digital/utils/currency_format.dart';
import 'package:arisan_digital/utils/custom_snackbar.dart';
import 'package:arisan_digital/utils/loading_overlay.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

class UpdateGroupScreen extends StatefulWidget {
  final GroupModel? group;
  const UpdateGroupScreen({Key? key, this.group}) : super(key: key);

  @override
  State<UpdateGroupScreen> createState() => _UpdateGroupScreenState();
}

class _UpdateGroupScreenState extends State<UpdateGroupScreen> {
  final GroupRepository _groupRepo = GroupRepository();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _duesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String dropdownValue = 'Mingguan';

  final _formKey = GlobalKey<FormState>();

  // Date Picker
  DateTime selectedDate = DateTime.now();
  DateTime now = DateTime.now();

  Future _updateGroup() async {
    LoadingOverlay.show(context);
    if (!_formKey.currentState!.validate()) return null;
    ResponseModel? response = await _groupRepo.updateGroup(GroupModel(
        id: widget.group!.id,
        name: _groupNameController.text,
        periodsType: dropdownValue,
        periodsDate: _dateController.text,
        dues: int.parse(CurrencyFormat.toNumber(
            _duesController.text != '' ? _duesController.text : '0'))));

    if (response != null) {
      if (response.status == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message ?? '', type: ContentType.success);
      } else {
        // ignore: use_build_context_synchronously
        CustomSnackbar.awesome(context,
            message: response.message ?? '', type: ContentType.failure);
      }
    } else {
      // ignore: use_build_context_synchronously
      CustomSnackbar.awesome(context,
          message: 'Terjadi kesalahan, silahkan coba kembali!',
          type: ContentType.failure);
    }

    if (mounted) LoadingOverlay.hide(context);
  }

  @override
  void initState() {
    _groupNameController.text = widget.group!.name ?? '';
    _duesController.text = currencyId.format(widget.group!.dues ?? '');
    _dateController.text = widget.group!.periodsDate ?? '';
    dropdownValue = widget.group!.periodsType == 'weekly'
        ? 'Mingguan'
        : widget.group!.periodsType == 'monthly'
            ? 'Bulanan'
            : 'Tahunan';
    final DateFormat format = DateFormat("yyyy-MM-dd");
    selectedDate = format.parse(_dateController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Group'),
          iconTheme: IconThemeData(color: Colors.grey.shade300),
          titleTextStyle: TextStyle(
              color: Colors.lightBlue.shade800, fontWeight: FontWeight.w500),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.82,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Group Arisan!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.lightBlue.shade900),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Ubah detail group arisan yang kamu kelola sekarang.",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset("assets/images/world-group.png"),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama group tidak boleh kosong.';
                          }
                          return null;
                        },
                        controller: _groupNameController,
                        decoration: const InputDecoration(
                            // label: Text('Nama Group'),
                            helperText: "* Contoh: kantor, komplek, dll.",
                            labelText: "Nama Group"),
                      )),
                  Container(
                      margin:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nominal iuran tidak boleh kosong.';
                                }
                                return null;
                              },
                              controller: _duesController,
                              inputFormatters: [
                                ThousandsFormatter(
                                    allowFraction: false,
                                    formatter:
                                        NumberFormat.decimalPattern('en'))
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: "Nominal Iuran"),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Tanggal arisan tidak boleh kosong.';
                                  }
                                  return null;
                                },
                                enabled: false,
                                controller: _dateController,
                                decoration: const InputDecoration(
                                    labelText: "Tanggal Mulai"),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Icon(Icons.arrow_drop_down),
                      ),
                      elevation: 16,
                      isExpanded: true,
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 16),
                      underline: Container(
                        height: 1,
                        color: Colors.grey.shade500,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Mingguan', 'Bulanan', 'Tahunan']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
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
                        onPressed: () => _updateGroup(),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Update Group'),
                        )),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
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
    if (picked != null && picked != selectedDate) selectedDate = picked;
    _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
    setState(() {});
  }
}
