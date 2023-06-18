import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketplace/models/advertising.dart';
import 'package:marketplace/route_generator.dart';
import 'package:marketplace/util/configs.dart';
import 'package:marketplace/views/components/custom_button.dart';
import 'package:marketplace/views/components/custom_input.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:validadores/Validador.dart';

class NewAdvert extends StatefulWidget {
  const NewAdvert({Key? key}) : super(key: key);

  @override
  State<NewAdvert> createState() => _NewAdvertState();
}

class _NewAdvertState extends State<NewAdvert> {
  final List<File> _listImage = [];
  final _formKey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  String? selectedItemState;
  String? selectedItemCategory;
  List<DropdownMenuItem<String>> dropdownItemsState = [];
  List<DropdownMenuItem<String>> dropdownItemsCategory = [];
  final TextEditingController _controllerTitle =TextEditingController();
  final TextEditingController _controllerPrice =TextEditingController();
  final TextEditingController _controllerPhone =TextEditingController();
  final TextEditingController _controllerDescription =TextEditingController();
  Advertising? _advertising;
  BuildContext? _dialogContex;

  _selectGallery() async {
    File? imagemSelecionada;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imagemSelecionada = File(pickedFile!.path);

    setState(() {
      _listImage.add(imagemSelecionada!);
    });
  }

  _openDialog(BuildContext context){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Salvando anúncio")
              ],
            ),
          );
        }
    );

  }

  _saveAd() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userLogged = auth.currentUser;
    String? uidUser = userLogged!.uid;

    _openDialog(_dialogContex!);

    await _uploadImages();

    firestore
        .collection("MeusAnuncios").doc(uidUser)
        .collection("Anuncios").doc(_advertising!.id)
        .set(_advertising!.toMap());

    firestore.collection("Anuncios").doc(_advertising!.id)
        .set(_advertising!.toMap()).then((_) => {
          Navigator.pop(_dialogContex!),
          Navigator.pop(context)
    });
  }

  Future _uploadImages() async {

    FirebaseStorage storage = FirebaseStorage.instance;

    Reference raiz = storage.ref();

    for( var images in _listImage){

      String nameImage = DateTime.now().millisecondsSinceEpoch.toString();
      Reference file = raiz.child("MeusAnuncios").child(_advertising!.id)
      .child(nameImage);

      UploadTask uploadTask = file.putFile(images);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String url = await taskSnapshot.ref.getDownloadURL();
      _advertising?.assets.add(url);

    }

  }

  @override
  void initState() {
    super.initState();

    _loadItems();

    _advertising = Advertising.gerarId();

  }
  _loadItems(){

   dropdownItemsCategory = DropConfigs.getCategory()!;


   dropdownItemsState = DropConfigs.getStates()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Anúncio"),
        backgroundColor: const Color(0xff9c27b0),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FormField(
                      initialValue: _listImage,
                      validator: (images) {
                        if (images!.isEmpty) {
                          return "Necessário selecionar uma imagem";
                        }
                        return null;
                      },
                      builder: (state) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _listImage.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _listImage.length) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            _selectGallery();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[400],
                                            radius: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_a_photo,
                                                  size: 40,
                                                  color: Colors.grey[100],
                                                ),
                                                Text(
                                                  "Adicionar",
                                                  style: TextStyle(
                                                    color: Colors.grey[100],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    if (_listImage.isNotEmpty) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.file(_listImage[
                                                              index]),
                                                          TextButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  _listImage
                                                                      .removeAt(
                                                                          index);
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                              child: const Text(
                                                                  "Excluir"))
                                                        ],
                                                      ),
                                                    ));
                                          },
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                                FileImage(_listImage[index]),
                                            child: Container(
                                              color: const Color.fromRGBO(
                                                  255, 255, 255, 0.3),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return Container();
                                  }),
                            ),
                            if (state.hasError)
                              Text(
                                "[${state.errorText}]",
                                style: const TextStyle(color: Colors.red),
                              )
                          ],
                        );
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              hint: const Text("Estados"),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20
                              ),
                              value: selectedItemState,
                              items: dropdownItemsState,
                              onSaved: (states){
                                _advertising?.states = states!;
                              },
                              validator: (value){
                                return Validador().add(
                                  Validar.OBRIGATORIO, msg: "Campo obrigatório"
                                ).valido(value);
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedItemState = value;
                                  debugPrint(value);
                                });
                              },
                            ),
                          )
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                              hint: const Text("Categorias"),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20
                              ),
                              value: selectedItemCategory,
                              items: dropdownItemsCategory,
                              onSaved: (category){
                                _advertising?.category = category!;
                              },
                              validator: (value){
                                return Validador().add(
                                    Validar.OBRIGATORIO, msg: "Campo obrigatório"
                                ).valido(value);
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedItemCategory = value;
                                  debugPrint(value);
                                });
                              },
                            ),
                          )
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                      controller: _controllerTitle,
                      hint: "Titulo",
                    onSaved: (title){
                        _advertising?.title = title!;
                        return null;
                    },
                    validators: (value){
                       return Validador().add(
                          Validar.OBRIGATORIO, msg: "Campo obrigatório"
                        ).valido(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: _controllerPrice,
                    hint: "Preço",
                    onSaved: (price){
                      _advertising?.price = price!;
                      return null;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter()
                    ],
                    validators: (value){
                      return Validador().add(
                          Validar.OBRIGATORIO, msg: "Campo obrigatório"
                      ).valido(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: _controllerPhone,
                    hint: "Telefone",
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                    onSaved: (phone){
                      _advertising?.phone = phone!;
                      return null;
                    },
                    validators: (value){
                      return Validador().add(
                          Validar.OBRIGATORIO, msg: "Campo obrigatório"
                      ).valido(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    controller: _controllerDescription,
                    hint: "Descrição (200 caracteres)",
                    maxlines: null,
                    onSaved: (desc){
                      _advertising?.description = desc!;
                      return null;
                    },
                    validators: (value){
                      return Validador().add(
                          Validar.OBRIGATORIO, msg: "Campo obrigatório"
                      ).maxLength(200, msg: "Máximo de 200 caracteres").valido(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                      text: "Cadastrar Anúncio",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {

                          _formKey.currentState?.save();

                          _dialogContex = context;

                          _saveAd();
                        }
                      })
                ],
              )
          )
      ),
    );
  }
}
