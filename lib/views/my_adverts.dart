import 'package:flutter/material.dart';
import 'package:marketplace/route_generator.dart';

class MyAdverts extends StatefulWidget {
  const MyAdverts({Key? key}) : super(key: key);

  @override
  State<MyAdverts> createState() => _MyAdvertsState();
}

class _MyAdvertsState extends State<MyAdverts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Anúncios"),
        backgroundColor: const Color(0xff9c27b0),
      ),
      body: Container(),
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
