import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_provider.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      try {
        final user = await provider.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });

    on<AuthEventLogOut>((event, emit) {
      try {
        emit(AuthStateLoading());
        provider.logout();
        emit(AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}
