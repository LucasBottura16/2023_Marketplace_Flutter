import 'package:flutter/material.dart';
import 'package:marketplace/views/adverts.dart';
import 'package:marketplace/views/login.dart';

class RouteGenerator {

  static const String rotaAdverts = "/adverts";
  static const String rotaLogin = "/login";

  static Route<dynamic>? generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch (settings.name){
      case rotaAdverts:
        return MaterialPageRoute(
            builder: (_) => const Adverts()
        );
      case rotaLogin:
        return MaterialPageRoute(
            builder: (_) => const Login()
        );
      default:
        _errorRoute();
    }
    return null;

  }

  static Route<dynamic>? _errorRoute(){

    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tela não encontrada"),
            ),
            body: const Center(
              child:  Text("Tela não encontrada"),
            ),
          );
        }
    );

  }

}