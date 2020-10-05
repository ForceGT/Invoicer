import 'package:flutter/material.dart';

class ReceiptListItem extends StatelessWidget {
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
                      "29/09/2020",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text("Receipt No"),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text("For Payment:"),
                    SizedBox(
                      height: 5,
                      width: 10,
                    ),
                    Text("Invoice Number/Name of Client")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Rs 1000"),
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
