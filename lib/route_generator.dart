import 'package:flutter/material.dart';
import 'package:marketplace/views/ad_details.dart';
import 'package:marketplace/views/adverts.dart';
import 'package:marketplace/views/login.dart';
import 'package:marketplace/views/my_adverts.dart';
import 'package:marketplace/views/new_adverts.dart';

class RouteGenerator {

  static const String rotaLogin = "/login";
  static const String rotaAdverts = "/adverts";
  static const String rotaMyAdverts = "/myAdverts";
  static const String rotaNewAdvert = "/newAdvert";
  static const String rotaAdDetails = "/adDetails";

  static var args;

  static Route<dynamic>? generateRoute(RouteSettings settings){

    args = settings.arguments;

    switch (settings.name){
      case rotaAdverts:
        return MaterialPageRoute(
            builder: (_) => const Adverts()
        );
      case rotaLogin:
        return MaterialPageRoute(
            builder: (_) => const Login()
        );
      case rotaMyAdverts:
        return MaterialPageRoute(
            builder: (_) => const MyAdverts()
        );
        case rotaNewAdvert:
        return MaterialPageRoute(
            builder: (_) => const NewAdvert()
        );
      case rotaAdDetails:
        return MaterialPageRoute(
            builder: (_) =>  AdDetails(advertising: args,)
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