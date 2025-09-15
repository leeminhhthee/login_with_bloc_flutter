import 'package:e_commerce_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:e_commerce_app/features/contacts/presentation/blocs/contact_bloc.dart';
import 'package:e_commerce_app/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Contact
import 'features/contacts/data/datasources/contact_local_datasource.dart';
import 'features/contacts/data/repositories/contact_repository.dart';

// Auth
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/get_current_user.dart';

import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ContactRepository _createContactRepository() {
    final local = ContactLocalDataSource();
    return ContactRepository(local);
  }

  AuthRepositoryImpl _createAuthRepository() {
    final local = AuthLocalDataSourceImpl();
    return AuthRepositoryImpl(local);
  }

  @override
  Widget build(BuildContext context) {
    final contactRepo = _createContactRepository();
    final authRepo = _createAuthRepository();

    final loginUser = LoginUser(authRepo);
    final logoutUser = LogoutUser(authRepo);
    final getCurrentUser = GetCurrentUser(authRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUser: loginUser,
            logoutUser: logoutUser,
            getCurrentUser: getCurrentUser,
          )..add(CheckAuthStatus()), // kiểm tra trạng thái ngay khi khởi động
        ),
        BlocProvider<ContactBloc>(create: (_) => ContactBloc(contactRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contact BLoC App',
        theme: appLightTheme(),
        darkTheme: appDarkTheme(),
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}
