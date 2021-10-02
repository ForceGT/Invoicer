import 'package:flutter/material.dart';
import 'package:mr_invoice/models/reciept.dart';
import 'package:mr_invoice/receipt/receiptbuilder.dart';

class ReceiptListItem extends StatelessWidget {
  final Receipt receipt;

  ReceiptListItem(this.receipt);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.height;

    final Radius radius = Radius.circular(12.0);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          ReceiptBuilder receiptBuilder = ReceiptBuilder(regenerate: true,receipt: receipt);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>receiptBuilder.getPdfPreview(MediaQuery.of(context).size.width*1.5, MediaQuery.of(context).size.height*0.45)));

        },
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: Color(0xFFfadcaa)
            ),
            borderRadius: BorderRadius.all(radius)
          ),
          elevation: 8.0,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF346588), borderRadius: BorderRadius.all(radius)),
            height: 115,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${receipt.id!}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                            fontSize: 26),
                      ),
                    ],
                  ),
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
                      Text("For Payment:",style: TextStyle(color: Color(0xFFfcdab7), fontSize: 14)),
                      SizedBox(
                        height: 5,
                        width: 10,
                      ),
                      Text("${receipt.fromName}",style: TextStyle(color: Color(0xFFb9ebcc), fontSize: 16))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rs ${receipt.amount}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
