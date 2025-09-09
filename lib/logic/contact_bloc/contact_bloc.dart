import 'package:bloc/bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';
import '../../data/repositories/contact_repository.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository repository;

  ContactBloc(this.repository) : super(ContactInitial()) {
    on<LoadContacts>(_onLoadContacts);
  }

  Future<void> _onLoadContacts(LoadContacts event, Emitter<ContactState> emit) async {
    try {
      emit(ContactLoading());
      final list = await repository.getContacts();
      emit(ContactLoaded(list));
    } catch (e) {
      emit(ContactError('Không thể tải danh bạ: ${e.toString()}'));
    }
  }
}
