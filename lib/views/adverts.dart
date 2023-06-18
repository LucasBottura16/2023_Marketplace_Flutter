import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marketplace/models/advertising.dart';
import 'package:marketplace/route_generator.dart';
import 'package:marketplace/util/configs.dart';
import 'package:marketplace/views/components/itens_adverts.dart';

class Adverts extends StatefulWidget {
  const Adverts({Key? key}) : super(key: key);

  @override
  State<Adverts> createState() => _AdvertsState();
}

class _AdvertsState extends State<Adverts> {
  FirebaseAuth auth = FirebaseAuth.instance;

  List<String> itemMenu = [];
  List<DropdownMenuItem<String>> dropdownItemsState = [];
  List<DropdownMenuItem<String>> dropdownItemsCategory = [];

  final _controler =StreamController<QuerySnapshot>.broadcast();
  String? _selectedItemState;
  String? _selectedItemCategory;

  _itemChosenMenu(String itemChosen) {
    switch (itemChosen) {
      case "Meus anúncios":
        Navigator.pushNamed(context, RouteGenerator.rotaMyAdverts);
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

  _loadItems(){

    dropdownItemsCategory = DropConfigs.getCategory()!;


    dropdownItemsState = DropConfigs.getStates()!;
  }

  Future<Stream<QuerySnapshot>?>? _addListenerAdverts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Stream<QuerySnapshot> stream =
    firestore.collection("Anuncios").snapshots();

    stream.listen((event) {
      _controler.add(event);
    });

    return null;
  }

  Future<Stream<QuerySnapshot>?>? _filterListenerAdverts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Query query = firestore.collection("Anuncios");

    debugPrint("entrou filtro");

    if(_selectedItemState != null){
      query = query.where("estado", isEqualTo: _selectedItemState);
    }
    if(_selectedItemCategory != null){
      query = query.where("Categoria", isEqualTo: _selectedItemCategory);
    }

    Stream<QuerySnapshot> stream = query.snapshots();

    stream.listen((event) {
      _controler.add(event);
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
    _checkLoggedUser();
    _addListenerAdverts();
  }

  @override
  Widget build(BuildContext context) {

    Widget loadingData = const Center(
      child: Column(
        children: [
          Text("Carregnado dados..."),
          CircularProgressIndicator()
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("OLX"),
        backgroundColor: const Color(0xff9c27b0),
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Colors.purple,
                        value: _selectedItemState,
                        items: dropdownItemsState,
                        style: const TextStyle(fontSize: 22, color: Colors.black),
                        onChanged: (state){
                          setState(() {
                            _selectedItemState = state;
                          });
                          _filterListenerAdverts();
                        },
                      ),
                    ),
                  )
              ),
              Container(
                color: Colors.grey[200],
                width: 2,
                height: 60,
              ),
              Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Colors.purple,
                        value: _selectedItemCategory,
                        items: dropdownItemsCategory,
                        style: const TextStyle(fontSize: 22, color: Colors.black),
                        onChanged: (category){
                          setState(() {
                            _selectedItemCategory = category;
                          });
                          _filterListenerAdverts();
                        },
                      ),
                    ),
                  )
              ),
            ],
          ),

          StreamBuilder(
          stream: _controler.stream,
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              return loadingData;
              case ConnectionState.active:
              case ConnectionState.done:
                if(snapshot.hasError) return const Text("Erro ao carregar!");

                QuerySnapshot<Object?>? querySnapshot = snapshot.data;

                if( querySnapshot!.docs.isEmpty){
                  return const Center(
                    child: Text("Nenhum anúncio encontrado!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                    ),
                  );
                }

                return Expanded(
                    child: ListView.builder(
                      itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index){

                          List<DocumentSnapshot> adverts =querySnapshot!.docs.toList();
                          DocumentSnapshot documentSnapshot = adverts[index];
                          Advertising allAdverts = Advertising.fromDocumentSnapshot(documentSnapshot);

                          return ItensAdverts(
                              advertising: allAdverts,
                            onTapItem: (){
                                debugPrint(allAdverts.title);
                                },
                          );
                        }
                    )
                );

            }
            return Container();
          }
          )
        ],
      )
    );
  }
}
