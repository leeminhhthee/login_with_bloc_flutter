import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactEvent {}
