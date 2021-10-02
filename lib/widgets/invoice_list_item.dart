import 'package:flutter/material.dart';
import 'package:mr_invoice/invoice/invoicebuilder.dart';
import 'package:mr_invoice/models/invoice.dart';

//ignore: must_be_immutable
class InvoiceListItem extends StatelessWidget {

  Invoice invoice;
  InvoiceListItem(this.invoice);

  final Radius radius = Radius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        InvoiceBuilder invoiceBuilder = InvoiceBuilder(isEstimate:false,regenerate: true,invoice:invoice);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>invoiceBuilder.getInvoicePdfPreview()));
      },
      child: Card(
        color: Color(0xFF687466),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.5,
                color: Color(0xFFfadcaa)
            ),
            borderRadius: BorderRadius.all(radius)
        ),
        elevation: 16.0,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF346588), borderRadius: BorderRadius.all(radius)),
          height: 115,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${invoice.id}",
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
                      "${invoice.date}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                      width: 10,
                    ),
                    Text("To:",style: TextStyle(color: Color(0xFFfcdab7), fontSize: 14)),
                    SizedBox(
                      height: 5,
                      width: 10,
                    ),
                    Text("${invoice.forName}",style: TextStyle(color: Color(0xFFb9ebcc), fontSize: 16))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rs ${invoice.amount}",
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
    );
  }


}
