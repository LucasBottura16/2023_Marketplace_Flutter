import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class DropConfigs {

  static List<DropdownMenuItem<String>>? getCategory(){

    List<DropdownMenuItem<String>> itemsDropCategory = [];

    itemsDropCategory.add(
        const DropdownMenuItem(value:null, child: Text("Categoria", style:
          TextStyle(color: Colors.purple),))
    );
    itemsDropCategory.add(
        const DropdownMenuItem(value:"auto", child: Text("Automóvel"))
    );
    itemsDropCategory.add(
        const DropdownMenuItem(value:"moda", child: Text("Moda"))
    );
    itemsDropCategory.add(
        const DropdownMenuItem(value:"eletro", child: Text("Eletrônico"))
    );
    itemsDropCategory.add(
        const DropdownMenuItem(value:"esportes", child: Text("Esportes"))
    );

    return itemsDropCategory;

  }

  static List<DropdownMenuItem<String>>? getStates(){

    List<DropdownMenuItem<String>> itemsDropStates = [];

    itemsDropStates.add(
        const DropdownMenuItem(value:null, child: Text("Região", style:
        TextStyle(color: Colors.purple),))
    );

    for(var estado in Estados.listaEstadosSigla){
      itemsDropStates.add(
          DropdownMenuItem(value: estado,child: Text(estado))
      );
    }

    return itemsDropStates;

  }



}