import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridesharingapp/features/Authentication/auth_service/auth_provider.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_event.dart';
import 'package:ridesharingapp/features/Authentication/domain/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUnintialized()) {
    on<AuthEventRiderRegister>((event, emit) async {
      try {
        emit(AuthStateRiderRegistering(exception: null, isLoading: true));
        await provider.signUp(
          email: event.email,
          password: event.password,
          name: event.name,
          role: event.role,
        );
        emit(AuthStateRiderRegistering(exception: null, isLoading: false));
        emit(AuthStateRegistered());
      } on Exception catch (e) {
        emit(AuthStateRiderRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventDriverRegister>((event, emit) async {
      try {
        emit(AuthStateDriverRegistering(exception: null, isLoading: true));
        await provider.signUp(
          email: event.email,
          password: event.password,
          name: event.name,
          role: event.role,
        );
        emit(AuthStateDriverRegistering(exception: null, isLoading: false));
        emit(AuthStateRegistered());
      } on Exception catch (e) {
        emit(AuthStateDriverRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventRegistrationSuccess>((event, emit) {
      emit(AuthStateRegistered());
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateSelectRole());
    });

    on<AuthEventSelectRiderRole>((event, emit) {
      emit(AuthStateRiderRegistering(exception: null, isLoading: false));
    });

    on<AuthEventSelectDriverRole>((event, emit) {
      emit(AuthStateDriverRegistering(exception: null, isLoading: false));
    });

    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = await provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else {
        if (user.role == 'rider') {
          emit(AuthStateLoggedInAsRider(user));
        } else if (user.role == 'driver') {
          emit(AuthStateLoggedInAsDriver(user));
        }
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
        if (user.role == 'rider') {
          emit(AuthStateLoggedInAsRider(user));
        } else if (user.role == 'driver') {
          emit(AuthStateLoggedInAsDriver(user));
        }
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
