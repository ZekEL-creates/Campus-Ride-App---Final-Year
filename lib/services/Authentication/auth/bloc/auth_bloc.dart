import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/services/Authentication/auth/auth_provider.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_event.dart';
import 'package:ridesharingapp/services/Authentication/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUnintialized()) {
    on<AuthEventRegister>((event, emit) async {
      try {
        emit(AuthStateRegistering(exception: null, isLoading: true));
        await provider.signUp(email: event.email, password: event.password);
        emit(AuthStateRegistering(exception: null, isLoading: false));
        emit(AuthStateRegistered());
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventRegistrationSuccess>((event, emit) {
      emit(AuthStateRegistered());
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateSelectRole());
    });

    on<AuthEventSelectRole>((event, emit) {
      emit(AuthStateRegistering(exception: null, isLoading: false));
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(AuthStateLoggedOut(exception: null, isLoading: true));
      try {
        final user = await provider.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logout();
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
