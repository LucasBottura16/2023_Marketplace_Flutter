import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marketplace/models/my_user.dart';
import 'package:marketplace/route_generator.dart';
import 'package:marketplace/views/components/custom_button.dart';
import 'package:marketplace/views/components/custom_input.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool _register = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // validates typed fields
  _validateFields() async {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    MyUser myUser = MyUser();
    myUser.email = email;
    myUser.password = password;

    // alert: error popup on screen
    alertError(String error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Erro ao realizar o cadastro"),
              content: Text(error),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Fechar"))
              ],
            );
          });
    }

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty) {
        if (_register == false) {
          _signInAccount(myUser, alertError);
        } else {
          _createAccount(myUser, alertError);
        }
      } else {
        alertError("A senha deve ter pelo menos 6 caracteres");
      }
    } else {
      alertError("Preencha um E-mail válido!");
    }
  }

  // enter the user in the app
  _signInAccount(MyUser myUser, Function alertError) async {
    await auth
        .signInWithEmailAndPassword(
            email: myUser.email, password: myUser.password)
        .then((value) => Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.rotaAdverts, (_) => false))
        .catchError((error) => alertError(error.toString()));
  }

  // Crate account to user
  _createAccount(MyUser myUser, Function alertError) async {
    await auth
        .createUserWithEmailAndPassword(
            email: myUser.email, password: myUser.password)
        .then((value) => debugPrint(
            'cadastrou') /*db.collection("Clientes").doc(value.user!.uid).set(myUser.tpMap())*/)
        .then((value) => Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.rotaAdverts, (_) => false))
        .catchError((error) => alertError(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          backgroundColor: const Color(0xff9c27b0),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('images/logo.png', width: 200, height: 150),
                CustomInput(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                CustomInput(
                  controller: _controllerPassword,
                  hint: "Password",
                  obscure: true,
                  maxlines: 1,
                  type: TextInputType.text,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Logar"),
                    Switch(
                        activeColor: Colors.purple,
                        value: _register,
                        onChanged: (bool valor) {
                          setState(() {
                            _register = valor;
                          });
                        }),
                    const Text("Cadastrar"),
                  ],
                ),
                CustomButton(
                    text: _register ? "Cadastrar" : "Entrar",
                    onPressed: _validateFields,
                ),
              ],
            ),
          ),
        ));
  }
}
