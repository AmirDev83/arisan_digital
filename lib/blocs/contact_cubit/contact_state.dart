part of 'contact_cubit.dart';

enum ContactStatus { initial, loading, success, failure }

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactDataState extends ContactState {
  const ContactDataState(
      {this.listContacts,
      this.contactStatus = ContactStatus.initial,
      this.message});

  final List<Contact>? listContacts;
  final ContactStatus contactStatus;
  final String? message;

  ContactDataState copyWith(
      {List<Contact>? contacts,
      ContactStatus? contactStatus,
      String? message}) {
    return ContactDataState(
        listContacts: contacts ?? listContacts,
        message: message ?? this.message,
        contactStatus: contactStatus ?? this.contactStatus);
  }

  @override
  List<Object> get props => [(listContacts ?? []), contactStatus];
}
