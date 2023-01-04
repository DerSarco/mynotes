import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Enter Your Email Here"),
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
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: email, password: password);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print("Weak Password");
                        } else if (e.code == 'email-already-in-use') {
                          print("Email already used");
                        } else if (e.code == "invalid-email") {
                          print("Invalid email entered");
                        } else {
                          print(e);
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login/",
                              (route) => false,
                        );
                      },
                      child: const Text("Already registered? Login here!"))
                ],
              );
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
