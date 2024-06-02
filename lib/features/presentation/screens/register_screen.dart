import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/features/presentation/providers/api_register.dart';
import 'package:time_to_train/features/presentation/widgets.dart';



class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded, size: 40, color: Colors.white),
                  ),
                  const Spacer(flex: 1),
                  Text('Crear cuenta', style: textStyles.titleLarge?.copyWith(color: Colors.white)),
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
                height: size.height - 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: _RegisterForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerStatefulWidget {
  const _RegisterForm();

  @override
  ConsumerState<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _lastname = '';
  String _username = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Nombre',
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Apellido',
              onChanged: (value) => _lastname = value,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Usuario',
              onChanged: (value) => _username = value,
            ),
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
            CustomTextFormField(
              label: 'Confirmar Contraseña',
              obscureText: true,
              onChanged: (value) => {},
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Registro',
                buttonColor: Colors.black,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      await ApiService().registerUser(_name, _lastname, _username, _email, _password);
                      context.pop('/home_view');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to register user: $e')),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                  onPressed: () => context.push('/'),
                  child: const Text('Inicia sesión'),
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
