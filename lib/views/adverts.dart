import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace/route_generator.dart';

class Adverts extends StatefulWidget {
  const Adverts({Key? key}) : super(key: key);

  @override
  State<Adverts> createState() => _AdvertsState();
}

class _AdvertsState extends State<Adverts> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> itemMenu = [];

  _itemChosenMenu(String itemChosen) {
    switch (itemChosen) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "routeName");
        break;
      case "Deslogar":
        auth.signOut().then(
            (value) => Navigator.pushNamed(context, RouteGenerator.rotaLogin));
        break;
      case "Entrar/Cadastrar":
        Navigator.pushNamed(context, RouteGenerator.rotaLogin);
        break;
    }
  }

  Future? _checkLoggedUser() async {
    User? user = auth.currentUser;

    if (user == null) {
      itemMenu = ["Entrar/Cadastrar"];
    } else {
      itemMenu = ["Meus anúncios", "Deslogar"];
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
              onSelected: _itemChosenMenu,
              itemBuilder: (context) {
                return itemMenu.map((String item) {
                  return PopupMenuItem<String>(value: item, child: Text(item));
                }).toList();
              })
        ],
      ),
      body: const Center(
        child: Text("anucios aqui!"),
      ),
    );
  }
}
