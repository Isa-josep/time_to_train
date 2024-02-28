import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/features/presentation/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body:  Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomTextFormField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const CustomTextFormField(
                label: 'Password',
                
                obscureText: true,
              ),
              const SizedBox(height: 16),
              
              SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Ingresar',
                buttonColor: Colors.black,
                onPressed: (){
                //ref.read(loginFormProvider.notifier).onFormSubmit();
              },
            )
          ),


              const SizedBox(height: 16),
            //   HorizontalViewCard(
            //     children: <Widget>[
            //       ElevatedButton(
            //         onPressed: () {},
            //         child: const Text('Google'),
            //       ),
            //       ElevatedButton(
            //         onPressed: () {},
            //         child: const Text('Facebook'),
            //       ),
            //     ],
            //   ),

                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta?'),
                  TextButton(
                    onPressed: ()=> context.push('/register'), 
                    child: const Text('Crea una aquí')
                  )
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}

