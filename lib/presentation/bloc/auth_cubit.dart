import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:checkin_app/data/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {}

class UnAuthenticated extends AuthState {}

class Authenticated extends AuthState {
  final Credentials credentials;

  Authenticated({required this.credentials});
}

class AuthenticatedError extends AuthState {
  final String message;

  AuthenticatedError({required this.message});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(UnAuthenticated());

  Future<void> initialAuthenticate() async {
    try {

      bool hasValidCredentials = await AuthService.instance.hasValidCredentials();
      if (hasValidCredentials) {
        final credentials = await AuthService.instance.getCredentials();
        emit(Authenticated(credentials: credentials));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthenticatedError(message: e.toString()));
    }
  }

  Future<void> login() async {
    try {
      final credentials = await AuthService.instance.login();
      emit(Authenticated(credentials: credentials));
    } catch (e) {
      emit(AuthenticatedError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await AuthService.instance.logout();
      emit(UnAuthenticated());
    } catch (e) {
      //Handle when cancel logout
      if (e.toString().contains("a0.authentication_canceled")) {
        final credentials = await AuthService.instance.getCredentials();
        emit(Authenticated(credentials: credentials));
      } else {
        emit(AuthenticatedError(message: e.toString()));
      }
    }
  }
}
