import 'package:e_commerce_app/core/constants/app_strings.dart';
import 'package:e_commerce_app/logic/auth_bloc/auth_bloc.dart';
import 'package:e_commerce_app/logic/contact_bloc/contact_bloc.dart';
import 'package:e_commerce_app/presentation/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/contact_local_datasource.dart';
import 'data/repositories/contact_repository.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ContactRepository _createRepository() {
    final local = ContactLocalDataSource();
    return ContactRepository(local);
  }

  @override
  Widget build(BuildContext context) {
    final repository = _createRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<ContactBloc>(create: (_) => ContactBloc(repository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appTitle,
        theme: appLightTheme(),    
        darkTheme: appDarkTheme(),   
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}
