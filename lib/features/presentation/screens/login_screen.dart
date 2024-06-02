import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/features/presentation/providers/api_register.dart';
import 'package:time_to_train/features/presentation/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),
                  Text('Nombre de la app', style: textStyles.titleLarge?.copyWith(color: Colors.white)),
                  const Spacer(flex: 2),
                ],
              ),
              const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 80),
              Container(
                height: size.height - 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: const _LoginForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text('Bienvenido', style: textStyles.titleLarge),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Correo',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => _email = value,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Contraseña',
              obscureText: true,
              onChanged: (value) => _password = value,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Ingresar',
                buttonColor: Colors.black,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      final response = await ApiService().loginUser(_email, _password);
                      context.push('/home_view', extra: response); // Pasa el usuario a la próxima vista
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to login: $e')),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes cuenta?'),
                TextButton(
                  onPressed: () => context.push('/register_screen'),
                  child: const Text('Crea una aquí'),
                ),
              ],
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
