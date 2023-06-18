
import 'package:cloud_firestore/cloud_firestore.dart';

class Advertising {

  String? _id;
  String? _states;
  String? _category;
  String? _title;
  String? _price;
  String? _phone;
  String? _description;
  List<String>? _assets;

  Advertising(){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference anuncios = firestore.collection("MeusAnuncuis");
    id = anuncios.doc().id;

    assets = [];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : id,
      "estado" : states,
      "Categoria" : category,
      "titulo" : title,
      "preco" : price,
      "telefone" : phone,
      "descricao" : description,
      "imagens" :assets
    };
    return map;
  }

  List<String> get assets => _assets!;

  set assets(List<String> value) {
    _assets = value;
  }

  String get description => _description!;

  set description(String value) {
    _description = value;
  }

  String get phone => _phone!;

  set phone(String value) {
    _phone = value;
  }

  String get price => _price!;

  set price(String value) {
    _price = value;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get category => _category!;

  set category(String value) {
    _category = value;
  }

  String get states => _states!;

  set states(String value) {
    _states = value;
  }

  String get id => _id!;

  set id(String value) {
    _id = value;
  }
}