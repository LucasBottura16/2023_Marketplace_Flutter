import 'package:flutter/material.dart';
import 'package:marketplace/models/advertising.dart';

class ItensAdverts extends StatelessWidget {
  ItensAdverts({super.key,
   required this.advertising,
   this.onTapItem,
   this.onPressedRemove,
   });

  Advertising advertising;
  VoidCallback? onTapItem;
  VoidCallback? onPressedRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  advertising.assets[0],
                  fit: BoxFit.cover
                ),
              ),
               Expanded(
                flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( advertising.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text("R\$ ${advertising.price}"),
                      ],
                    ),
                  )
              ),
              if(onPressedRemove != null) Expanded(
                flex: 1,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: onPressedRemove,
                    child: const Icon(Icons.delete, color: Colors.white),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
