import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/models/advertising.dart';
import 'package:marketplace/route_generator.dart';
import 'package:marketplace/views/components/itens_adverts.dart';

class MyAdverts extends StatefulWidget {
  const MyAdverts({Key? key}) : super(key: key);

  @override
  State<MyAdverts> createState() => _MyAdvertsState();
}

class _MyAdvertsState extends State<MyAdverts> {
  
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _uidUser;

  _retrieveUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userLogged = auth.currentUser;
    _uidUser = userLogged!.uid;
  }

  Future<Stream<QuerySnapshot>?>? _addListenerAdverts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
     await _retrieveUserData();
    
    Stream<QuerySnapshot> stream =
    firestore.collection("MeusAnuncios").doc(_uidUser).collection("Anuncios")
    .snapshots();
    
    stream.listen((event) {
      _controller.add(event);
    });

    return null;
  }
  
  _removeAdverts(String idAdverts) async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    firestore.collection("MeusAnuncios").doc(_uidUser).collection("Anuncios")
    .doc(idAdverts).delete().then((value) => {
      firestore.collection("Anuncios").doc(idAdverts).delete(),
      Navigator.of(context).pop()
    });
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: const Text("Meus Anúncios"),
        backgroundColor: const Color(0xff9c27b0),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){

          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return loadingData;
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasError) return const Text("Erro ao carregar dados!");

              QuerySnapshot<Object?>? querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot?.docs.length,
                  itemBuilder: (context, index){

                    List<DocumentSnapshot> adverts =querySnapshot!.docs.toList();
                    DocumentSnapshot documentSnapshot = adverts[index];
                    Advertising myAdverts = Advertising.fromDocumentSnapshot(documentSnapshot);

                    return ItensAdverts(
                      advertising: myAdverts,
                      onPressedRemove: (){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                title: const Text("Confirmar"),
                                content: const Text("Deseja remalmente excluir o anúncio?"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: (){_removeAdverts(myAdverts.id);},
                                    style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red)
                                    ),
                                      child: const Text("Excluir"),
                              ),
                                  TextButton(
                                      onPressed: (){Navigator.of(context).pop();},
                                      child: const Text("Cancelar"))
                                ],
                              );
                            });
                      },
                    );
                  }
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff9c27b0),
        foregroundColor: Colors.white,
        onPressed: (){
          Navigator.pushNamed(context, RouteGenerator.rotaNewAdvert);
        },
        child: const Icon(Icons.add),
      )
    );
  }
}
