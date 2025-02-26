import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:checkin_app/constants.dart';

class AuthService {
  Auth0 auth0 = Auth0(auth0Domain, auth0ClientId);

  static final AuthService instance = AuthService._internal();

  factory AuthService() => instance;

  AuthService._internal();

  Future<bool> hasValidCredentials() async {
    return await auth0.credentialsManager.hasValidCredentials();
  }

  Future<Credentials> getCredentials() async {
    return await auth0.credentialsManager.credentials();
  }

  Future<Credentials> login() async {
    return await auth0.webAuthentication().login(
          redirectUrl: callbackUrl,
          audience: audience,
        );
  }

  Future<String> getAccessToken() async {
    if (await auth0.credentialsManager.hasValidCredentials()) {
      final credentials = await auth0.credentialsManager.credentials();
      return credentials.accessToken;
    }
    throw Exception('Not signed in');
  }

  Future<void> logout() async {
    await auth0.webAuthentication().logout(returnTo: callbackUrl);
  }
}
