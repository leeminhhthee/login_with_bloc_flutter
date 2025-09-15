import '../datasources/contact_local_datasource.dart';
import '../models/contact_model.dart';

class ContactRepository {
  final ContactLocalDataSource local;

  ContactRepository(this.local);

  Future<List<Contact>> getContacts() async {
    // For now returns local mock - easy to replace by remote later
    return await local.loadContacts();
  }
}
