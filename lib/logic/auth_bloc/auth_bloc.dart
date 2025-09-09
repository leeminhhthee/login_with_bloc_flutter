import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 600)); // simulate delay
    if (event.email == 'user@example.com' && event.password == '1234') {
      emit(AuthAuthenticated(event.email));
    } else {
      emit(AuthFailure('Email hoặc mật khẩu không hợp lệ'));
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 200));
    emit(AuthUnauthenticated());
  }
}
