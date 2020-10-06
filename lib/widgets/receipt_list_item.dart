import 'package:flutter/material.dart';
import 'package:mr_invoice/models/reciept.dart';

class ReceiptListItem extends StatelessWidget {

  final Receipt receipt;


  ReceiptListItem(this.receipt);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.height;


    final Radius radius = Radius.circular(24.0);



    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onLongPress: (){
          print("Long Pressed");
        },
        child: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.indigo, Colors.indigoAccent]),
              borderRadius: BorderRadius.all(radius)),
          height: 140,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${receipt.date}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text("${receipt.id}"),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text("For Payment:"),
                    SizedBox(
                      height: 5,
                      width: 10,
                    ),
                    Text("${receipt.fromName}")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${receipt.amount}"),
                    SizedBox(
                      height: 10,
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
