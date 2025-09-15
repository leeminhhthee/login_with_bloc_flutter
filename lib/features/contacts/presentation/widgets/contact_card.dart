import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/contact_model.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({Key? key, required this.contact}) : super(key: key);

  String initials(String name) {
    final parts = name.trim().split(' ').where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                initials(contact.name),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(contact.address,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(contact.phone,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Chỉ gọi khi bấm icon
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Calling ${contact.name}...")),
                );
              },
              icon: const Icon(Icons.phone, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
