import 'package:e_commerce_app/core/constants/app_colors.dart';
import 'package:e_commerce_app/core/constants/app_strings.dart';
import 'package:e_commerce_app/logic/auth_bloc/auth_bloc.dart';
import 'package:e_commerce_app/logic/auth_bloc/auth_event.dart';
import 'package:e_commerce_app/logic/auth_bloc/auth_state.dart';
import 'package:e_commerce_app/logic/contact_bloc/contact_bloc.dart';
import 'package:e_commerce_app/logic/contact_bloc/contact_event.dart';
import 'package:e_commerce_app/logic/contact_bloc/contact_state.dart';
import 'package:e_commerce_app/presentation/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();  
    // Khi vào Home, tự động load contacts
    context.read<ContactBloc>().add(LoadContacts());
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
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
        body: BlocBuilder<ContactBloc, ContactState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactLoaded) {
              final contacts = state.contacts;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ContactBloc>().add(LoadContacts());
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: contacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final contact = contacts[index];

                    return ContactCard(contact: contact);
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
    );
  }
}