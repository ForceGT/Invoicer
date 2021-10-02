import 'package:flutter/material.dart';
import 'invoice/new_invoice_form.dart';

class InvoiceWithPreview extends StatefulWidget {
  @override
  _InvoiceWithPreviewState createState() => _InvoiceWithPreviewState();

  bool _isEstimate;
  InvoiceWithPreview({isEstimate}):_isEstimate=isEstimate;
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

  Widget _getInvoiceBuilderForm(bool isEstimate){
    return NewInvoiceForm(isEstimate: isEstimate,);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title:Text(widget._isEstimate?"Estimate Builder":"Invoice Builder")),
      body: _getInvoiceBuilderForm(widget._isEstimate),
    );
  }

}
