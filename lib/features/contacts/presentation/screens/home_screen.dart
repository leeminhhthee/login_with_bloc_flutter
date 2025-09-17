import 'package:e_commerce_app/core/constants/app_colors.dart';
import 'package:e_commerce_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/blocs/auth_event.dart';
import 'package:e_commerce_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:e_commerce_app/features/contacts/presentation/blocs/contact_bloc.dart';
import 'package:e_commerce_app/features/contacts/presentation/blocs/contact_event.dart';
import 'package:e_commerce_app/features/contacts/presentation/blocs/contact_state.dart';
import 'package:e_commerce_app/features/contacts/presentation/screens/contact_detail_screen.dart';
import 'package:e_commerce_app/features/contacts/presentation/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<String?> _getLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUser');
  }

  @override
  void initState() {
    super.initState();  
    // When entering Home, automatically load contacts
    context.read<ContactBloc>().add(LoadContacts());
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "CONTACTS",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.white, size: 25)),
          ],
          backgroundColor: AppColors.primaryLight,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String?>(
              future: _getLoggedInEmail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Xin chào, ${snapshot.data!}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Contact list
            Expanded(
              child: BlocBuilder<ContactBloc, ContactState>(
                builder: (context, state) {
                  if (state is ContactLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ContactLoaded) {
                    final contacts = state.contacts;
                    if (contacts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.contact_page_outlined,
                                size: 80, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              "Chưa có liên hệ nào",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ContactBloc>().add(LoadContacts());
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: contacts.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ContactDetailScreen(contact: contact),
                                ),
                              );
                            },
                            child: ContactCard(contact: contact),
                          );
                        },

                      ),
                    );
                  } else if (state is ContactError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}