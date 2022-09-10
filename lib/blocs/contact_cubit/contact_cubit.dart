// import 'package:arisan_digital/models/contact_model.dart';
import 'package:arisan_digital/repositories/contact_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(const ContactDataState());

  final ContactRepository _contactRepo = ContactRepository();

  Future<void> getContacts() async {
    emit(const ContactDataState()
        .copyWith(contactStatus: ContactStatus.loading));

    try {
      List<Contact>? data = await _contactRepo.getContacts();
      if (data != null) {
        return emit(const ContactDataState()
            .copyWith(contactStatus: ContactStatus.success, contacts: data));
      }
      return emit(const ContactDataState().copyWith(
          contactStatus: ContactStatus.failure,
          message:
              "Kontak tidak ditemukan, pastikan kamu sudah menambah nomor pada kontak di telepon."));
    } catch (e) {
      emit(const ContactDataState().copyWith(
          contactStatus: ContactStatus.failure,
          message: "Terjadi kesalahan sistem, silahkan coba kembali!"));
    }
  }
}
