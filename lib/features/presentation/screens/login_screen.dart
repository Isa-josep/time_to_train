import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              const SizedBox( height: 40 ),

               Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    const Spacer(flex: 1),
                    Text('name de la app', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),
              // Icon Banner
              const Icon( 
                Icons.fitness_center,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox( height: 80 ),
            
              Container(
                height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: const _LoginForm(),
              )
            ],
          ),
        )
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context,ref) {

   // final loginForm =ref.watch(loginFormProvider);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox( height: 30 ),
          Text('Bienvenido', style: textStyles.titleLarge ),
          const SizedBox( height: 30 ),

           const CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
           // onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
            //errorMessage: loginForm.isFormPosted ? 
           // loginForm.email.errorMessage : null,
          ),
          const SizedBox( height: 30 ),

           const CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            // onChanged: ref.read(loginFormProvider.notifier).onPasswordChanged,
            // errorMessage: loginForm.isFormPosted ? 
            // loginForm.password.errorMessage: null,
          ),
    
          const SizedBox( height: 30 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Ingresar',
              buttonColor: Colors.black,
              onPressed: (){
                //ref.read(loginFormProvider.notifier).onFormSubmit();
                context.push('/home_view'); //TODO: Cambiar por la ruta correcta
              },
            )
          ),

          const SizedBox( height: 15 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: ()=> context.push('/register_screen'), 
                child: const Text('Crea una aquí')
              )
            ],
          ),
          const Spacer( flex: 1),
        ],
      ),
    );
  }
}