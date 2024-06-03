import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/features/presentation/providers/api_register.dart';
import 'package:time_to_train/features/presentation/providers/user_provider.dart';
import 'package:time_to_train/features/presentation/widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearTextFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('Time To Trine', style: textStyles.titleLarge?.copyWith(color: Colors.white)),
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
                height: MediaQuery.of(context).size.height - 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: Padding(
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
                          controller: _emailController,
                        ),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          label: 'Contraseña',
                          obscureText: true,
                          controller: _passwordController,
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
                                  final response = await ApiService().loginUser(_emailController.text, _passwordController.text);
                                  // Actualiza el estado del usuario
                                  ref.read(userProvider.notifier).state = User(
                                    response['user']['name'],
                                    response['user']['email'],
                                    response['user']['username'],
                                  );
                                  _clearTextFields(); // Limpiar campos de texto
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
