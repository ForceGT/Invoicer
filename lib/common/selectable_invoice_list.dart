import 'package:flutter/material.dart';
import 'package:mr_invoice/models/invoice.dart';
import 'package:mr_invoice/models/reciept.dart';
import 'package:mr_invoice/receipt/receiptbuilder.dart';

class SelectableInvoiceList extends StatefulWidget {
  Receipt _receipt;


  @override
  _SelectableInvoiceListState createState() => _SelectableInvoiceListState();

  SelectableInvoiceList({receipt}):_receipt=receipt;

}

class _SelectableInvoiceListState extends State<SelectableInvoiceList> {

  late List<bool> checkedServices;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkedServices = List.empty();
  }

  @override
  Widget build(BuildContext context) {



    return FutureBuilder(
        future: Invoice.getInvoiceByName(widget._receipt.fromName),
        builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {

          print("Widget Receipt From Name: ${widget._receipt.fromName}");

          return Scaffold(
            appBar: AppBar(
              title: Text("Total Receipt Amount: ${widget._receipt.amount}"),
            ),
            body: (!snapshot.hasData || snapshot.data!.isEmpty)
                ? Center(
              child: Text(
                "No Invoices for the Client found",
                style: TextStyle(color: Colors.white),
              ),
            )
                : ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  checkedServices.add(snapshot.data![index].isSelected);

                  return Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      color: Color(0xFF346588),
                      elevation: checkedServices[index] == true ? 150.0 : 0,
                      child: CheckboxListTile(
                        selected: checkedServices[index],
                        onChanged: (value){
                          checkedServices[index]=!checkedServices[index];
                          setState(() {

                            if (checkedServices[index])
                              {

                                   widget._receipt.amount+=snapshot.data![index].amount!;
                               // widget._receipt.amount -= snapshot.data[index].amount;
                                // widget._receipt.forInvoice ="";
                                widget._receipt.forInvoice +=
                                    snapshot.data![index].id.toString()+",";
                                snapshot.data![index].forReceiptId =widget._receipt.id!;
                              }
                            else{
                              widget._receipt.amount-=snapshot.data![index].amount!;
                            }

                            checkedServices.removeRange(
                                index + 1, checkedServices.length);
                          }
                          );
                        },
                        value: checkedServices[index],
                        title: Text(
                          "INV ${snapshot.data![index].id}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        subtitle: Text("Rs " + snapshot.data![index].amount.toString(),
                          style: TextStyle(color: Colors.grey[400]),),
                      ),
                    ),
                  );
                }),
            floatingActionButton: FloatingActionButton(

              child: Icon(Icons.done,color: Colors.white,),
              onPressed: () async{

                if(widget._receipt.amount == 0){
                  var result = await showDialog(context: context,builder: (context){
                    return buildConfirmationDialog(context);
                  });
                  if(result == true){
                    ReceiptBuilder receiptBuilder = ReceiptBuilder(receipt: widget._receipt,regenerate: false);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>receiptBuilder.getPdfPreview(MediaQuery.of(context).size.width*1.5, MediaQuery.of(context).size.height*0.45)));
                  }
                }
                else{
                  ReceiptBuilder receiptBuilder = ReceiptBuilder(receipt: widget._receipt,regenerate: false);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>receiptBuilder.getPdfPreview(MediaQuery.of(context).size.width*1.5, MediaQuery.of(context).size.height*0.45)));
                }

              },
            ),
          );
        });
  }

  Widget buildConfirmationDialog(BuildContext context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text("Are you sure you want to proceed?"),
      content: Text("Total Amount is zero"),
      actions: [
              MaterialButton(
                  child: Text("YES"),
                  onPressed: () {
                    Navigator.pop(context, true);
                  }),
              MaterialButton(
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  })
      ],
    );
  }
}
