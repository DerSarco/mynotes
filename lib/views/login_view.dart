import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  ///El TextEditingController nos ayuda a manipular los datos ingresados en
  ///un TextInput

  late final TextEditingController _email;
  late final TextEditingController _password;

  /// Se deben inicializar para que este no crashee, como es de tipo TextEditingController
  /// le asignamos una instancia de este mismo
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  ///Es una buena práctica hacer dispose de los objetos del arbol cuando estos ya no
  ///están siendo utilizados
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  ///Con el FutureBuilder podemos generar widgets dependiendo de la respuesta de un future
  ///dentro del builder podemos revisar el resultado con el parametro snapshot, este
  ///tiene asginado el future que le pasamos a la propiedad future del FutureBuilder
  ///y con esto retornar el widget necesario para el árbol.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter Your Email Here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter Your Password Here",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, password: password);
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/notes/',
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log('User not found');
                } else if (e.code == 'wrong-password') {
                  devtools.log('Incorrect Password');
                } else {
                  devtools.log('User Not Found');
                  devtools.log(e.code);
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/register/",
                (route) => false,
              );
            },
            child: const Text("Not registered yet? Register here!"),
          )
        ],
      ),
    );
  }
}
