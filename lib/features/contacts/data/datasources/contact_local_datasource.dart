import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/contact_model.dart';

class ContactLocalDataSource {
  Future<List<Contact>> loadContacts() async {
    final jsonString = await rootBundle.loadString('assets/mock_contacts.json');
    final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
    return decoded.map((e) => Contact.fromJson(e as Map<String, dynamic>)).toList();
  }
}
