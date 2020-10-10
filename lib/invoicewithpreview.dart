import 'package:flutter/material.dart';
import 'new_invoice_form.dart';
import 'invoicebuilder.dart';
class InvoiceWithPreview extends StatefulWidget {
  @override
  _InvoiceWithPreviewState createState() => _InvoiceWithPreviewState();
}

class _InvoiceWithPreviewState extends State<InvoiceWithPreview> {


  // @override
  // Widget build(BuildContext context) {
  //
  //    return Scaffold(
  //         appBar: AppBar(
  //           title: Text("Invoice"),
  //         ),
  //        body: _getInvoiceBuilderForm());
  //
  // }

  Widget _getInvoiceBuilderForm(){
    return NewInvoiceForm(isEdit: false,);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title:Text("Invoice Builder")),
      body: _getInvoiceBuilderForm(),
    );
  }

}
