import 'package:flutter/material.dart';
import 'package:marketplace/models/advertising.dart';
import 'package:carousel_slider/carousel_slider.dart';


class AdDetails extends StatefulWidget {
  AdDetails({
    super.key,
    required this.advertising,
  });

  Advertising? advertising;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {

  Advertising? _advertising;

  List<Widget> _getListAssets(){

    List<String> listUrl = _advertising!.assets;
    return listUrl.map((url){
      return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fitWidth
          )
        ),
      );
    }).toList();

}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _advertising = widget.advertising;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_advertising!.title),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              CarouselSlider(
                  items:_getListAssets(),
                  options: CarouselOptions(height: 250.0),
                ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("R\$ ${_advertising!.price}",
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold,
                    color: Colors.purple)
                    ),
                    Text(_advertising!.title,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400)
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    const Text("Descrição",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    Text(_advertising!.description,
                        style: const TextStyle(fontSize: 18)
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                     const Text("Contato",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 66),
                      child: Text(_advertising!.phone,
                          style: const TextStyle(fontSize: 18)
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          Positioned(
            left: 16, right: 16,bottom: 16,
              child: GestureDetector(
                onTap: (){},
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: const Text("Ligar", style: TextStyle(
                    color: Colors.white, fontSize: 20
                  ),),
                ),
              )
          )
        ],
      ),
    );
  }
}
