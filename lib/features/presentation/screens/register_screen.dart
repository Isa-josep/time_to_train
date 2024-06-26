import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              const SizedBox( height: 20 ),
              // Icon Banner

              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        if ( !context.canPop() ) return;
                        context.pop();
                      }, 
                      icon: const Icon( Icons.arrow_back_rounded, size: 40, color: Colors.white )
                    ),
                    const Spacer(flex: 1),
                    Text('Crear cuenta', style: textStyles.titleLarge?.copyWith(color: Colors.white )),
                    const Spacer(flex: 2),
                  ],
                ),
              const Icon( 
                Icons.fitness_center,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox( height: 80 ),
            
              Container(
                height: size.height - 70, // 80 los dos sizebox y 100 el ícono 250 si se modifica
                
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

    //final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox( height: 30 ),
         // Text('Bienvenido', style: textStyles.titleLarge ),
          

          const CustomTextFormField(
            label: 'Nombre',
            // onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
            // errorMessage: loginForm.isFormPosted ? 
            // loginForm.email.errorMessage : null,
          ),
          const SizedBox( height: 30 ),

          const CustomTextFormField(
            label: 'Apellido',
            // onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
            // errorMessage: loginForm.isFormPosted ? 
            // loginForm.email.errorMessage : null,
          ),
          const SizedBox( height: 30 ),

          const CustomTextFormField(
            label: 'Usuario',
            // onChanged: ref.read(loginFormProvider.notifier).onEmailChanged,
            // errorMessage: loginForm.isFormPosted ? 
            // loginForm.email.errorMessage : null,
          ),
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
              text: 'Resgistro',
              buttonColor: Colors.black,
              onPressed: (){
                //ref.read(loginFormProvider.notifier).onFormSubmit();
                //context.pop('/home_view'); //TODO: Cambiar por la ruta correcta
              },
            )
          ),

          const SizedBox( height: 5 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: ()=> context.push('/'), 
                child: const Text('Inicia sesión')
              )
            ],
          ),
          const Spacer( flex: 1),
          
        ],
      ),
    );
  }
}