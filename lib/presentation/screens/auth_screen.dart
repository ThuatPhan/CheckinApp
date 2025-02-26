import 'package:checkin_app/data/services/auth_service.dart';
import 'package:checkin_app/presentation/bloc/auth_cubit.dart';
import 'package:checkin_app/presentation/screens/checkin_screen.dart';
import 'package:checkin_app/presentation/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit()..initialAuthenticate(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckinScreen()),
                );
              });
            } else if (state is AuthenticatedError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              });
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is UnAuthenticated) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.instance.login();
                    },
                    child: const Text("Đăng nhập"),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
